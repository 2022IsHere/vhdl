----------------------------------------------------------------------------------
-- Company: 
-- Engineer: 
-- 
-- Create Date: 12/10/2023 11:46:46 PM
-- Design Name: 
-- Module Name: pwm_tb - Behavioral
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
LIBRARY ieee;
USE ieee.std_logic_1164.ALL;
USE ieee.numeric_std.ALL;

ENTITY pwm_tb IS
END pwm_tb;

ARCHITECTURE behavior OF pwm_tb IS 

    -- Component Declaration for the Unit Under Test (UUT)
    COMPONENT pwm_controller
        GENERIC (
            PWM_RESOLUTION : INTEGER := 8
        );
        PORT(
            clk       : IN  std_logic;
            n_reset   : IN  std_logic;
            pwm_value : IN  std_logic_vector(PWM_RESOLUTION - 1 DOWNTO 0);
            pwm_out   : OUT std_logic
        );
    END COMPONENT;
   
    --Inputs
    signal clk       : std_logic := '0';
    signal n_reset   : std_logic := '1';
    signal pwm_value : std_logic_vector(7 downto 0) := (others => '0');

    --Outputs
    signal pwm_out   : std_logic;

    -- Clock period definitions
    constant clk_period : time := 10 ns; -- Adjust as needed

BEGIN 

    -- Instantiate the Unit Under Test (UUT)
    uut: pwm_controller 
        PORT MAP (
            clk       => clk,
            n_reset   => n_reset,
            pwm_value => pwm_value,
            pwm_out   => pwm_out
        );

    -- Clock process definitions
    clk_process :process
    begin
        clk <= '0';
        wait for clk_period/2;
        clk <= '1';
        wait for clk_period/2;
    end process;

    -- Testbench Statements
    stim_proc: process
    begin       
        -- Hold reset state for 100 ns
        wait for 100 ns;  
        n_reset <= '0'; -- Assert the reset
        wait for 100 ns;
        n_reset <= '1'; -- Deassert the reset
        wait for 100 ns; 
    
        -- Test different PWM values
        pwm_value <= "00000000"; -- 0% duty cycle
        wait for 200 ns;
        
        pwm_value <= "10000000"; -- 50% duty cycle
        wait for 200 ns;
    
        pwm_value <= "11111111"; -- 100% duty cycle
        wait for 200 ns;
    
        -- Add more test cases as needed
    
        wait; -- will wait forever
    end process stim_proc;
    

END;
