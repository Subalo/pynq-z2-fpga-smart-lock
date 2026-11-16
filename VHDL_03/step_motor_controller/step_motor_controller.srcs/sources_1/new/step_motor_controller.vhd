library IEEE;
use IEEE.STD_LOGIC_1164.ALL;
use IEEE.NUMERIC_STD.ALL;

entity step_motor_controller is
port(
        clk_system_125MHZ : in  std_logic;        
        reset             : in  std_logic;       
        enable_cw         : in  std_logic;       
        enable_ccw        : in  std_logic;       
        stepper_phases    : out std_logic_vector(3 downto 0) 
    );
end step_motor_controller;

architecture Behavioral of step_motor_controller is
-- Component : Clock Divider
component clk_divider is
    port(
        clk_system_125MHZ : in  std_logic;
        reset             : in  std_logic;
        clk_500HZ         : out std_logic
    );
end component;
-- Component : Clockwise Controller
component motor_clockwise is
    port(
        clk            : in  std_logic;                     
        reset          : in  std_logic;                    
        enable_cw      : in  std_logic;                     
        stepper_phases : out std_logic_vector(3 downto 0)   
    );
end component;
-- Component : Counter-Clockwise Controller
component motor_counterclockwise is
    port(
        clk            : in  std_logic;                  
        reset          : in  std_logic;                   
        enable_ccw     : in  std_logic;                   
        stepper_phases : out std_logic_vector(3 downto 0)   
    );
end component;
signal clk_500hz  : std_logic;
signal phases_cw  : std_logic_vector(3 downto 0);
signal phases_ccw : std_logic_vector(3 downto 0);
begin
u1: clk_divider
port map (
            clk_system_125MHZ => clk_system_125MHZ,
            reset             => reset,
            clk_500HZ         => clk_500hz
        );
u2: motor_clockwise
port map (
            clk            => clk_500hz,
            reset          => reset,
            enable_cw      => enable_cw,
            stepper_phases => phases_cw
        );
u3: motor_counterclockwise
port map (
            clk            => clk_500hz,
            reset          => reset,
            enable_ccw     => enable_ccw,
            stepper_phases => phases_ccw
        );        
stepper_phases <= phases_cw  when enable_cw = '1'  else 
                      phases_ccw when enable_ccw = '1' else 
                      "0000";        
end Behavioral;
