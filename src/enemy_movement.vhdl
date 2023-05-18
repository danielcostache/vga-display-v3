library ieee;
use     ieee.std_logic_1164.all;
use     ieee.numeric_std.all;
use		ieee.std_logic_signed.all;
use     work.Utilities.all;

entity enemy_movement is
    generic(
        len_x       : POSITIVE;
        len_y       : POSITIVE
    );
    port(
        Clock       : in  std_logic;
        pos_x       : in  std_logic_vector(9 downto 0);
        pos_y       : in  std_logic_vector(9 downto 0);
        collision   : in  std_logic;
        new_x       : out std_logic_vector(9 downto 0);
        new_y       : out std_logic_vector(9 downto 0)
    );
end entity;

architecture rtl of enemy_movement is

    signal x_int            : integer := to_integer(unsigned(pos_x));
    signal y_int            : integer := to_integer(unsigned(pos_y));
    signal x_dir            : std_logic;
    constant x_spd          : integer := 2;
    constant y_spd          : integer := 10;

    constant H_LIM          : integer := 639;
    constant V_LIM          : integer := 400;

begin

    MOVE_ENTITY : process(Clock)
    begin
        if rising_edge(Clock) then
            if (collision = '1') then 
                x_int <= 0;
                y_int <= 0;
            else 
                if(x_dir = '1') then
                    if(x_int + len_x + x_spd >= H_LIM - 1) then
                        x_dir <= not x_dir;
                        x_int <= H_LIM - len_x - 1;
                        if(y_int + len_y + y_spd >= V_LIM - 1) then
                            y_int <= 0;
                        else
                            y_int <= y_int + y_spd;
                        end if;
                    else 
                        x_int <= x_int + x_spd;
                    end if;
                else 
                    if(x_int < x_spd) then
                        x_dir <= not x_dir;
                        x_int <= 0;
                        if(y_int + len_y + y_spd >= V_LIM - 1) then
                            y_int <= 0;
                        else
                            y_int <= y_int + y_spd;
                        end if;
                    else 
                        x_int <= x_int - x_spd;
                    end if;    
                end if;
            end if;
            new_x <= std_logic_vector(to_unsigned(x_int, new_x'length));
            new_y <= std_logic_vector(to_unsigned(y_int, new_y'length));
        end if;
    end process;

end architecture;