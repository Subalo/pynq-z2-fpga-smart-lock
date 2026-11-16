library IEEE;
use IEEE.STD_LOGIC_1164.ALL;
use IEEE.NUMERIC_STD.ALL;

entity keypad_controller is
    generic (
        CLK_FREQ_HZ      : integer := 100000000;
        SCAN_FREQ_HZ     : integer := 1000;
        DEBOUNCE_FRAMES  : integer := 20
    );
    port (
        clk          : in  std_logic;
        reset_n      : in  std_logic;

        keypad_rows  : in  std_logic_vector(3 downto 0);
        keypad_cols  : out std_logic_vector(3 downto 0);

        -- key_status[3:0] = key code
        -- key_status[4]   = key valid
        key_status   : out std_logic_vector(4 downto 0)
    );
end keypad_controller;

architecture Behavioral of keypad_controller is

    constant TICK_MAX : integer := CLK_FREQ_HZ / SCAN_FREQ_HZ;

    signal tick_counter : integer range 0 to TICK_MAX := 0;
    signal scan_tick    : std_logic := '0';

    signal col_index    : integer range 0 to 3 := 0;

    signal frame_pressed : std_logic := '0';
    signal frame_code    : std_logic_vector(3 downto 0) := (others => '0');

    signal raw_pressed   : std_logic := '0';
    signal raw_code      : std_logic_vector(3 downto 0) := (others => '0');

    signal stable_pressed : std_logic := '0';
    signal stable_code    : std_logic_vector(3 downto 0) := (others => '0');

    signal debounce_count : integer range 0 to DEBOUNCE_FRAMES := 0;

begin

    -- Output format to Python:
    -- bit 4 = valid
    -- bits 3 downto 0 = key code
    key_status <= stable_pressed & stable_code;

    -- Scan clock tick
    process(clk)
    begin
        if rising_edge(clk) then
            if reset_n = '0' then
                tick_counter <= 0;
                scan_tick <= '0';
            else
                if tick_counter = TICK_MAX - 1 then
                    tick_counter <= 0;
                    scan_tick <= '1';
                else
                    tick_counter <= tick_counter + 1;
                    scan_tick <= '0';
                end if;
            end if;
        end if;
    end process;

    -- Drive one column LOW at a time
    process(col_index)
    begin
        case col_index is
            when 0 =>
                keypad_cols <= "1110"; -- C1 active low
            when 1 =>
                keypad_cols <= "1101"; -- C2 active low
            when 2 =>
                keypad_cols <= "1011"; -- C3 active low
            when others =>
                keypad_cols <= "0111"; -- C4 active low
        end case;
    end process;

    -- Main keypad scan and debounce logic
    process(clk)
        variable detected_pressed : std_logic;
        variable detected_code    : std_logic_vector(3 downto 0);
        variable next_pressed     : std_logic;
        variable next_code        : std_logic_vector(3 downto 0);
    begin
        if rising_edge(clk) then
            if reset_n = '0' then
                col_index       <= 0;

                frame_pressed   <= '0';
                frame_code      <= (others => '0');

                raw_pressed     <= '0';
                raw_code        <= (others => '0');

                stable_pressed  <= '0';
                stable_code     <= (others => '0');

                debounce_count  <= 0;

            elsif scan_tick = '1' then

                detected_pressed := '0';
                detected_code    := (others => '0');

                -- Rows are active LOW because pull-up is used.
                -- keypad_rows(0) = R1
                -- keypad_rows(1) = R2
                -- keypad_rows(2) = R3
                -- keypad_rows(3) = R4

                if keypad_rows(0) = '0' then
                    detected_pressed := '1';

                    case col_index is
                        when 0 => detected_code := x"1"; -- 1
                        when 1 => detected_code := x"2"; -- 2
                        when 2 => detected_code := x"3"; -- 3
                        when others => detected_code := x"A"; -- A
                    end case;

                elsif keypad_rows(1) = '0' then
                    detected_pressed := '1';

                    case col_index is
                        when 0 => detected_code := x"4"; -- 4
                        when 1 => detected_code := x"5"; -- 5
                        when 2 => detected_code := x"6"; -- 6
                        when others => detected_code := x"B"; -- B
                    end case;

                elsif keypad_rows(2) = '0' then
                    detected_pressed := '1';

                    case col_index is
                        when 0 => detected_code := x"7"; -- 7
                        when 1 => detected_code := x"8"; -- 8
                        when 2 => detected_code := x"9"; -- 9
                        when others => detected_code := x"C"; -- C
                    end case;

                elsif keypad_rows(3) = '0' then
                    detected_pressed := '1';

                    case col_index is
                        when 0 => detected_code := x"E"; -- *
                        when 1 => detected_code := x"0"; -- 0
                        when 2 => detected_code := x"F"; -- #
                        when others => detected_code := x"D"; -- D
                    end case;
                end if;

                -- Accumulate detection over one full 4-column frame
                next_pressed := frame_pressed;
                next_code    := frame_code;

                if detected_pressed = '1' then
                    next_pressed := '1';
                    next_code    := detected_code;
                end if;

                -- End of one full keypad frame
                if col_index = 3 then

                    -- Debounce: compare current frame result to previous raw result
                    if (next_pressed = raw_pressed) and (next_code = raw_code) then
                        if debounce_count < DEBOUNCE_FRAMES then
                            debounce_count <= debounce_count + 1;
                        end if;
                    else
                        debounce_count <= 0;
                        raw_pressed <= next_pressed;
                        raw_code <= next_code;
                    end if;

                    -- Accept stable result
                    if debounce_count >= DEBOUNCE_FRAMES - 1 then
                        stable_pressed <= next_pressed;
                        stable_code <= next_code;
                    end if;

                    -- Clear frame for next full scan
                    frame_pressed <= '0';
                    frame_code <= (others => '0');

                    col_index <= 0;

                else
                    frame_pressed <= next_pressed;
                    frame_code <= next_code;

                    col_index <= col_index + 1;
                end if;
            end if;
        end if;
    end process;

end Behavioral;