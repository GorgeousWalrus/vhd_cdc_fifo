--! Fifo with single clock.
--! 
--! Almost empty/full flags can be enabled/disabled

library ieee;
use ieee.std_logic_1164.all;
use ieee.math_real.all;
use ieee.numeric_std.all;

entity fifo is
  generic (
    DWIDTH_g             : natural := 32; --! Data width
    DEPTH_g              : natural := 16; --! Depth of the FIFO (minimum: 1, suggested to be power of 2)
    ENABLE_ALMOST_FLAG_g : natural := 1;  --! Enable/Disable almost empty/full flags
    AF_DISTANCE_g        : natural := 1;  --! Distance for almost full flag
    AE_DISTANCE_g        : natural := 1   --! Distance for almost empty flag
  );
  port (
    clk    : in std_logic;                                --! Clock in
    rstn   : in std_logic;                                --! Active low reset
    din_i  : in std_logic_vector(DWIDTH_g - 1 downto 0);  --! Data in
    we_i   : in std_logic;                                --! Write enable (want to write)
    re_i   : in std_logic;                                --! Read enable (want to read)
    dout_o : out std_logic_vector(DWIDTH_g - 1 downto 0); --! Data out
    E_o    : out std_logic;                               --! Empty flag
    F_o    : out std_logic;                               --! Full flag
    AE_o   : out std_logic;                               --! Almost empty flag
    AF_o   : out std_logic                                --! Almost full flag
  );
end entity;

architecture rtl of fifo is
  constant POINTER_SIZE_c : natural := natural(ceil(log2(real(DEPTH_g)))); --! Size of the write pointer (log2 of depth)
  constant FULL_c         : integer := (DEPTH_g);                          --! FIFO end
  constant EMPTY_c        : integer := 0;                                  --! FIFO start
  constant ALMOST_FULL_c  : integer := (DEPTH_g - AF_DISTANCE_g);          --! FIFO almost full
  constant ALMOST_EMPTY_c : integer := (AE_DISTANCE_g);                    --! FIFO almost empty

  signal write_pointer_s : std_logic_vector(POINTER_SIZE_c downto 0); --! Pointer of write address
  signal empty_s         : std_logic;                                 --! internal empty signal
  signal full_s          : std_logic;                                 --! internal full signal
  signal almost_empty_s  : std_logic;                                 --! internal almost empty signal
  signal almost_full_s   : std_logic;                                 --! internal almost full signal

  type t_fifo_mem is array (0 to DEPTH_g) of std_logic_vector(DWIDTH_g - 1 downto 0); --! FIFO memory type
  signal fifo_mem : t_fifo_mem;                                                       --! FIFO memory
begin
  --! Write signals to ports
  dout_o <= fifo_mem(0);
  E_o    <= empty_s;
  F_o    <= full_s;
  AE_o   <= almost_empty_s;
  AF_o   <= almost_full_s;

  --! Sets the empty/full/almost empty/almost full flags
  --! Only sets almost empty and almost full flags if enabled by generic
  E_F_AE_AF_process : process (write_pointer_s)
  begin
    empty_s        <= '0';
    full_s         <= '0';
    almost_empty_s <= '0';
    almost_full_s  <= '0';
    if to_integer(unsigned(write_pointer_s)) = FULL_c then
      full_s <= '1';
    end if;
    if to_integer(unsigned(write_pointer_s)) = EMPTY_c then
      empty_s <= '1';
    end if;
    if (ENABLE_ALMOST_FLAG_g = 1) then
      if to_integer(unsigned(write_pointer_s)) >= ALMOST_FULL_c then
        almost_full_s <= '1';
      end if;
      if to_integer(unsigned(write_pointer_s)) <= ALMOST_EMPTY_c then
        almost_empty_s                           <= '1';
      end if;
    end if;
  end process;

  --! Handles read and write actions:
  --!  * Simultaneous read&write
  --!  * Only write
  --!  * Only read
  read_write_process : process (clk, rstn)
  begin
    if rstn = '0' then
      write_pointer_s <= (others => '0');
      fifo_mem        <= (others => (others => '0'));
    elsif rising_edge(clk) then
      --! Reading and writing at the same time -> shift and dont increase write pointer
      if (full_s = '0' and we_i = '1' and empty_s = '0' and re_i = '1') then
        for i in 0 to DEPTH_g - 2 loop
          fifo_mem(i) <= fifo_mem(i + 1);
        end loop;
        fifo_mem(to_integer(unsigned(write_pointer_s(POINTER_SIZE_c - 1 downto 0)) - 1)) <= din_i;
        --! Writing -> increase write pointer
      elsif (full_s = '0' and we_i = '1') then
        fifo_mem(to_integer(unsigned(write_pointer_s(POINTER_SIZE_c - 1 downto 0)))) <= din_i;
        write_pointer_s                                                              <= std_logic_vector(unsigned(write_pointer_s) + 1);
        --! Reading -> shift & decrease write pointer
      elsif (empty_s = '0' and re_i = '1') then
        for i in 0 to DEPTH_g - 2 loop
          fifo_mem(i) <= fifo_mem(i + 1);
        end loop;
        write_pointer_s <= std_logic_vector(unsigned(write_pointer_s) - 1);
      end if;
    end if;
  end process;
end architecture;
