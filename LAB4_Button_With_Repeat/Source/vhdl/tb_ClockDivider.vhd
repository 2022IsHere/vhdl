library IEEE;
use IEEE.STD_LOGIC_1164.ALL;

entity tb_clock_divider is
end entity tb_clock_divider;

architecture sim of tb_clock_divider is
    signal i_clk, i_reset, o_clk : std_logic;
    constant CLK_PERIOD : time := 8 ns; -- corresponds to 125 MHz

begin
    uut: entity work.clock_divider
        generic map (12_500_000)
        port map (i_clk, i_reset, o_clk);

    -- Clock Generation
    clk_gen: process
    begin
        while true loop
            i_clk <= not i_clk;
            wait for CLK_PERIOD / 2;
        end loop;
    end process;

    -- Stimulus Process
    stimulus: process
    begin
        -- Reset Test
        i_reset <= '1';
        wait for CLK_PERIOD * 10; -- wait for some time
        i_reset <= '0';
        wait for CLK_PERIOD * 10; -- observe normal operation

        -- Add additional test cases here if needed

        wait; -- continuous observation
    end process;
end architecture sim;

