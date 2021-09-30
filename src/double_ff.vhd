--! Double Flipflopping for CDC low -> high clock domain

library ieee;
use ieee.std_logic_1164.all;

entity double_ff is
  generic (
    DWIDTH_g : natural := 1 --! Width of the double flopping
  );
  port (
    clk : in std_logic;                               --! High clock domain clock input
    d   : in std_logic_vector(DWIDTH_g - 1 downto 0); --! Data input
    q   : out std_logic_vector(DWIDTH_g - 1 downto 0) --! Data output
  );
end entity;

architecture rtl of double_ff is
  signal d_buf : std_logic_vector(DWIDTH_g - 1 downto 0);
begin
  process (clk)
  begin
    if rising_edge(clk) then
      d_buf <= d;
      q     <= d_buf;
    end if;
  end process;
end architecture;
