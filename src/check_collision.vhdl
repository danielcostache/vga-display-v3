library ieee;
use     ieee.std_logic_1164.all;
use     ieee.numeric_std.all;
use     work.Utilities.all;
use		ieee.std_logic_signed.all;

entity check_collision is 
    generic(
        len_x_e             : POSITIVE;     
        len_y_e             : POSITIVE;     
        len_x_p             : POSITIVE; 
        len_y_p             : POSITIVE; 
        len_x_b             : POSITIVE; 
        len_y_b             : POSITIVE;
        NUMBER_OF_DIGITS    : POSITIVE
    );
    port(
        Clock       : in  std_logic;
        x_e         : in  std_logic_vector(9 downto 0);
        y_e         : in  std_logic_vector(9 downto 0);
        x_b         : in  std_logic_vector(9 downto 0);
        y_b         : in  std_logic_vector(9 downto 0);
        x_p         : in  std_logic_vector(9 downto 0);
        y_p         : in  std_logic_vector(9 downto 0);
        score_in    : in  T_BCD_Vector(NUMBER_OF_DIGITS-1 downto 0);
        score_out   : out T_BCD_Vector(NUMBER_OF_DIGITS-1 downto 0);
        collision   : out std_logic
    );
end entity;

architecture rtl of check_collision is

    signal xe_int           : integer := to_integer(unsigned(x_e));
    signal ye_int           : integer := to_integer(unsigned(y_e));
    signal xb_int           : integer := to_integer(unsigned(x_b));
    signal yb_int           : integer := to_integer(unsigned(y_b));
    signal xp_int           : integer := to_integer(unsigned(x_p));
    signal yp_int           : integer := to_integer(unsigned(y_p));

    signal deaths           : std_logic_vector(7 downto 0) := bcd_to_bin(score_in(6 downto 4));
    signal kills            : std_logic_vector(7 downto 0) := bcd_to_bin(score_in(2 downto 0));

begin

    COLLISION_CHECK : process(Clock, x_e, y_e, x_b, y_b)
    begin
        if rising_edge(Clock) then
            -- Check player collision
            if (yp_int > ye_int-1 and yp_int < ye_int+len_y_e-1) then
                collision <= '1';
                deaths <= std_logic_vector(unsigned(deaths) + 1);
            elsif (yp_int+len_y_p > ye_int-1 and yp_int+len_y_p < ye_int+len_y_e-1) then
                collision <= '1';
                deaths <= std_logic_vector(unsigned(deaths) + 1);
            else 
                collision <= '0';
            end if;
            
            -- Check bullet collisioon
            if (xb_int > xe_int-1 and xb_int < xe_int+len_x_e-1) then
                if (yb_int > ye_int-1 and yb_int < ye_int+len_y_e-1) then
                    collision <= '1';
                    kills <= std_logic_vector(unsigned(kills) + 1);
                elsif (yb_int+len_y_b > ye_int-1 and yb_int+len_y_b < ye_int+len_y_e-1) then
                    collision <= '1';
                    kills <= std_logic_vector(unsigned(kills) + 1);
                else 
                    collision <= '0';
                end if;
            elsif (xb_int+len_x_b > xe_int-1 and xb_int+len_x_b < xe_int+len_x_e-1) then
                if (yb_int > ye_int-1 and yb_int < ye_int+len_y_e-1) then
                    collision <= '1';
                    kills <= std_logic_vector(unsigned(kills) + 1);
                elsif (yb_int+len_y_b > ye_int-1 and yb_int+len_y_b < ye_int+len_y_e-1) then
                    collision <= '1';
                    kills <= std_logic_vector(unsigned(kills) + 1);
                else 
                    collision <= '0';
                end if;
            else 
                collision <= '0';
            end if;
        end if;
        score_out(7) <= "0000";
        score_out(6 downto 4) <= bin_to_bcd(deaths);
        score_out(3) <= "0000";
        score_out(2 downto 0) <= bin_to_bcd(kills);
    end process;
    
end architecture;