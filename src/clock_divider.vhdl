library ieee;
use     ieee.std_logic_1164.all;
use     ieee.numeric_std.all;
use     work.Utilities.all;

entity clock_divider is
    port(
        Clock_in    : in  std_logic;
        Reset       : in  std_logic;
        half_period : in  integer;
        Clock_div   : out std_logic -- Outputs the divided clock signal
    );
end entity;

architecture rtl of clock_divider is
    signal cnt          : integer := 1;     -- Counter that delays the ticks of the divided clock
    signal temp_clock   : std_logic := '0'; -- Holds the value of the divided clock signal
begin

    DIVIDE : process(Clock_in, Reset)
    begin
        if (Reset = '1') then
            cnt <= 1;
            temp_clock <= '0';
        elsif rising_edge(Clock_in) then
            cnt <= cnt + 1;
            -- cnt measures a half-period of the 25MHz VGA clock
            if (cnt = half_period) then 
                temp_clock <= not temp_clock;
                cnt <= 1;
            end if;
        end if;
        Clock_div <= temp_clock;
    end process;

end architecture;