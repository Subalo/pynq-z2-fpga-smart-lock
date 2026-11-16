library IEEE;
use IEEE.STD_LOGIC_1164.ALL;

-- This component handles the stepper motor sequence for clockwise rotation.
-- It includes an idle state to power down the coils when inactive.
entity motor_clockwise is
    port(
        clk            : in  std_logic;                     
        reset          : in  std_logic;                    
        enable_cw      : in  std_logic;                     
        stepper_phases : out std_logic_vector(3 downto 0)   
    );
end motor_clockwise;

architecture Behavioral of motor_clockwise is

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
    process(current_state, enable_cw)
    begin
        stepper_phases <= "0000";
        next_state <= IDLE;

        case current_state is

            when IDLE =>
                stepper_phases <= "0000";

                if enable_cw = '1' then
                    next_state <= PHASE_1; --Start from PHASE_1
                else
                    next_state <= IDLE;
                end if;

            when PHASE_1 =>
    stepper_phases <= "0001";

    if enable_cw = '1' then
        next_state <= PHASE_2;
    else
        next_state <= IDLE;
    end if;

when PHASE_2 =>
    stepper_phases <= "0010";

    if enable_cw = '1' then
        next_state <= PHASE_3;
    else
        next_state <= IDLE;
    end if;

when PHASE_3 =>
    stepper_phases <= "0100";

    if enable_cw = '1' then
        next_state <= PHASE_4;
    else
        next_state <= IDLE;
    end if;

when PHASE_4 =>
    stepper_phases <= "1000";

    if enable_cw = '1' then
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