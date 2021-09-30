--! Bidirectional CDC fifo
--!
--! AE/AF flags can be disabled
--!
--! Data width, fifo depth and AE/AF thresholds can be parameterized

library ieee;
use ieee.std_logic_1164.all;
use ieee.math_real.all;
use ieee.numeric_std.all;

entity cdc_fifo is
  generic (
    DWIDTH_g           : natural := 32; --! Data width
    H_L_CLK_RELATION_g : natural := 2;  --! Relation of the clock frequencies (x * low_freq = high_freq)
    DEPTH_H2L_H_g      : natural := 8;  --! Depth of high to low fifo, high side
    DEPTH_H2L_L_g      : natural := 8;  --! Depth of high to low fifo, low side
    DEPTH_L2H_H_g      : natural := 8;  --! Depth of low to high fifo, high side
    DEPTH_L2H_L_g      : natural := 8;  --! Depth of low to high fifo, low side
    H_ENABLE_AE_FLAG_g : natural := 1;  --! Enable high fifo almost empty flag
    H_AE_DISTANCE_g    : natural := 1;  --! Distance for high fifo almost empty flag
    H_ENABLE_AF_FLAG_g : natural := 1;  --! Enable high fifo almost full flag
    H_AF_DISTANCE_g    : natural := 1;  --! Distance for high fifo almost full flag
    L_ENABLE_AE_FLAG_g : natural := 1;  --! Enable low fifo almost empty flag
    L_AE_DISTANCE_g    : natural := 1;  --! Distance for low fifo almost empty flag
    L_ENABLE_AF_FLAG_g : natural := 1;  --! Enable low fifo almost full flag
    L_AF_DISTANCE_g    : natural := 1   --! Distance for low fifo almost full flag
  );
  port (
    -- High clock domain signals
    h_clk    : in std_logic;                                --! HCD clock
    h_rstn   : in std_logic;                                --! HCD active low reset
    h_din_i  : in std_logic_vector(DWIDTH_g - 1 downto 0);  --! HCD data in
    h_dout_o : out std_logic_vector(DWIDTH_g - 1 downto 0); --! HCD data out
    h_we_i   : in std_logic;                                --! HCD write enable
    h_re_i   : in std_logic;                                --! HCD read enable
    h_E_o    : out std_logic;                               --! HCD empty flag
    h_F_o    : out std_logic;                               --! HCD full flag
    h_AE_o   : out std_logic;                               --! HCD almost empty flag
    h_AF_o   : out std_logic;                               --! HCD almost full flag
    -- Low clock domain signals
    l_clk    : in std_logic;                                --! LCD clock
    l_rstn   : in std_logic;                                --! LCD active low reset
    l_din_i  : in std_logic_vector(DWIDTH_g - 1 downto 0);  --! LCD data in
    l_dout_o : out std_logic_vector(DWIDTH_g - 1 downto 0); --! LCD data out
    l_we_i   : in std_logic;                                --! LCD write enable
    l_re_i   : in std_logic;                                --! LCD read enable
    l_E_o    : out std_logic;                               --! LCD empty flag
    l_F_o    : out std_logic;                               --! LCD full flag
    l_AE_o   : out std_logic;                               --! LCD almost empty flag
    l_AF_o   : out std_logic                                --! LCD almost full flag
  );
end entity;

architecture rtl of cdc_fifo is
--! Low to high CD fifo
component l2h_cdc_fifo
  generic (
    DWIDTH_g : natural;
    DEPTH_H_g : natural;
    DEPTH_L_g : natural;
    ENABLE_AE_FLAG_g : natural;
    ENABLE_AF_FLAG_g : natural;
    AF_DISTANCE_g : natural;
    AE_DISTANCE_g : natural;
    H_L_CLK_RELATION_g : natural
  );
    port (
    h_clk : in std_logic;
    h_rstn : in std_logic;
    h_dout_o : out std_logic_vector(DWIDTH_g - 1 downto 0);
    h_re_i : in std_logic;
    h_E_o : out std_logic;
    h_AE_o : out std_logic;
    l_clk : in std_logic;
    l_rstn : in std_logic;
    l_din_i : in std_logic_vector(DWIDTH_g - 1 downto 0);
    l_we_i : in std_logic;
    l_F_o : out std_logic;
    l_AF_o : out std_logic
  );
end component;

--! High to low CD fifo
component h2l_cdc_fifo
  generic (
    DWIDTH_g : natural;
    DEPTH_H_g : natural;
    DEPTH_L_g : natural;
    ENABLE_AE_FLAG_g : natural;
    ENABLE_AF_FLAG_g : natural;
    AF_DISTANCE_g : natural;
    AE_DISTANCE_g : natural;
    H_L_CLK_RELATION_g : natural
  );
    port (
    h_clk : in std_logic;
    h_rstn : in std_logic;
    h_din_i : in std_logic_vector(DWIDTH_g - 1 downto 0);
    h_we_i : in std_logic;
    h_F_o : out std_logic;
    h_AF_o : out std_logic;
    l_clk : in std_logic;
    l_rstn : in std_logic;
    l_dout_o : out std_logic_vector(DWIDTH_g - 1 downto 0);
    l_re_i : in std_logic;
    l_E_o : out std_logic;
    l_AE_o : out std_logic
  );

end component;

begin

--! Low to high CD fifo
l2h_cdc_fifo_inst : l2h_cdc_fifo
  generic map (
    DWIDTH_g => DWIDTH_g,
    DEPTH_H_g => DEPTH_L2H_H_g,
    DEPTH_L_g => DEPTH_L2H_L_g,
    ENABLE_AE_FLAG_g => H_ENABLE_AE_FLAG_g,
    ENABLE_AF_FLAG_g => L_ENABLE_AF_FLAG_g,
    AF_DISTANCE_g => L_AF_DISTANCE_g,
    AE_DISTANCE_g => H_AE_DISTANCE_g,
    H_L_CLK_RELATION_g => H_L_CLK_RELATION_g
  )
  port map (
    h_clk => h_clk,
    h_rstn => h_rstn,
    h_dout_o => h_dout_o,
    h_re_i => h_re_i,
    h_E_o => h_E_o,
    h_AE_o => h_AE_o,
    l_clk => l_clk,
    l_rstn => l_rstn,
    l_din_i => l_din_i,
    l_we_i => l_we_i,
    l_F_o => l_F_o,
    l_AF_o => l_AF_o
  );

--! High to low CD fifo
h2l_cdc_fifo_inst : h2l_cdc_fifo
  generic map (
    DWIDTH_g => DWIDTH_g,
    DEPTH_H_g => DEPTH_H2L_H_g,
    DEPTH_L_g => DEPTH_H2L_L_g,
    ENABLE_AE_FLAG_g => L_ENABLE_AE_FLAG_g,
    ENABLE_AF_FLAG_g => H_ENABLE_AF_FLAG_g,
    AF_DISTANCE_g => H_AF_DISTANCE_g,
    AE_DISTANCE_g => L_AE_DISTANCE_g,
    H_L_CLK_RELATION_g => H_L_CLK_RELATION_g
  )
  port map (
    h_clk => h_clk,
    h_rstn => h_rstn,
    h_din_i => h_din_i,
    h_we_i => h_we_i,
    h_F_o => h_F_o,
    h_AF_o => h_AF_o,
    l_clk => l_clk,
    l_rstn => l_rstn,
    l_dout_o => l_dout_o,
    l_re_i => l_re_i,
    l_E_o => l_E_o,
    l_AE_o => l_AE_o
  ); 

end architecture;
