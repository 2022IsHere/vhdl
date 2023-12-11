LIBRARY ieee;
USE ieee.std_logic_1164.ALL;
USE ieee.numeric_std.ALL; 

ENTITY lab4_top IS
    PORT(
        sysclk   : IN  std_logic;
        reset    : IN  std_logic; -- Active high coming from button
        btn      : IN  std_logic; -- Button for cycling through RGB channels
        btn_up   : IN  std_logic; -- Button for increasing PWM value
        btn_down : IN  std_logic; -- Button for decreasing PWM value
        led5_r   : OUT std_logic; -- Red channel of RGB LED
        led5_g   : OUT std_logic; -- Green channel of RGB LED
        led5_b   : OUT std_logic  -- Blue channel of RGB LED
    );
END lab4_top;

ARCHITECTURE behavior OF lab4_top IS
    SIGNAL asy_clock : std_logic;
    SIGNAL selected_signal : std_logic;
    SIGNAL n_reset : std_logic;
    SIGNAL active_channel : INTEGER RANGE 0 TO 2 := 0;

    SIGNAL pwm_value_r, pwm_value_g, pwm_value_b: std_logic_vector(7 DOWNTO 0) := (others => '0');

    COMPONENT Clock_Divider
        GENERIC (
            count_in : INTEGER;
            count_out: INTEGER
        );
        PORT(
            clk       : IN  std_logic;
            n_reset   : IN  std_logic;
            clock_out : OUT std_logic
        );
    END COMPONENT;

    COMPONENT Button_Pulser
        GENERIC (
            start_delay   : INTEGER;
            interval_time : INTEGER
        );
        PORT(
            clk       : IN  std_logic;
            btn       : IN  std_logic;
            n_reset   : IN  std_logic;
            pulse_out : OUT std_logic
        );
    END COMPONENT;

    COMPONENT rgb_channel_selector
        PORT(
            clk       : IN  std_logic;
            btn_pulse : IN  std_logic;
            n_reset   : IN  std_logic;
            led5_r    : OUT std_logic;
            led5_g    : OUT std_logic;
            led5_b    : OUT std_logic
        );
    END COMPONENT;

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

BEGIN
    n_reset <= NOT reset; -- Invert reset signal

    -- Instantiate the Clock Divider
    uutCD: Clock_Divider
        GENERIC MAP (
            count_in  => 125000000,
            count_out => 125e4
        )
        PORT MAP(
            clk       => sysclk,
            n_reset   => n_reset,
            clock_out => asy_clock
        );

    -- Instantiate the Button Pulser
    uutBP: Button_Pulser
        GENERIC MAP (
            start_delay   => 2000, -- 10ms, 1 cycle/ms
            interval_time => 500   -- 3ms, 1 cycle/ms
        )
        PORT MAP(
            clk       => asy_clock, -- Receive the clock_out from clock_divider
            btn       => btn,
            n_reset   => n_reset,
            pulse_out => selected_signal
        );

    -- Instantiate the RGB Channel Selector
    uutRGB: rgb_channel_selector
        PORT MAP(
            clk       => asy_clock, -- Receive the clock_out from clock_divider
            btn_pulse => selected_signal,
            n_reset   => n_reset,
            led5_r    => led5_r,
            led5_g    => led5_g,
            led5_b    => led5_b
        );

    -- Instantiate PWM Controllers for RGB channels
    pwm_r: pwm_controller
        GENERIC MAP (
            PWM_RESOLUTION => 8
        )
        PORT MAP (
            clk       => sysclk,
            n_reset   => n_reset,
            pwm_value => pwm_value_r,
            pwm_out   => led5_r
        );

    pwm_g: pwm_controller
        GENERIC MAP (
            PWM_RESOLUTION => 8
        )
        PORT MAP (
            clk       => sysclk,
            n_reset   => n_reset,
            pwm_value => pwm_value_g,
            pwm_out   => led5_g
        );

    pwm_b: pwm_controller
        GENERIC MAP (
            PWM_RESOLUTION => 8
        )
        PORT MAP (
            clk       => sysclk,
            n_reset   => n_reset,
            pwm_value => pwm_value_b,
            pwm_out   => led5_b
        );
           
        -- Button Logic and PWM Value Management
        -- This process handles button presses to cycle through RGB channels (btn)
        -- and adjust the PWM values (btn_up and btn_down).
        button_logic_process: PROCESS(sysclk, reset)
        BEGIN
            IF reset = '1' THEN
                active_channel <= 0;
                pwm_value_r <= (others => '0');
                pwm_value_g <= (others => '0');
                pwm_value_b <= (others => '0');
            ELSIF rising_edge(sysclk) THEN
                -- Handle RGB channel selection
                IF btn = '1' THEN
                    active_channel <= active_channel + 1;
                    IF active_channel > 2 THEN
                        active_channel <= 0;
                    END IF;
                END IF;
        
                -- Adjust PWM values based on active channel
                CASE active_channel IS
                    WHEN 0 =>  -- Red Channel
                        IF btn_up = '1' AND unsigned(pwm_value_r) < to_unsigned(255, pwm_value_r'length) THEN
                            pwm_value_r <= std_logic_vector(unsigned(pwm_value_r) + 1);
                        ELSIF btn_down = '1' AND unsigned(pwm_value_r) > to_unsigned(0, pwm_value_r'length) THEN
                            pwm_value_r <= std_logic_vector(unsigned(pwm_value_r) - 1);
                        END IF;
                    WHEN 1 =>  -- Green Channel
                        IF btn_up = '1' AND unsigned(pwm_value_g) < to_unsigned(255, pwm_value_g'length) THEN
                            pwm_value_g <= std_logic_vector(unsigned(pwm_value_g) + 1);
                        ELSIF btn_down = '1' AND unsigned(pwm_value_g) > to_unsigned(0, pwm_value_g'length) THEN
                            pwm_value_g <= std_logic_vector(unsigned(pwm_value_g) - 1);
                        END IF;
                    WHEN 2 =>  -- Blue Channel
                        IF btn_up = '1' AND unsigned(pwm_value_b) < to_unsigned(255, pwm_value_b'length) THEN
                            pwm_value_b <= std_logic_vector(unsigned(pwm_value_b) + 1);
                        ELSIF btn_down = '1' AND unsigned(pwm_value_b) > to_unsigned(0, pwm_value_b'length) THEN
                            pwm_value_b <= std_logic_vector(unsigned(pwm_value_b) - 1);
                        END IF;
                END CASE;
            END IF;
        END PROCESS button_logic_process;
        
            

    
        
        --To remove when finished:
        --clock_out <= asy_clock;
        --pulse_out <= selected_signal;
end;

