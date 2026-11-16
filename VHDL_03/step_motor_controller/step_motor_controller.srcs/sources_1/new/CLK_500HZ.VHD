library IEEE;
use IEEE.STD_LOGIC_1164.ALL;
use IEEE.NUMERIC_STD.ALL;

-- This component divides the high-speed system clock (125 MHz)
-- to a slower clock signal of 500 Hz suitable for the stepper motor.
entity clk_divider is
    port(
        clk_system_125MHZ : in  std_logic;
        reset             : in  std_logic;
        clk_500HZ         : out std_logic
    );
end clk_divider;

architecture B of clk_divider is

    constant C_MAX_COUNT : integer := 125000;

    signal counter   : integer range 0 to C_MAX_COUNT - 1 := 0;
    signal clk_state : std_logic := '0';

begin

    process(clk_system_125MHZ)
    begin
        if rising_edge(clk_system_125MHZ) then

            if reset = '1' then
                counter   <= 0;
                clk_state <= '0';

            else
                if counter = C_MAX_COUNT - 1 then
                    counter   <= 0;
                    clk_state <= not clk_state;
                else
                    counter <= counter + 1;
                end if;

            end if;

        end if;
    end process;

    clk_500HZ <= clk_state;

end B;