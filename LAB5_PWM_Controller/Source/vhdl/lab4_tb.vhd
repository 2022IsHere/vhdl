LIBRARY ieee;
USE ieee.std_logic_1164.ALL;
 
entity lab4_tb is
end lab4_tb;
 
architecture behavior of lab4_tb is
    component lab4_top
        port(
            sysclk : in std_logic;
            reset : in std_logic;
            btn : in std_logic;
            --clock_out : out std_logic;
            --pulse_out : out std_logic;
            led5_r: out std_logic;
            led5_g: out std_logic;
            led5_b: out std_logic
        );
    end component;
    
    component button_pulser
        generic(
            start_delay: integer;
            interval_time: integer
        );
        port ( 
            clk : in std_logic;
            btn : in std_logic;
            n_reset: in std_logic;
            pulse_out: out std_logic
    );
    end component;
    
    signal sysclk : std_logic := '0';       -- Input
    signal reset : std_logic := '1';        -- Input, active high
    signal btn : std_logic := '0';          -- Input
    --signal clock_out : std_logic;           -- Outputs
    --signal pulse_out : std_logic;           -- Outputs
    signal led5_r : std_logic;              -- Outputs
    signal led5_g : std_logic;              -- Outputs
    signal led5_b : std_logic;              -- Outputs
    constant sysclk_period : time := 8 ns;  -- Clock period definitions (one clock period will be 8ns that is equal to 125MHz)
    
    constant CLOCK_PERIOD : time := 8 ns;
     
    begin
        -- Instantiate the Unit Under Test (UUT)
        uutCD: lab4_top
        PORT MAP (
            sysclk => sysclk,
            reset => reset,
            btn => btn,
            --clock_out => clock_out,
            --pulse_out => pulse_out,
            led5_r => led5_r,
            led5_g => led5_g,
            led5_b => led5_b
        );
        
        
        
        sysclk <= not sysclk after sysclk_period/2;
        
        
--        -- Clock process definitions
--        clock_process :process
--            begin
--                sysclk <= '0';
--            wait for sysclk_period/2;
--                sysclk <= '1';
--            wait for sysclk_period/2;
--        end process;
         
        -- Reset process definitions
        reset_process: process
            begin
            wait for 100 ns;
                reset <= '1';
            wait for 100 ns;
                reset <= '0';
            wait;                       --Will stay here for the rest of the time
        end process;
         


button_process: process
    begin
        wait for 2 us;
        -- Press the button again, no new pulse should be generated
        btn <= '1';
        wait for 500ns;  -- Simulate button press for one clock cycle
        btn <= '0';
        wait for 2us;
        
        -- Press the button again, new pulse should be generated
        btn <= '1';
        wait for 2us;  -- Simulate button press for one clock cycle
        btn <= '0';
        wait for 2000 ns;
        
        wait for 10000 ns;

        -- Test 2: Train of pulses (long button press)
        btn <= '1';
        wait for 100ms; -- Press the button for a longer duration
        btn <= '0';
        wait for 20 * CLOCK_PERIOD; -- Observe the pulse train
        
        
        wait;
        wait for 20 ns;
        
        btn <= '1';
        wait for 100ms; -- Press the button for a longer duration
        btn <= '0';
        wait for 20 * CLOCK_PERIOD; -- Observe the pulse 

        wait;
    end process;


end;



