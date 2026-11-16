library IEEE;
use IEEE.STD_LOGIC_1164.ALL;
use IEEE.NUMERIC_STD.ALL;

entity keypad_controller_tb is
end keypad_controller_tb;

architecture Behavioral of keypad_controller_tb is

    --------------------------------------------------------------------
    -- Clock
    --------------------------------------------------------------------
    constant CLK_PERIOD : time := 10 ns;   -- 100 MHz

    signal clk       : std_logic := '0';
    signal reset_n   : std_logic := '0';

    --------------------------------------------------------------------
    -- DUT signals
    --------------------------------------------------------------------
    signal keypad_rows : std_logic_vector(3 downto 0) := "1111";
    signal keypad_cols : std_logic_vector(3 downto 0);
    signal key_status  : std_logic_vector(4 downto 0);

    --------------------------------------------------------------------
    -- Testbench control signals
    --------------------------------------------------------------------
    signal key_down     : std_logic := '0';
    signal pressed_code : std_logic_vector(3 downto 0) := x"0";

begin

    --------------------------------------------------------------------
    -- Clock generation - 100 MHz
    --------------------------------------------------------------------
    clk <= not clk after CLK_PERIOD / 2;


    --------------------------------------------------------------------
    -- DUT
    --
    -- For simulation the scan frequency is increased and debounce
    -- is reduced so the simulation does not need to run for many ms.
    --------------------------------------------------------------------
    DUT : entity work.keypad_controller
        generic map (
            CLK_FREQ_HZ     => 100000000,
            SCAN_FREQ_HZ    => 100000,
            DEBOUNCE_FRAMES => 3
        )
        port map (
            clk         => clk,
            reset_n     => reset_n,
            keypad_rows => keypad_rows,
            keypad_cols => keypad_cols,
            key_status  => key_status
        );


    --------------------------------------------------------------------
    -- Keypad matrix model
    --
    -- The VHDL controller drives one column LOW.
    -- When a key is pressed, the corresponding row goes LOW only
    -- when its column is currently active.
    --------------------------------------------------------------------
    keypad_model : process(keypad_cols, key_down, pressed_code)

        variable rows_temp : std_logic_vector(3 downto 0);
        variable row_index : integer range -1 to 3;
        variable col_index : integer range -1 to 3;

    begin

        -- Pull-up state: no key pressed
        rows_temp := "1111";

        row_index := -1;
        col_index := -1;

        ----------------------------------------------------------------
        -- Convert key code to physical row/column position
        ----------------------------------------------------------------
        case pressed_code is

            -- Row 1
            when x"1" =>
                row_index := 0;
                col_index := 0;

            when x"2" =>
                row_index := 0;
                col_index := 1;

            when x"3" =>
                row_index := 0;
                col_index := 2;

            when x"A" =>
                row_index := 0;
                col_index := 3;


            -- Row 2
            when x"4" =>
                row_index := 1;
                col_index := 0;

            when x"5" =>
                row_index := 1;
                col_index := 1;

            when x"6" =>
                row_index := 1;
                col_index := 2;

            when x"B" =>
                row_index := 1;
                col_index := 3;


            -- Row 3
            when x"7" =>
                row_index := 2;
                col_index := 0;

            when x"8" =>
                row_index := 2;
                col_index := 1;

            when x"9" =>
                row_index := 2;
                col_index := 2;

            when x"C" =>
                row_index := 2;
                col_index := 3;


            -- Row 4
            when x"E" =>
                row_index := 3;
                col_index := 0;       -- *

            when x"0" =>
                row_index := 3;
                col_index := 1;

            when x"F" =>
                row_index := 3;
                col_index := 2;       -- #

            when x"D" =>
                row_index := 3;
                col_index := 3;

            when others =>
                row_index := -1;
                col_index := -1;

        end case;


        ----------------------------------------------------------------
        -- Simulate the electrical connection created by a pressed key
        ----------------------------------------------------------------
        if key_down = '1' then

            if (row_index >= 0) and (col_index >= 0) then

                -- The column is active LOW
                if keypad_cols(col_index) = '0' then
                    rows_temp(row_index) := '0';
                end if;

            end if;

        end if;


        keypad_rows <= rows_temp;

    end process;


    --------------------------------------------------------------------
    -- Stimulus process
    --------------------------------------------------------------------
    stimulus : process

        ----------------------------------------------------------------
        -- Procedure for pressing and checking one key
        ----------------------------------------------------------------
        procedure press_and_check(
            constant code_value : in std_logic_vector(3 downto 0);
            constant key_name   : in string
        ) is
        begin

            ------------------------------------------------------------
            -- Press key
            ------------------------------------------------------------
            pressed_code <= code_value;
            key_down     <= '1';

            -- Enough time for scanning + debounce
            wait for 250 us;


            ------------------------------------------------------------
            -- Check VALID
            ------------------------------------------------------------
            assert key_status(4) = '1'
                report "ERROR: key_valid was not asserted for key " &
                       key_name
                severity error;


            ------------------------------------------------------------
            -- Check key code
            ------------------------------------------------------------
            assert key_status(3 downto 0) = code_value
                report "ERROR: wrong key code detected for key " &
                       key_name
                severity error;


            ------------------------------------------------------------
            -- Release key
            ------------------------------------------------------------
            key_down <= '0';

            wait for 250 us;


            ------------------------------------------------------------
            -- Check that VALID returned to zero
            ------------------------------------------------------------
            assert key_status(4) = '0'
                report "ERROR: key_valid did not return to 0 after key " &
                       key_name
                severity error;

        end procedure;


    begin

        ----------------------------------------------------------------
        -- Reset
        ----------------------------------------------------------------
        reset_n <= '0';
        key_down <= '0';

        wait for 100 ns;

        reset_n <= '1';

        wait for 50 us;


        ----------------------------------------------------------------
        -- Test password: 9 5 2 #
        ----------------------------------------------------------------

        press_and_check(x"9", "9");

        press_and_check(x"5", "5");

        press_and_check(x"2", "2");

        press_and_check(x"F", "#");


        ----------------------------------------------------------------
        -- Simulation finished successfully
        ----------------------------------------------------------------
        report "KEYPAD TEST PASSED SUCCESSFULLY"
            severity note;

        wait;

    end process;

end Behavioral;