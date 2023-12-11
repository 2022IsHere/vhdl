library IEEE;
use IEEE.STD_LOGIC_1164.ALL;
use IEEE.numeric_std.ALL;
  
entity button_pulser is
    generic (
        start_delay: integer;
        interval_time: integer
    );  
    port ( 
        clk : in std_logic;
        btn : in std_logic;
        n_reset: in std_logic;
        pulse_out: out std_logic
    );
end button_pulser;
 
architecture bhv of button_pulser is
    --type fsm_state is (Idle, Debouncing, Armed, Repeat);
    type fsm_state is (Idle, Armed, Repeat);
    signal state: fsm_state;
    signal long_press, lpena: std_logic;
    signal count_cycles: integer range 0 to start_delay; --repeat
    signal count_cycles_long: integer range 0 to interval_time; 
    --signal debounce_counter: integer range 0 to 50000; -- 50000 for 1ms debounce at 50MHz clock
    --signal stable_btn_state : std_logic;
    --signal last_sampled_state : std_logic := '0';
    
    begin
    
    -- When a mechanical button is pressed or released, it doesn't change states cleanly; instead, it "bounces" between open and closed states. 
    --I thought that using a debouncer would solve the long press issue but it didnt.
    --debouncer: process(clk, n_reset)
    --begin
        --if n_reset = '0' then
            --debounce_counter <= 0;
            --stable_btn_state <= '0';
            --last_sampled_state <= '0';
        --elsif rising_edge(clk) then
            --if btn /= last_sampled_state then
                --debounce_counter <= 0;
                --last_sampled_state <= btn;
            --elsif debounce_counter < 50000 then
                --debounce_counter <= debounce_counter + 1;
                --if debounce_counter = 50000 then
                    --stable_btn_state <= last_sampled_state;
                --end if;
            --end if;
        --end if;
    --end process;

    process(clk, n_reset)
    begin
        if(n_reset='0') then
            pulse_out <= '0';
            state <= Idle;
            lpena <= '0';
        elsif(rising_edge(clk)) then
            case state is
                when Idle =>
                    if btn='1' then
                        pulse_out <= '1';
                        state <= Armed;
                    else
                        pulse_out <= '0';
                        state <= Idle;
                    end if;
                    lpena <= '0';
                when Armed => -- waiting for long press to happen
                    pulse_out <= '0';
                    
                    if(btn='0') then
                        state <= Idle;
                    end if;
                    
                    if (long_press='1') then
                        state <= Repeat;
                    end if;
                    lpena <= '1';
                when Repeat =>
                    if(btn='0') then 
                        state <= Idle;
                    end if;
                    
                    lpena <= '0';
                    if(count_cycles <= interval_time-1) then
                        pulse_out <= '0';
                        count_cycles<=count_cycles+1;
                    else
                        count_cycles <= 0;
                        pulse_out <= '1';
                    end if;
                when others => 
                    state <= Idle; -- just in case
            end case;
        end if;
    end process; 

    
    process(clk,n_reset) begin
        if(n_reset='0') then
            count_cycles_long <= 0;
            long_press <= '0';
        elsif(rising_edge(clk)) then
            if(lpena ='1') then
                count_cycles_long <= count_cycles_long+1;
            else
                count_cycles_long <= 0;
            end if;
            
            if(count_cycles_long >= start_delay-1) then
                long_press <= '1';
            else
                long_press <= '0';
            end if;
        end if;
        
        
    end process;
end bhv;