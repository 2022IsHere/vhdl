library IEEE;
use IEEE.STD_LOGIC_1164.ALL;

entity rgb_channel_selector is
    port ( 
        clk : in std_logic;
        btn_pulse : in std_logic;  -- Input from button pulser
        n_reset: in std_logic;
        led5_r: out std_logic;
        led5_g: out std_logic;
        led5_b: out std_logic
    );
end rgb_channel_selector;

architecture bhv of rgb_channel_selector is
    signal RGB_Led_5: std_logic_vector(0 to 2);
    type fsm_state is (Red, Green, Blue);
    signal state: fsm_state;
    
    begin
    led5_r <= RGB_Led_5(2);
    led5_g <= RGB_Led_5(1);
    led5_b <= RGB_Led_5(0);
    process(clk, n_reset) begin
        if n_reset = '0' then
            state <= Red;
            RGB_LED_5 <= "001";
        elsif rising_edge(clk) then
            if btn_pulse = '1' then
                -- State transition logic
                case state is
                    when Red =>
                        state <= Green;
                        RGB_LED_5 <= "010";
                    when Green => 
                        state <= Blue;
                        RGB_LED_5 <= "100";
                    when Blue => 
                        state <= Red;
                        RGB_LED_5 <= "001";
                    when others => state <= Red; -- Default state
                end case;
            end if;
        end if;
    end process;
end bhv;
