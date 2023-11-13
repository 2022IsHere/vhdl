library IEEE;
use IEEE.STD_LOGIC_1164.ALL;

entity RGBStateMachine is
    Port (
        clk      : in  STD_LOGIC;
        n_reset  : in  STD_LOGIC;
        btn_in   : in  STD_LOGIC;
        rgb_out  : out STD_LOGIC_VECTOR (2 downto 0)
    );
end RGBStateMachine;

architecture Behavioral of RGBStateMachine is
    type State_Type is (Red, Green, Blue);
    signal state, next_state: State_Type;

begin
    -- State Transition Process
    process(clk, n_reset)
    begin
        if n_reset = '0' then
            state <= Red; -- Reset to Red
        elsif rising_edge(clk) then
            state <= next_state;
        end if;
    end process;

    -- Next State Logic
    process(btn_in, state)
    begin
        case state is
            when Red =>
                if btn_in = '1' then
                    next_state <= Green;
                else
                    next_state <= state;
                end if;
            when Green =>
                -- Similar logic for Green state
            when Blue =>
                -- Similar logic for Blue state
            when others =>
                next_state <= Red;
        end case;
    end process;

    -- Output Logic
    process(state)
    begin
        case state is
            when Red   => rgb_out <= "100"; -- Red
            when Green => rgb_out <= "010"; -- Green
            when Blue  => rgb_out <= "001"; -- Blue
            when others => rgb_out <= "000";
        end case;
    end process;

end Behavioral;

