library IEEE;
use IEEE.STD_LOGIC_1164.ALL;

entity TB_step_motor_controller is
end TB_step_motor_controller;

architecture Behavioral of TB_step_motor_controller is
component step_motor_controller is
port(
        clk_system_125MHZ : in  std_logic;        
        reset             : in  std_logic;       
        enable_cw         : in  std_logic;       
        enable_ccw        : in  std_logic;       
        stepper_phases    : out std_logic_vector(3 downto 0) 
    );
end component;
signal reset,enable_cw,enable_ccw, clk_system_125MHZ : std_logic := '0';
signal stepper_phases : std_logic_vector(3 downto 0);
-- Hardware system clock period (1/125 MHz = 8 ns)
constant period : time := 8 ns;
begin
u1: step_motor_controller
port map(
            clk_system_125MHZ => clk_system_125MHZ,
            reset             => reset,
            enable_cw         => enable_cw,
            enable_ccw        => enable_ccw,
            stepper_phases    => stepper_phases
        );
--System Clock Generation
process 
begin
clk_system_125MHZ <= not clk_system_125MHZ;
wait for period/2;
end process;
-- Stimulus Process to verify system behavior sequentially
process
begin 
-----------------------------------------------------------------------
        -- Scenario 1: Initial System Power-on Reset
        -----------------------------------------------------------------------
        reset <= '1';
        wait for period * 10; 
        reset <= '0';
        wait for period * 5;

        -----------------------------------------------------------------------
        -- Scenario 2: Normal Clockwise (CW) Routine
        -----------------------------------------------------------------------
        enable_cw <= '1';
        wait for 6 ms;
        enable_cw <= '0';
        wait for 2 ms;

        -----------------------------------------------------------------------
        -- EDGE CASE A: Command Contention (Both enables high simultaneously)
        -- Hardware priority MUX should favor CW and block CCW gracefully.
        -----------------------------------------------------------------------
        enable_cw  <= '1';
        enable_ccw <= '1'; -- Conflict injection
        wait for 6 ms;
        
        enable_cw  <= '0';
        enable_ccw <= '0';
        wait for 2 ms;

        -----------------------------------------------------------------------
        -- EDGE CASE B: Forced Reset During Mid-Operation
        -- Motor should instantly cut off power (output "0000") upon reset high.
        -----------------------------------------------------------------------
        enable_ccw <= '1'; -- Start running CCW
        wait for 3 ms;      -- Let it complete a few steps
        
        reset <= '1';      -- Sudden reset injection during active rotation
        wait for 1 ms;
        
        reset <= '0';      -- Deassert reset
        enable_ccw <= '0'; -- Clear control lines
        wait for 2 ms;

        -----------------------------------------------------------------------
        -- EDGE CASE C: Glitch Filtering / Short Enable Pulse
        -- Pulse width is shorter than the 500Hz clock half-period (1 ms).
        -- The FSM should ignore this transient signal and remain in IDLE.
        -----------------------------------------------------------------------
        enable_cw <= '1';
        wait for 100 us;   -- Very short transient spike (Glitch)
        enable_cw <= '0';
        wait for 5 ms;     -- Observe that no state change occurred

        -----------------------------------------------------------------------
        -- End of Extended Simulation
        -----------------------------------------------------------------------
        wait;
    end process p_stimulus;

end Behavioral;
