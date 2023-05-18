library ieee;
use		ieee.std_logic_1164.all;
use		ieee.numeric_std.all;
use		work.Utilities.all;

entity cycler is 
    generic(
        MODULO 		: positive;
		BITS		: positive := log2(MODULO)
    );
    port(
        Clock 		: in std_logic;
        Reset 		: in std_logic;
        Enable 		: in std_logic;
        DigitSelect : out unsigned(BITS-1 downto 0) := (others => '0');
        Wraparound  : out std_logic
    );
end entity;

architecture rtl of cycler is
    constant COUNTER_BITS : positive := log2(MODULO);
	signal Counter : unsigned(COUNTER_BITS - 1 downto 0) := (others => '0');

begin

    process(Clock)
    begin
        if (rising_edge(Clock)) then 
            if (Reset = '1') then
                Counter <= (others => '0');
            elsif (Enable = '1') then
                Counter <= Counter + 1;
            end if;
        end if;
    end process;
    Wraparound <= Enable when (Counter = MODULO - 1) else '0';
    DigitSelect <= resize(Counter, BITS);

end architecture;