library IEEE;
use IEEE.STD_LOGIC_1164.ALL;
use IEEE.numeric_std.ALL;
  
entity clock_divider is
    generic (
        count_in: integer;
        count_out: integer
    );  
    port ( 
        clk,n_reset: in std_logic;
        clock_out: out std_logic
    );
end clock_divider;
 
architecture bhv of clock_divider is
    constant MAX_CYCLES: integer := count_in/count_out;
    signal count: integer;
      
    begin
    process(clk,n_reset)
        begin
        --When reset 
        if(n_reset='0') then
            count <= 0;
            clock_out <= '0';
        --when the system clock have a rising edge
        elsif(rising_edge(clk)) then
            --if they already complete a clock divider cicle
            if count >= MAX_CYCLES-1 then
                count <= 0;
            else 
                count <= count+1;
            end if;
            --if the count didnt complete the half time for a clock divider cicle
            if count < (MAX_CYCLES/2)-1 then
                clock_out <= '0';
            else
                clock_out <= '1';
            end if;
        end if;
    end process;
end bhv;