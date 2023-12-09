LIBRARY ieee;
USE ieee.std_logic_1164.ALL;
 
entity lab4_top is 
    port ( 
        sysclk : in std_logic;
        reset : in std_logic; --active high )coming from button)
        btn : in std_logic;
        --clock_out : out std_logic;
        --pulse_out : out std_logic;
        led5_r: out std_logic;
        led5_g: out std_logic;
        led5_b: out std_logic
    );
end lab4_top;
 
architecture behavior of lab4_top is
    signal asy_clock : std_logic;       -- signal
    signal selected_signal : std_logic;       -- signal
    signal n_reset : std_logic;
    
    component Clock_Divider
        generic (
            count_in: integer;
            count_out: integer
        );  
        port(
            clk : in std_logic;
            n_reset : in std_logic;
            clock_out : out std_logic
        );
    end component;
    
    component Button_Pulser
        generic (
            start_delay: integer;
            interval_time: integer
        );
        port(
            clk : in std_logic;
            btn : in std_logic;
            n_reset : in std_logic;
            pulse_out : out std_logic
        );
    end component;
    
    component rgb_channel_selector
        port(
            clk : in std_logic;
            btn_pulse : in std_logic;
            n_reset : in std_logic;
            led5_r: out std_logic;
            led5_g: out std_logic;
            led5_b: out std_logic
        );
    end component;
    
    begin
        n_reset <= not reset; --invert koska nappi
        
        
        -- Instantiate the Unit Under Test (UUT)
        uutCD: Clock_Divider
        generic map (
            count_in => 125000000,
            count_out => 125e4
        )
        PORT MAP(
            clk => sysclk,
            n_reset => n_reset,
            clock_out => asy_clock
        );
        
        uutBP: Button_Pulser
        generic map (
            start_delay => 2000,      -- 10ms, 1 cycles/ms
            interval_time => 500      -- 3ms, 1 cycles/ms
        )
        PORT MAP(
            clk => asy_clock,  --I need to receive the clock_out from clock_divider
            btn => btn,
            n_reset =>  n_reset,
            pulse_out => selected_signal
        );
        
        uutRGB: rgb_channel_selector
        PORT MAP(
            clk => asy_clock,  --I need to receive the clock_out from clock_divider
            btn_pulse => selected_signal,
            n_reset =>  n_reset,
            led5_r => led5_r,
            led5_g => led5_g,
            led5_b => led5_b
        );
        
        --To remove when finished:
        --clock_out <= asy_clock;
        --pulse_out <= selected_signal;
end;