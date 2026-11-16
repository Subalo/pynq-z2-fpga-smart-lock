library IEEE;
use IEEE.STD_LOGIC_1164.ALL;

-- TB for the clock divider
entity clk_tb is
end clk_tb;

architecture Behavioral of clk_tb is
component clk_divider is
 port(
        clk_system_125MHZ : in  std_logic;
        reset             : in  std_logic;
        clk_500HZ         : out std_logic
    );
end component;
signal reset,clk_500HZ,clk_system_125MHZ  : std_logic := '0';
-- Clock period definition for 125 MHz (1 / 125,000,000 = 8 ns)
constant period : time := 8 ns;
begin 
u1 : clk_divider
port map( 
clk_system_125MHZ => clk_system_125MHZ,reset => reset, clk_500HZ => clk_500HZ
);
-- Clock generation (125MHZ)
process
begin
clk_system_125MHZ <= not clk_system_125MHZ;
wait for period/2;
end process;

-- stimulus 
process
begin
wait for period*199000;
reset <= '1';
wait for period*4;
reset <= '0';
wait for period;
wait;
end process;

end Behavioral;
