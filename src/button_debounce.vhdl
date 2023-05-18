library ieee;
use     ieee.std_logic_1164.all;
use     ieee.numeric_std.all;
use     work.Utilities.all;
use		ieee.std_logic_signed.all;

entity button_debounce is 
    port(
        Clock   : in  std_logic;
        b_in    : in  std_logic;
        b_out   : out std_logic
    );
end entity;

architecture rtl of button_debounce is 

    signal sync0    : std_logic;
    signal sync1    : std_logic;
    signal cnt      : std_logic_vector(17 downto 0);
    signal idle     : std_logic;
    signal max      : std_logic;

begin

    SYNC : process(Clock, b_in)
    begin
        if rising_edge(Clock) then
            sync0 <= b_in;
            sync1 <= sync0;
        end if;
    end process;

    STATE : process(cnt, sync1)
    begin 
        if (b_out = sync1) then
            idle <= '1';
        else 
            idle <= '0';
        end if;
        max <= and cnt;
    end process;

    COUNT : process(Clock, idle, max)
    begin 
        if rising_edge(Clock) then 
            if (idle = '1') then
                cnt <= (others => '0');
            else
                cnt <= std_logic_vector(unsigned(cnt) + 1);
                if (max = '1') then
                    b_out <= not b_out;
                end if;
            end if; 
        end if;
    end process;

end architecture;