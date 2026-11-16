library IEEE;
use IEEE.STD_LOGIC_1164.ALL;

-- This component handles the stepper motor sequence for counter-clockwise rotation.
entity motor_counterclockwise is
    port(
        clk            : in  std_logic;                  
        reset          : in  std_logic;                   
        enable_ccw     : in  std_logic;                   
        stepper_phases : out std_logic_vector(3 downto 0)   
    );
end motor_counterclockwise;

architecture Behavioral of motor_counterclockwise is

    type state_type is (IDLE, PHASE_1, PHASE_2, PHASE_3, PHASE_4);
    signal current_state : state_type := IDLE;
    signal next_state    : state_type := IDLE;

begin

    -- State register
    process(clk)
    begin
        if rising_edge(clk) then
            if reset = '1' then
                current_state <= IDLE;
            else
                current_state <= next_state;
            end if;
        end if;
    end process;

    -- Next-state logic and output logic
    process(current_state, enable_ccw)
    begin
        -- Default assignments to prevent latches and save power
        stepper_phases <= "0000";
        next_state <= IDLE;

        case current_state is

            when IDLE =>
                stepper_phases <= "0000";

                if enable_ccw = '1' then
                    next_state <= PHASE_4; -- Start from PHASE_4 to reverse the torque direction
                else
                    next_state <= IDLE;
                end if;

            when PHASE_1 =>
    stepper_phases <= "1000";

    if enable_ccw = '1' then
        next_state <= PHASE_2;
    else
        next_state <= IDLE;
    end if;

when PHASE_2 =>
    stepper_phases <= "0100";

    if enable_ccw = '1' then
        next_state <= PHASE_3;
    else
        next_state <= IDLE;
    end if;

when PHASE_3 =>
    stepper_phases <= "0010";

    if enable_ccw = '1' then
        next_state <= PHASE_4;
    else
        next_state <= IDLE;
    end if;

when PHASE_4 =>
    stepper_phases <= "0001";

    if enable_ccw = '1' then
        next_state <= PHASE_1;
    else
        next_state <= IDLE;
    end if;

            when others =>
                stepper_phases <= "0000";
                next_state <= IDLE;

        end case;
    end process;

end Behavioral;