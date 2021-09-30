--! CDC fifo for transfer from low to high frequency clock domain
--!
--! AE/AF flags can be disabled
--!
--! Data width, fifo depth and AE/AF thresholds can be parameterized

library ieee;
use ieee.std_logic_1164.all;
use ieee.math_real.all;
use ieee.numeric_std.all;

entity l2h_cdc_fifo is
  generic (
    DWIDTH_g           : natural := 32; --! Data width
    DEPTH_H_g          : natural := 8;  --! High clock domain fifo depth
    DEPTH_L_g          : natural := 8;  --! Low clock domain fifo depth
    ENABLE_AE_FLAG_g   : natural := 1;  --! Enable almost empty flag
    ENABLE_AF_FLAG_g   : natural := 1;  --! Enable almost full flag
    AF_DISTANCE_g      : natural := 1;  --! Distance for almost full flag
    AE_DISTANCE_g      : natural := 1;  --! Distance for almost empty flag
    H_L_CLK_RELATION_g : natural := 2   --! Relation of the clock frequencies (x * low_freq = high_freq)
  );
  port (
    -- High clock domain ports
    h_clk    : in std_logic;                                --! High clock domain clock
    h_rstn   : in std_logic;                                --! High clock domain active low reset
    h_dout_o : out std_logic_vector(DWIDTH_g - 1 downto 0); --! High clock domain data in
    h_re_i   : in std_logic;                                --! High clock domain write enable
    h_E_o    : out std_logic;                               --! High clock domain full flag
    h_AE_o   : out std_logic;                               --! High clock domain almost full flag
    -- Low clock domain ports
    l_clk   : in std_logic;                               --! Low clock domain clock
    l_rstn  : in std_logic;                               --! Low clock domain active low reset
    l_din_i : in std_logic_vector(DWIDTH_g - 1 downto 0); --! Low clock domain data out
    l_we_i  : in std_logic;                               --! Low clock domain read enable
    l_F_o   : out std_logic;                              --! Low clock domain empty flag
    l_AF_o  : out std_logic                               --! Low clock domain almost empty flag
  );
end entity;

architecture rtl of l2h_cdc_fifo is
  --! Single clock fifo component
  component fifo
    generic (
      DWIDTH_g             : natural;
      DEPTH_g              : natural;
      ENABLE_ALMOST_FLAG_g : natural;
      AF_DISTANCE_g        : natural;
      AE_DISTANCE_g        : natural
    );
    port (
      clk    : in std_logic;
      rstn   : in std_logic;
      din_i  : in std_logic_vector(DWIDTH_g - 1 downto 0);
      we_i   : in std_logic;
      re_i   : in std_logic;
      dout_o : out std_logic_vector(DWIDTH_g - 1 downto 0);
      E_o    : out std_logic;
      F_o    : out std_logic;
      AE_o   : out std_logic;
      AF_o   : out std_logic
    );
  end component;

  --! Double flip-flopping component
  component double_ff
    generic (
      DWIDTH_g : natural
    );
    port (
      clk : in std_logic;
      d   : in std_logic_vector(DWIDTH_g - 1 downto 0);
      q   : out std_logic_vector(DWIDTH_g - 1 downto 0)
    );
  end component;

  constant COUNTER_SIZE_c : natural := natural(ceil(log2(real(H_L_CLK_RELATION_g)))); --! Counter size for high-low freq relation

  signal h_tick_counter_s : std_logic_vector(COUNTER_SIZE_c downto 0); --! Counter for high-low freq relation
  signal h_we_s           : std_logic;                                 --! High fifo write enable
  signal h_F_s            : std_logic;                                 --! High fifo full
  signal h_AF_s           : std_logic;                                 --! High fifo almost full
  signal l_re_s           : std_logic;                                 --! Low fifo read enable
  signal l_lE_s           : std_logic;                                 --! Low fifo empty in low clock domain
  signal h_lE_s           : std_logic;                                 --! Low fifo empty in high clock domain
  signal l_lAE_s          : std_logic;                                 --! Low fifo almost empty in low clock domain
  signal h_lAE_s          : std_logic;                                 --! Low fifo almost emtpy in high clock domain
  signal h_lclk_s         : std_logic;                                 --! Low clock in high clock domain
  signal h_lclk_old_s     : std_logic;                                 --! Low clock in high clock domain buffer
  signal wait_low_fifo_s  : std_logic;                                 --! Signal to sync with low fifo
  signal l_ldout_s         : std_logic_vector(DWIDTH_g - 1 downto 0);   --! Low fifo data out
  signal h_ldout_s         : std_logic_vector(DWIDTH_g - 1 downto 0);   --! Low fifo data out
  signal lh_data_s        : std_logic_vector(DWIDTH_g - 1 downto 0);   --! Data buffer

