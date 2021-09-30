library ieee;
use ieee.std_logic_1164.all;
use ieee.numeric_std.all;

entity cdc_fifo_tb is
end;

architecture bench of cdc_fifo_tb is

  component cdc_fifo
    generic (
      DWIDTH_g           : natural;
      H_L_CLK_RELATION_g : natural;
      DEPTH_H2L_H_g      : natural;
      DEPTH_H2L_L_g      : natural;
      DEPTH_L2H_H_g      : natural;
      DEPTH_L2H_L_g      : natural;
      H_ENABLE_AE_FLAG_g : natural;
      H_AE_DISTANCE_g    : natural;
      H_ENABLE_AF_FLAG_g : natural;
      H_AF_DISTANCE_g    : natural;
      L_ENABLE_AE_FLAG_g : natural;
      L_AE_DISTANCE_g    : natural;
      L_ENABLE_AF_FLAG_g : natural;
      L_AF_DISTANCE_g    : natural
    );
    port (
      h_clk    : in std_logic;
      h_rstn   : in std_logic;
      h_din_i  : in std_logic_vector(DWIDTH_g - 1 downto 0);
      h_dout_o : out std_logic_vector(DWIDTH_g - 1 downto 0);
      h_we_i   : in std_logic;
      h_re_i   : in std_logic;
      h_E_o    : out std_logic;
      h_F_o    : out std_logic;
      h_AE_o   : out std_logic;
      h_AF_o   : out std_logic;
      l_clk    : in std_logic;
      l_rstn   : in std_logic;
      l_din_i  : in std_logic_vector(DWIDTH_g - 1 downto 0);
      l_dout_o : out std_logic_vector(DWIDTH_g - 1 downto 0);
      l_we_i   : in std_logic;
      l_re_i   : in std_logic;
      l_E_o    : out std_logic;
      l_F_o    : out std_logic;
      l_AE_o   : out std_logic;
      l_AF_o   : out std_logic
    );
  end component;

  -- Clock period
  constant h_clk_period : time := 10 ns;
  constant l_clk_period : time := 29 ns;
  -- Generics
  constant DWIDTH_g           : natural := 8;
  constant H_L_CLK_RELATION_g : natural := 3;
  constant DEPTH_H2L_H_g      : natural := 8;
  constant DEPTH_H2L_L_g      : natural := 8;
  constant DEPTH_L2H_H_g      : natural := 8;
  constant DEPTH_L2H_L_g      : natural := 8;
  constant H_ENABLE_AE_FLAG_g : natural := 1;
  constant H_AE_DISTANCE_g    : natural := 1;
  constant H_ENABLE_AF_FLAG_g : natural := 1;
  constant H_AF_DISTANCE_g    : natural := 1;
  constant L_ENABLE_AE_FLAG_g : natural := 1;
  constant L_AE_DISTANCE_g    : natural := 1;
  constant L_ENABLE_AF_FLAG_g : natural := 1;
  constant L_AF_DISTANCE_g    : natural := 1;

  -- Ports
  signal h_clk    : std_logic;
  signal h_rstn   : std_logic;
  signal h_din_i  : std_logic_vector(DWIDTH_g - 1 downto 0);
  signal h_dout_o : std_logic_vector(DWIDTH_g - 1 downto 0);
  signal h_we_i   : std_logic;
  signal h_re_i   : std_logic;
  signal h_E_o    : std_logic;
  signal h_F_o    : std_logic;
  signal h_AE_o   : std_logic;
  signal h_AF_o   : std_logic;
  signal l_clk    : std_logic;
  signal l_rstn   : std_logic;
  signal l_din_i  : std_logic_vector(DWIDTH_g - 1 downto 0);
  signal l_dout_o : std_logic_vector(DWIDTH_g - 1 downto 0);
  signal l_we_i   : std_logic;
  signal l_re_i   : std_logic;
  signal l_E_o    : std_logic;
  signal l_F_o    : std_logic;
  signal l_AE_o   : std_logic;
  signal l_AF_o   : std_logic;

  -- TB Signals
  signal lh_data : std_logic_vector(DWIDTH_g - 1 downto 0);
  signal lh_cmp : std_logic_vector(DWIDTH_g - 1 downto 0);
  signal hl_data : std_logic_vector(DWIDTH_g - 1 downto 0);
  signal hl_cmp : std_logic_vector(DWIDTH_g - 1 downto 0);

