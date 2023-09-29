----------------------------------------------------------------------------------
-- Company: 
-- Engineer: 
-- 
-- Create Date: 09/25/2023 10:26:37 AM
-- Design Name: 
-- Module Name: lab2_test - Behavioral
-- Project Name: 
-- Target Devices: 
-- Tool Versions: 
-- Description: 
-- 
-- Dependencies: 
-- 
-- Revision:
-- Revision 0.01 - File Created
-- Additional Comments:
-- 
----------------------------------------------------------------------------------


library IEEE;
use IEEE.STD_LOGIC_1164.ALL;


entity lab2_test is
  Port (
    btn :       in  STD_LOGIC_VECTOR(1 downto 0);
    sw :        in  STD_LOGIC_VECTOR(1 downto 0);
    led :       out  STD_LOGIC_VECTOR (3 downto 0);
    led4_r :    out STD_LOGIC;
    led4_g :    out STD_LOGIC;
    led4_b :    out STD_LOGIC;
    led5_r :    out STD_LOGIC;
    led5_g :    out STD_LOGIC;
    led5_b :    out STD_LOGIC
  );
end lab2_test;

architecture Behavioral of lab2_test is

    -- group of RGB led signals
    signal RGB_Led_4: std_logic_vector (0 to 2);
    -- group of RGB led signals
    signal RGB_Led_5: std_logic_vector (0 to 2);

    signal Temp_Led_1: std_logic_vector (3 downto 0);
    
    signal Temp_Led_2: std_logic_vector (3 downto 0);

begin

    -- Some "housekeeping" first
    -- map signal "RGB_Led_4" to actual output ports
    led4_r <= RGB_Led_4(2);
    led4_g <= RGB_Led_4(1);
    led4_b <= RGB_Led_4(0);
    
    -- map signal "RGB_Led_5" to actual output ports
    led5_r <= RGB_Led_5(2);
    led5_g <= RGB_Led_5(1);
    led5_b <= RGB_Led_5(0);
    
        -- Control of RGB LED 4
    RGB_Led_4(2) <= '1' when btn = "01" else 
                   '0' when btn = "10" else
                   '0' when btn = "11" else '0'; -- Red
    RGB_Led_4(1) <= '0' when btn = "01" else 
                   '1' when btn = "10" else
                   '0' when btn = "11" else '0'; -- Green
    RGB_Led_4(0) <= '0' when btn = "01" else 
                   '0' when btn = "10" else
                   '1' when btn = "11" else '0'; -- Blue
    
    -- Control of RGB LED 5
    RGB_Led_5 <= RGB_Led_4 when sw = "01" else 
                "111" when (sw = "10" or sw = "11") else "000";
                
                
       -- Temp_Led_1 assignment
    Temp_Led_1 <= "0010" when btn = "01" else 
                 "0100" when btn = "10" else 
                 "1000" when btn = "11" else "0001";
    
    -- Temp_Led_2 assignment
    Temp_Led_2 <= "1000" when btn = "00" else 
                 "1110" when (btn = "01" or btn = "10") else 
                 "0101" when btn = "11" else "0000";
    
    -- led assignment
    led <= Temp_Led_1 when sw = "01" else 
          Temp_Led_2 when (sw = "10" or sw = "11") else Temp_Led_1;
    
        

end Behavioral;
