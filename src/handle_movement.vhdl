library ieee;
use     ieee.std_logic_1164.all;
use     ieee.numeric_std.all;
use		ieee.std_logic_signed.all;
use     work.Utilities.all;

entity handle_movement is 
    generic(
        len_x        : POSITIVE
    );
    port(
        Clock               : in  std_logic;
        buttons_in          : in  std_logic_vector(2 downto 0);
        collision           : in  std_logic;
        pos_x               : in  std_logic_vector(9 downto 0);        
        new_x               : out std_logic_vector(9 downto 0)
    );
end entity;

architecture rtl of handle_movement is 

    signal x_int            : integer := to_integer(unsigned(pos_x));
    constant x_spd          : POSITIVE := 3;

begin

    MOVE_ENTITY : process(Clock, buttons_in)
    begin
        if rising_edge(Clock) then
            if (collision = '1') then 
                x_int <= 305;    
            else
                if (buttons_in(0) = '1' and x_int - x_spd > 0) then 
                    x_int <= x_int - x_spd;
                elsif (buttons_in(2) = '1' and x_int + len_x + x_spd < 639) then
                    x_int <= x_int + x_spd;
                end if;
                
                if (x_int < 0) then
                    x_int <= 0;
                elsif (x_int + len_x > 639) then
                    x_int <= 639 - len_x;
                end if; 
            end if;
            new_x <= std_logic_vector(to_unsigned(x_int, new_x'length));
        end if;
    end process;

end architecture;