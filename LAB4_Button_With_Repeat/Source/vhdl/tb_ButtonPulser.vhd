library IEEE;
use IEEE.STD_LOGIC_1164.ALL;

entity tb_ButtonPulser is
-- Testbench has no ports.
end tb_ButtonPulser;

architecture behavior of tb_ButtonPulser is 
    -- Component Declaration for the Unit Under Test (UUT)
    component ButtonPulser
        Generic (
            DEBOUNCE_DELAY : integer := 50000;
            PULSE_INTERVAL : integer := 125000
        );
        Port (
            clk       : in  STD_LOGIC;
            n_reset   : in  STD_LOGIC;
            btn_in    : in  STD_LOGIC;
            pulse_out : out STD_LOGIC
        );
    end component;

    --Inputs
    signal clk       : std_logic := '0';
    signal n_reset   : std_logic := '1';
    signal btn_in    : std_logic := '0';

    --Outputs
    signal pulse_out : std_logic;

    -- Clock period definition
    constant clk_period : time := 10 ns; -- Adjust as necessary for your clock

begin 
    -- Instantiate the Unit Under Test (UUT)
    uut: ButtonPulser
        generic map (
            DEBOUNCE_DELAY => 50000,
            PULSE_INTERVAL => 125000
        )
        port map (
            clk       => clk,
            n_reset   => n_reset,
            btn_in    => btn_in,
            pulse_out => pulse_out
        );

    -- Clock process
    clk_process : process
    begin
        clk <= '0';
        wait for clk_period/2;
        clk <= '1';
        wait for clk_period/2;
    end process;

    -- Test Process
    stim_proc: process
    begin
        -- Initialize Inputs
        n_reset <= '0';
        wait for clk_period*10; -- Reset the system
        n_reset <= '1';
        wait for clk_period*10; 

        -- Test short button press
        btn_in <= '1';
        wait for clk_period*5; -- Short press
        btn_in <= '0';
        wait for clk_period*100; -- Wait to observe

        -- Test long button press
        btn_in <= '1';
        wait for clk_period*100000; -- Long press
        btn_in <= '0';
        wait for clk_period*100; -- Wait to observe

        -- Finish simulation
        wait;
    end process;

end behavior;

