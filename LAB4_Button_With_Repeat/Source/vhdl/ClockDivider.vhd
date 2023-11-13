library IEEE;
use IEEE.STD_LOGIC_1164.ALL;
use IEEE.NUMERIC_STD.ALL;
--use IEEE.STD_LOGIC_ARITH.ALL;
--use IEEE.STD_LOGIC_USIGNED.ALL;

entity clock_divider is
  generic (
    OUTPUT_FREQ : integer := 12_500_000 -- output frequency in Hz
  );
  port (
    i_clk   : in std_logic;
    btn_reset : in std_logic;
    o_clk   : out std_logic
  );
end entity clock_divider;

architecture Behavioral of clock_divider is
  constant INPUT_FREQ : integer := 125_000_000; -- input frequency in Hz
  constant COUNT_VAL  : integer := INPUT_FREQ / (2 * OUTPUT_FREQ) - 1;
  signal count        : integer := 0;
  signal tmp_clk      : std_logic := '0';
  signal n_reset      : std_logic; -- Internal active low reset
  
begin
  -- Assert to check OUTPUT_FREQ is within the valid range
  assert OUTPUT_FREQ > 0 and OUTPUT_FREQ < INPUT_FREQ / 2
  report "Output frequency is out of valid range."
  severity error;
    
  --Inverting the active high reset button to active low
  n_reset <= not btn_reset;
  
  process (i_clk, n_reset)
  begin
    if n_reset = '0' then -- Active-low reset
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



