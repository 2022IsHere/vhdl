library IEEE;
use IEEE.STD_LOGIC_1164.ALL;
use IEEE.NUMERIC_STD.ALL;

entity TopLevel is
    Port (
        clk_125MHz : in  STD_LOGIC;
        btn        : in  STD_LOGIC;
        rgb_led    : out STD_LOGIC_VECTOR (2 downto 0)
    );
end TopLevel;

architecture Behavioral of TopLevel is
    -- Internal Signals
    signal clk_1kHz, n_reset, pulse_out : STD_LOGIC;

    -- Component Declarations
    component ClockDivider
        generic (OUTPUT_FREQ : integer := 1000); -- 1 kHz output frequency
        port (
            i_clk   : in std_logic;
            i_reset : in std_logic;
            o_clk   : out std_logic
        );
    end component;

    component ButtonPulser
        generic (
            DEBOUNCE_DELAY : integer := 50000;
            PULSE_INTERVAL : integer := 125000
        );
        port (
            clk       : in  STD_LOGIC;
            n_reset   : in  STD_LOGIC;
            btn_in    : in  STD_LOGIC;
            pulse_out : out STD_LOGIC
        );
    end component;

    component RGBStateMachine
        port (
            clk      : in  STD_LOGIC;
            n_reset  : in  STD_LOGIC;
            btn_in   : in  STD_LOGIC;
            rgb_out  : out STD_LOGIC_VECTOR (2 downto 0)
        );
    end component;

begin
    -- Clock Divider Instance
    ClockDiv: ClockDivider
        port map (
            i_clk   => clk_125MHz,
            i_reset => n_reset,
            o_clk   => clk_1kHz
        );

    -- Button Pulser Instance
    BtnPulser: ButtonPulser
        port map (
            clk       => clk_1kHz,
            n_reset   => n_reset,
            btn_in    => btn,
            pulse_out => pulse_out
        );

    -- RGB State Machine Instance
    RGBMachine: RGBStateMachine
        port map (
            clk      => clk_1kHz,
            n_reset  => n_reset,
            btn_in   => pulse_out,
            rgb_out  => rgb_led
        );

    -- Reset Logic (Active Low)
    n_reset <= not btn;

end Behavioral;

