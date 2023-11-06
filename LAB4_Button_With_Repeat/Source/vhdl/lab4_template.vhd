library IEEE;
use IEEE.STD_LOGIC_1164.ALL;
use IEEE.NUMERIC_STD.ALL;
--use IEEE.STD_LOGIC_ARITH.ALL;
--use IEEE.STD_LOGIC_USIGNED.ALL;

entity clock_divider is
  generic (
    OUTPUT_FREQ : integer := 25_000_000 -- output frequency in Hz
  );
  port (
    i_clk   : in std_logic;
    i_reset : in std_logic;
    o_clk   : out std_logic
  );
end entity clock_divider;

architecture Behavioral of clock_divider is
  constant INPUT_FREQ : integer := 125_000_000; -- input frequency in Hz
  constant COUNT_VAL  : integer := INPUT_FREQ / (2 * OUTPUT_FREQ) - 1;
  signal count        : integer := 0;
  signal tmp_clk      : std_logic := '0';
begin
  process (i_clk, i_reset)
  begin
    if i_reset = '1' then
      count <= 0;
      tmp_clk <= '0';
    elsif rising_edge(i_clk) then
      if count = COUNT_VAL then
        count <= 0;
        tmp_clk <= not tmp_clk; -- toggle the tmp_clk signal
      else
        count <= count + 1;
      end if;
    end if;
  end process;

  o_clk <= tmp_clk;
end architecture Behavioral;


-- Test Bench
entity tb_clock_divider is
end entity tb_clock_divider;

architecture sim of tb_clock_divider is
  signal i_clk, i_reset, o_clk : std_logic;
  constant CLK_PERIOD : time := 8 ns; -- corresponds to 125 MHz
begin
  uut: entity work.clock_divider
    generic map (25_000_000)
    port map (i_clk, i_reset, o_clk);

  clk_gen: process
  begin
    while true loop
      i_clk <= not i_clk;
      wait for CLK_PERIOD / 2;
    end loop;
  end process;

  stimulus: process
  begin
    i_reset <= '1';
    wait for CLK_PERIOD;
    i_reset <= '0';
    wait;
  end process;
end architecture sim;




