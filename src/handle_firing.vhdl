library ieee;
use     ieee.std_logic_1164.all;
use     ieee.numeric_std.all;
use		ieee.std_logic_signed.all;
use     work.Utilities.all;

entity handle_firing is 
    generic(
        len_x                   : POSITIVE;
        len_y                   : POSITIVE;
        len_x_b                 : POSITIVE;
        len_y_b                 : POSITIVE
    );
    port(
        Clock           : in  std_logic;
        button          : in  std_logic;
        pos_x           : in  std_logic_vector(9 downto 0);
        pos_y           : in  std_logic_vector(9 downto 0);
        collision       : in  std_logic;
        new_x           : out std_logic_vector(9 downto 0);
        new_y           : out std_logic_vector(9 downto 0)
    );
end entity;

architecture rtl of handle_firing is 

    signal x_int            : integer;
    signal x_tmp            : integer;
    signal y_int            : integer := to_integer(unsigned(pos_y));
    constant y_spd          : POSITIVE := 5;

    signal move_en          : std_logic := '0';

begin

    FIRE_BULLET : process(Clock, button)
    begin
        if rising_edge(Clock) then
            if (collision = '1') then
                x_int <= to_integer(unsigned(pos_x)) + (len_x-len_x_b)/2;
                y_int <= to_integer(unsigned(pos_y));
                move_en <= '0';
            else 
                if (move_en = '1') then 
                    if (y_int - y_spd > 0) then
                        y_int <= y_int - y_spd;
                        x_int <= x_tmp;
                    else 
                        move_en <= '0';
                    end if;
                else
                    if (button = '1') then
                        move_en <= '1';
                        x_tmp <= to_integer(unsigned(pos_x)) + (len_x-len_x_b)/2;
                        y_int <= to_integer(unsigned(pos_y));
                    else 
                        x_int <= to_integer(unsigned(pos_x)) + (len_x-len_x_b)/2;
                        y_int <= to_integer(unsigned(pos_y));
                    end if;
                end if;
            end if;
            new_x <= std_logic_vector(to_unsigned(x_int, new_x'length));
            new_y <= std_logic_vector(to_unsigned(y_int, new_y'length));
        end if;
    end process;

end architecture;