library IEEE;
use IEEE.STD_LOGIC_1164.ALL;

entity tb_RGBStateMachine is
-- Testbench has no ports.
end tb_RGBStateMachine;

architecture behavior of tb_RGBStateMachine is 
    -- Component Declaration for the Unit Under Test (UUT)
    component RGBStateMachine
        Port (
            clk      : in  STD_LOGIC;
            n_reset  : in  STD_LOGIC;
            btn_in   : in  STD_LOGIC;
            rgb_out  : out STD_LOGIC_VECTOR (2 downto 0)
        );
    end component;

    --Inputs
    signal clk      : std_logic := '0';
    signal n_reset  : std_logic := '1';
    signal btn_in   : std_logic := '0';

    --Outputs
    signal rgb_out  : std_logic_vector(2 downto 0);

    -- Clock period definition
    constant clk_period : time := 10 ns; -- Adjust as necessary for your clock

begin 
    -- Instantiate the Unit Under Test (UUT)
    uut: RGBStateMachine
        port map (
            clk      => clk,
            n_reset  => n_reset,
            btn_in   => btn_in,
            rgb_out  => rgb_out
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
        -- Reset the system
        n_reset <= '0';
        wait for clk_period*10;
        n_reset <= '1';
        wait for clk_period*10;

        -- Test button press to switch from Red to Green
        btn_in <= '1';
        wait for clk_period*5; -- Simulate button press duration
        btn_in <= '0';
        wait for clk_period*100; -- Observe output

        -- Ad

