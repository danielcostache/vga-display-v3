library ieee;
use		ieee.std_logic_1164.all;
use		ieee.numeric_std.all;

entity seg7_encoder is 
	port(
		binary		: in unsigned(3 downto 0);
		dot 		: in std_logic;
		seg7code	: out std_logic_vector(7 downto 0)
	);
end entity;

architecture rtl of seg7_encoder is
begin
	process(binary, dot)
		variable temp : std_logic_vector(6 downto 0);
	begin
		case binary is --   		 gfedcba
			when x"0" => 	temp := "0111111";
			when x"1" => 	temp := "0000110";
			when x"2" => 	temp := "1011011";
			when x"3" => 	temp := "1001111";
			when x"4" => 	temp := "1100110";
			when x"5" => 	temp := "1101101";
			when x"6" => 	temp := "1111101";
			when x"7" => 	temp := "0000111";
			when x"8" => 	temp := "1111111";
			when x"9" => 	temp := "1101111";
			when x"A" => 	temp := "1110111";
			when x"B" => 	temp := "1111100";
			when x"C" => 	temp := "0111001";
			when x"D" => 	temp := "1011110";
			when x"E" => 	temp := "1111001";
			when x"F" => 	temp := "1110001";
			when others =>	temp := "XXXXXXX";
		end case;	
		
		seg7code <= dot & temp;
		
	end process;
end architecture;