begin

  cdc_fifo_inst : cdc_fifo
  generic map(
    DWIDTH_g           => DWIDTH_g,
    H_L_CLK_RELATION_g => H_L_CLK_RELATION_g,
    DEPTH_H2L_H_g      => DEPTH_H2L_H_g,
    DEPTH_H2L_L_g      => DEPTH_H2L_L_g,
    DEPTH_L2H_H_g      => DEPTH_L2H_H_g,
    DEPTH_L2H_L_g      => DEPTH_L2H_L_g,
    H_ENABLE_AE_FLAG_g => H_ENABLE_AE_FLAG_g,
    H_AE_DISTANCE_g    => H_AE_DISTANCE_g,
    H_ENABLE_AF_FLAG_g => H_ENABLE_AF_FLAG_g,
    H_AF_DISTANCE_g    => H_AF_DISTANCE_g,
    L_ENABLE_AE_FLAG_g => L_ENABLE_AE_FLAG_g,
    L_AE_DISTANCE_g    => L_AE_DISTANCE_g,
    L_ENABLE_AF_FLAG_g => L_ENABLE_AF_FLAG_g,
    L_AF_DISTANCE_g    => L_AF_DISTANCE_g
  )
  port map(
    h_clk    => h_clk,
    h_rstn   => h_rstn,
    h_din_i  => h_din_i,
    h_dout_o => h_dout_o,
    h_we_i   => h_we_i,
    h_re_i   => h_re_i,
    h_E_o    => h_E_o,
    h_F_o    => h_F_o,
    h_AE_o   => h_AE_o,
    h_AF_o   => h_AF_o,
    l_clk    => l_clk,
    l_rstn   => l_rstn,
    l_din_i  => l_din_i,
    l_dout_o => l_dout_o,
    l_we_i   => l_we_i,
    l_re_i   => l_re_i,
    l_E_o    => l_E_o,
    l_F_o    => l_F_o,
    l_AE_o   => l_AE_o,
    l_AF_o   => l_AF_o
  );

  h_rstn <= '0', '1' after 30 ns;
  l_rstn <= '0', '1' after 30 ns;

  h_clk_process : process
  begin
    h_clk <= '1';
    wait for h_clk_period/2;
    h_clk <= '0';
    wait for h_clk_period/2;
  end process;

  l_clk_process : process
  begin
    l_clk <= '1';
    wait for l_clk_period/2;
    l_clk <= '0';
    wait for l_clk_period/2;
  end process;

  slow_write : process
  begin
    l_we_i <= '0';
    wait until h_rstn = '1';
    wait until l_clk = '1';
    wait for l_clk_period;
    for i in 0 to 32 loop
      if l_F_o = '1' then
        wait until l_F_o = '0';
        -- wait for h_clk_period/2;
      end if;
      wait for 1 ns;
      l_din_i <= std_logic_vector(to_unsigned(i, l_din_i'length));
      l_we_i <= '1';
      wait for l_clk_period;
      l_we_i <= '0';
    end loop;
  end process;

  fast_read : process
  begin
    h_re_i <= '0';
    wait until h_rstn = '1';
    wait until h_clk = '1';
    wait for h_clk_period * 3;
    for i in 0 to 32 loop
      if h_E_o = '1' then
        wait until h_E_o = '0';
        -- wait for l_clk_period/2;
      end if;
      wait for 1 ns;
      h_re_i <= '1';
      lh_data <= h_dout_o;
      lh_cmp <= std_logic_vector(to_unsigned(i, lh_cmp'length));
      wait for h_clk_period;
      h_re_i <= '0';
      assert lh_data = lh_cmp report "Data mismatch" severity failure;
      wait for 10 * h_clk_period;
    end loop;
  end process;

  fast_write : process
  begin
    h_we_i <= '0';
    wait until h_rstn = '1';
    wait for h_clk_period;
    for i in 0 to 255 loop
      if h_F_o = '1' then
        wait until h_F_o = '0';
        -- wait for h_clk_period/2;
      end if;
      wait for 1 ns;
      h_din_i <= std_logic_vector(to_unsigned(i, h_din_i'length));
      h_we_i <= '1';
      wait for h_clk_period;
      h_we_i <= '0';
    end loop;
  end process;

  slow_read : process
  begin
    l_re_i <= '0';
    wait until h_rstn = '1';
    wait for l_clk_period * 3;
    for i in 0 to 255 loop
      if l_E_o = '1' then
        wait until l_E_o = '0';
        -- wait for l_clk_period/2;
      end if;
      wait for 1 ns;
      l_re_i <= '1';
      hl_data <= l_dout_o;
      hl_cmp <= std_logic_vector(to_unsigned(i, hl_cmp'length));
      wait for l_clk_period;
      l_re_i <= '0';
      assert hl_data = hl_cmp report "Data mismatch" severity failure;
      wait for 2 * l_clk_period;
    end loop;
    wait for l_clk_period;
    assert false report "TEST OK" severity failure;
  end process;

end;
