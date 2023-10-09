library IEEE;
use IEEE.STD_LOGIC_1164.ALL;
use IEEE.NUMERIC_STD.ALL;
--use IEEE.STD_LOGIC_ARITH.ALL;
--use IEEE.STD_LOGIC_USIGNED.ALL;

entity integer_test is
    Port ( sysclk : in std_logic;
           btn : in std_logic_vector(0 downto 0); -- we dont have a reset-button in zynq, using btn(0) instead
           ja : out STD_LOGIC_VECTOR (7 downto 0);
           jb : out STD_LOGIC_VECTOR (7 downto 0)
           );
end integer_test;

architecture rtl of integer_test is

    signal int_a: integer := 0;
    signal int_b: integer range 0 to 31 := 0;
    
    -- In Zynq we dont have a dedicated reset-button unless we assign some user button for that
    -- Now, just faking a reset which is always high = inactive
    -- This way our desing is cleaner and we can take the reset in use later on.
    signal negative_Reset: std_logic := '1'; -- for simulation, initialize to high = inactive

begin

    negative_Reset <= not btn(0);
    --negative_Reset <= '1'; -- fake reset, always inactive
    counter1: process (sysclk, negative_Reset) is
    begin
        if (negative_Reset ='0') then
            int_a <= 0;
            int_b <= 0;
        elsif sysclk'event and sysclk='1' then
            if int_b = 25 then
               int_b <= 0;
            else
                int_b <= int_b + 1;
            end if;
            int_a <= int_a + 1;
            --int_b <= int_b + 1;
        end if; --clk/rst
    end process counter1;
    
    -- grab n lowest bits of counter to I/O-pins
    ja <= std_logic_vector(to_unsigned(int_a, ja'length));
    jb <= std_logic_vector(to_unsigned(int_b, jb'length));

end rtl;


-- begin
--  if n_Rst = '0' then
--     Cnt_int <= (others => '0');