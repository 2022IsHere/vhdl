----------------------------------------------------------------------------------
-- Company: 
-- Engineer: 
-- 
-- Create Date: 12/10/2023 11:43:39 PM
-- Design Name: 
-- Module Name: pwm_controller - Behavioral
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
use IEEE.numeric_std.ALL;

entity pwm_controller is
    generic (
        PWM_RESOLUTION : integer := 8  -- Number of bits for PWM resolution
    );
    port (
        clk         : in  std_logic;           -- Clock input
        n_reset     : in  std_logic;           -- Asynchronous reset, active low
        pwm_value   : in  std_logic_vector(PWM_RESOLUTION - 1 downto 0);  -- PWM control
        pwm_out     : out std_logic            -- PWM output signal
    );
end pwm_controller;

architecture Behavioral of pwm_controller is
    signal counter : unsigned(PWM_RESOLUTION - 1 downto 0) := (others => '0');
begin

    pwm_process : process(clk, n_reset)
    begin
        if n_reset = '0' then
            counter <= (others => '0');
            pwm_out <= '0';
        elsif rising_edge(clk) then
            if counter = (2**PWM_RESOLUTION - 1) then
                counter <= (others => '0');
            else
                counter <= counter + 1;
            end if;

            -- Generate PWM signal
            if counter < unsigned(pwm_value) then
                pwm_out <= '1';
            else
                pwm_out <= '0';
            end if;
        end if;
    end process pwm_process;

end Behavioral;