begin

  --! High clock domain FIFO
  --! Fifo for incoming data from high clock domain
  h_fifo : fifo
  generic map(
    DWIDTH_g             => DWIDTH_g,
    DEPTH_g              => DEPTH_H_g,
    ENABLE_ALMOST_FLAG_g => ENABLE_AF_FLAG_g,
    AF_DISTANCE_g        => AF_DISTANCE_g,
    AE_DISTANCE_g        => 0
  )
  port map(
    clk    => h_clk,
    rstn   => h_rstn,
    din_i  => lh_data_s,
    we_i   => h_we_s,
    re_i   => h_re_i,
    dout_o => h_dout_o,
    E_o    => h_E_o,
    F_o    => h_F_s,
    AE_o   => h_AE_o,
    AF_o   => h_AF_s
  );

  --! Low clock domain FIFO
  --! Fifo for outgoing data to low clock domain
  l_fifo : fifo
  generic map(
    DWIDTH_g             => DWIDTH_g,
    DEPTH_g              => DEPTH_L_g,
    ENABLE_ALMOST_FLAG_g => ENABLE_AE_FLAG_g,
    AF_DISTANCE_g        => 0,
    AE_DISTANCE_g        => AE_DISTANCE_g
  )
  port map(
    clk    => l_clk,
    rstn   => l_rstn,
    din_i  => l_din_i,
    we_i   => l_we_i,
    re_i   => l_re_s,
    dout_o => l_ldout_s,
    E_o    => l_lE_s,
    F_o    => l_F_o,
    AE_o   => l_lAE_s,
    AF_o   => l_AF_o
  );

  --! Double flop the low fifo data
  l_fifo_dout_double_ff : double_ff
  generic map (
    DWIDTH_g => DWIDTH_g
  )
  port map (
    clk => h_clk,
    d => l_ldout_s,
    q => h_ldout_s
  );

  --! Double flop the low fifo full signal
  l_fifo_F_double_ff : double_ff
  generic map(
    DWIDTH_g => 1
  )
  port map(
    clk  => h_clk,
    d(0) => l_lE_s,
    q(0) => h_lE_s
  );

  --! Double flop the low fifo almost full signal
  l_fifo_AF_double_ff : double_ff
  generic map(
    DWIDTH_g => 1
  )
  port map(
    clk  => h_clk,
    d(0) => l_lAE_s,
    q(0) => h_lAE_s
  );

  --! Double flop the low clock
  l_clk_double_ff : double_ff
  generic map(
    DWIDTH_g => 1
  )
  port map(
    clk  => h_clk,
    d(0) => l_clk,
    q(0) => h_lclk_s
  );

  --! Process to transfer the data from low freq clk to high freq clk
  transfer_data_p : process (h_clk, h_rstn)
  begin
    if h_rstn = '0' then
      h_lclk_old_s     <= '0';
      h_we_s           <= '0';
      l_re_s           <= '0';
      lh_data_s        <= (others => '0');
      wait_low_fifo_s  <= '0';
      h_tick_counter_s <= (others => '0');

    elsif rising_edge(h_clk) then
      h_lclk_old_s <= h_lclk_s;
      h_we_s       <= '0';

      if wait_low_fifo_s = '1' then
        --! Wait for low fifo to act
        if unsigned(h_tick_counter_s) = (H_L_CLK_RELATION_g / 2 + 1) then
          wait_low_fifo_s  <= '0';
          l_re_s           <= '0';
          h_tick_counter_s <= (others => '0');
        else
          h_tick_counter_s <= std_logic_vector(unsigned(h_tick_counter_s) + 1);
        end if;
      elsif h_lE_s = '0' and h_F_s = '0' then
        --! Low fifo has data and high fifo has space -> copy data
        if h_lclk_old_s /= h_lclk_s and h_lclk_old_s = '1' then
          lh_data_s       <= h_ldout_s;
          h_we_s          <= '1';
          l_re_s          <= '1';
          wait_low_fifo_s <= '1';
        end if;
      end if;
    end if;
  end process;
end architecture;