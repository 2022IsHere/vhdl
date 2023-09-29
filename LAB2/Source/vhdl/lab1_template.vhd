----------------------------------------------------------------------------------
-- Company: 
-- Engineer: 
-- 
-- Create Date: 08/09/2019 10:47:12 AM
-- Design Name: 
-- Module Name: led_thingy_top - Behavioral
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

entity led_thingy_top is
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
end led_thingy_top;

architecture Behavioral of led_thingy_top is
   
    -- group of RGB led signals
    signal RGB_Led_4: std_logic_vector (0 to 2);
    -- group of RGB led signals
    signal RGB_Led_5: std_logic_vector (0 to 2);

    signal Temp_Led_1: std_logic_vector (3 downto 0);
    
    signal Temp_Led_2: std_logic_vector (3 downto 0);

begin

    with btn(1 downto 0) select          
    Temp_Led_1 <= "0010" when "01", --button0, !button1 > led1 is on
                  "0100" when "10", --button1, !button0 > led2 is on
                  "1000" when "11", --button1, button0  > led3 is on
                  "0001" when others; --!button0, !button1 > led0 is on
   
    -- Some "housekeeping" first
    -- map signal "RGB_Led_4" to actual output ports
    led4_r <= RGB_Led_4(2);
    led4_g <= RGB_Led_4(1);
    led4_b <= RGB_Led_4(0);
    
    -- map signal "RGB_Led_5" to actual output ports
    led5_r <= RGB_Led_5(2);
    led5_g <= RGB_Led_5(1);
    led5_b <= RGB_Led_5(0);
            
                
    -- Control of RGB LED 5
    with btn(1 downto 0) select
    RGB_Led_4 <=   "001" when "01", --red
                   "010" when "10", --green
                   "100" when "11", --blue
                   "000" when others; --off
                      
                    
   with sw (1 downto 0) select
   RGB_Led_5 <=     RGB_Led_4 when "01", --when sw0 is on and sw1 off, rg_led_4 behavior is set to rgb_led_5
                    "000" when "00",
                    "111" when others; --when sw0 and sw1 off, rgb_led_5 is off
        
         
   -- Temp_Led_2 assignment
   Temp_Led_2(3) <= btn(0) nand btn(1);
   Temp_Led_2(2) <= btn(0) or btn(1);
   Temp_Led_2(1) <= btn(0) xor btn(1);
   Temp_Led_2(0) <= btn(0) and btn(1); 
         
         

    
    -- led assignment
    led <= Temp_Led_1 when sw(1) = '0' else Temp_Led_2;
    
                        
end Behavioral;