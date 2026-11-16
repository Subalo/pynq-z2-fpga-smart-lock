library IEEE;
use IEEE.STD_LOGIC_1164.ALL;


entity motor_counterclockwise_TB is
end motor_counterclockwise_TB;

architecture Behavioral of motor_counterclockwise_TB is
component motor_counterclockwise is
 port(
        clk            : in  std_logic;                  
        reset          : in  std_logic;                   
        enable_ccw     : in  std_logic;                   
        stepper_phases : out std_logic_vector(3 downto 0)   
    );
end component;
signal clk, reset, enable_ccw : std_logic := '0';
signal stepper_phases : std_logic_vector(3 downto 0);
-- Clock period matched to the slow sampling clock (500 Hz = 2 ms)
constant period : time := 2 ms;
begin
u1: motor_counterclockwise
port map(
            clk            => clk,
            reset          => reset,
            enable_ccw     => enable_ccw,
            stepper_phases => stepper_phases
        );
-- Clock generation process (500Hz clock simulation)
process
begin
clk <= not clk;
wait for period/2;
end process;

-- Stimulus process
process
begin
reset <= '1';
wait for period * 2;
reset <= '0';
wait for period;
enable_ccw <= '1';
wait for period * 5;
reset <= '1';
wait for period * 2;
reset <= '0';
wait;
end process;

end Behavioral;