library ieee;
use     ieee.std_logic_1164.all;
use     ieee.numeric_std.all;
use     work.Utilities.all;
use		ieee.std_logic_signed.all;

entity binary_to_bcd is 
    port(
        Clock       : in  std_logic;
        binary_in   : in  std_logic_vector(13 downto 0);
        bcd_out     : out T_BCD_Vector(3 downto 0)
    );
end entity;

architecture rtl of binary_to_bcd is 

    signal ones             : T_BCD;
    signal tens             : T_BCD;
    signal hundreds         : T_BCD;
    signal thousands        : T_BCD;
    signal shift_register   : unsigned(29 downto 0);
    signal old_value        : std_logic_vector(13 downto 0);

    signal i                : integer := 0;

begin 

    CONVERT : process(Clock)
    begin
        if rising_edge(Clock) then
            if (i=0 and (old_value /= binary_in)) then
                shift_register <= (others => '0');
                old_value <= binary_in;
                shift_register(13 downto 0) <= unsigned(binary_in);
                thousands <= shift_register(29 downto 26);
                hundreds <= shift_register(25 downto 22);
                tens <= shift_register(21 downto 18);
                ones <= shift_register(17 downto 14);
                i <= i+1;
            end if;
            if (i<13 and i>0) then
                if (thousands>5) then
                    thousands <= thousands+3;
                end if;
                if (hundreds>5) then
                    hundreds <= hundreds+3;
                end if;
                if (tens>5) then
                    tens <= tens+3;
                end if;
                if (ones>5) then
                    ones <= ones+3;
                end if;
                shift_register(29 downto 14) <= thousands & hundreds & tens & ones;
                shift_register <= shift_register sll 1;
                thousands <= shift_register(29 downto 26);
                hundreds <= shift_register(25 downto 22);
                tens <= shift_register(21 downto 18);
                ones <= shift_register(17 downto 14);
                i <= i+1;
            end if;
            if (i=13) then
                i <= 0;
                bcd_out(3) <= thousands;
                bcd_out(2) <= hundreds;
                bcd_out(1) <= tens;
                bcd_out(0) <= ones;
            end if;
        end if;
    end process;

end architecture;