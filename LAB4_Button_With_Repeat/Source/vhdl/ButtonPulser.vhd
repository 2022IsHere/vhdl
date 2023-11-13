library IEEE;
use IEEE.STD_LOGIC_1164.ALL;
use IEEE.NUMERIC_STD.ALL;

entity ButtonPulser is
    Generic (
        DEBOUNCE_DELAY : integer := 50000; -- Adjust as needed
        PULSE_INTERVAL : integer := 125000 -- Adjust as needed
    );
    Port (
        clk       : in  STD_LOGIC;
        n_reset   : in  STD_LOGIC;
        btn_in    : in  STD_LOGIC;
        pulse_out : out STD_LOGIC
    );
end ButtonPulser;


architecture Behavioral of ButtonPulser is
    type State_Type is (Idle, Debounce, Pulse, WaitInterval);
    signal state, next_state: State_Type;

    -- Additional signals for counters and debouncing logic
    signal debounce_counter: integer := 0;
    signal interval_counter: integer := 0;
    signal btn_stable: std_logic := '0';
begin
    -- State transition process
    process(clk, n_reset)
    begin
        if n_reset = '0' then
            -- Reset logic
        elsif rising_edge(clk) then
            -- State transition logic
        end if;
    end process;

    -- Output and internal logic process
    process(clk)
    begin
        if rising_edge(clk) then
            case state is
                when Idle =>
                    -- Handle Idle state logic
                when Debounce =>
                    -- Handle Debounce state logic
                when Pulse =>
                    -- Handle Pulse state logic
                when WaitInterval =>
                    -- Handle Wait Interval state logic
                when others =>
                    -- Handle default case
            end case;
        end if;
    end process;

    -- Assigning output
    pulse_out <= '1' when state = Pulse else '0';
end Behavioral;

