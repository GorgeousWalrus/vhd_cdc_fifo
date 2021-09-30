library ieee;
use ieee.std_logic_1164.all;
use ieee.numeric_std.all;

entity fifo_tb is
end;

architecture bench of fifo_tb is

  component fifo
    generic (
      DWIDTH_g : natural;
      DEPTH_g : natural;
      ENABLE_ALMOST_FLAG_g : natural;
      AF_DISTANCE_g : natural;
      AE_DISTANCE_g : natural
    );
    port (
      clk : in std_logic;
      rstn : in std_logic;
      din_i : in std_logic_vector(DWIDTH_g - 1 downto 0);
      we_i : in std_logic;
      re_i : in std_logic;
      dout_o : out std_logic_vector(DWIDTH_g - 1 downto 0);
      E_o : out std_logic;
      F_o : out std_logic;
      AE_o : out std_logic;
      AF_o : out std_logic
    );
  end component;

  -- Clock period
  constant clk_period : time := 5 ns;
  -- Generics
  constant DWIDTH_g : natural := 8;
  constant DEPTH_g : natural := 8;
  constant ENABLE_ALMOST_FLAG_g : natural := 1;
  constant AF_DISTANCE_g : natural := 1;
  constant AE_DISTANCE_g : natural := 1;

  -- Ports
  signal clk : std_logic;
  signal rstn : std_logic;
  signal din_i : std_logic_vector(DWIDTH_g - 1 downto 0);
  signal we_i : std_logic;
  signal re_i : std_logic;
  signal dout_o : std_logic_vector(DWIDTH_g - 1 downto 0);
  signal E_o : std_logic;
  signal F_o : std_logic;
  signal AE_o : std_logic;
  signal AF_o : std_logic;

begin

  fifo_inst : fifo
  generic map(
    DWIDTH_g => DWIDTH_g,
    DEPTH_g => DEPTH_g,
    ENABLE_ALMOST_FLAG_g => ENABLE_ALMOST_FLAG_g,
    AF_DISTANCE_g => AF_DISTANCE_g,
    AE_DISTANCE_g => AE_DISTANCE_g
  )
  port map(
    clk => clk,
    rstn => rstn,
    din_i => din_i,
    we_i => we_i,
    re_i => re_i,
    dout_o => dout_o,
    E_o => E_o,
    F_o => F_o,
    AE_o => AE_o,
    AF_o => AF_o
  );

  rstn <= '0', '1' after 15 ns;

  clk_process : process
  begin
    clk <= '1';
    wait for clk_period/2;
    clk <= '0';
    wait for clk_period/2;
  end process clk_process;

  stimuli : process
  begin
    we_i <= '0';
    re_i <= '0';
    din_i <= (others => '0');
    wait until rstn = '1';
    wait for 4 ns;
    din_i <= x"de";
    we_i <= '1';
    wait for 5 ns;
    din_i <= x"ad";
    we_i <= '1';
    re_i <= '1';
    wait for 5 ns;
    assert false report "Test: OK" severity failure;
  end process;

end;