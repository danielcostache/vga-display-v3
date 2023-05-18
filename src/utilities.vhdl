library ieee;
use 	ieee.numeric_std.all;
use		ieee.std_logic_1164.all;
use     ieee.std_logic_unsigned.all;

package Utilities is
	subtype T_BCD is unsigned(3 downto 0);
	type T_BCD_Vector is array(natural range <>) of T_BCD;
	type logic_array is array (integer range <>) of std_logic_vector(9 downto 0);

	type FREQUENCY is range 0 to integer'high units
		Hz;
		kHz = 1000 Hz;
		MHz = 1000 kHz;
		GHz = 1000 MHz;
	end units;
	
	function log2(value : positive) return natural;
	function bin2onehot(value : unsigned; size : positive) return std_logic_vector;
	function bcd_to_bin(bcd_in : T_BCD_Vector(2 downto 0)) return std_logic_vector;
	function bin_to_bcd(bin_in : std_logic_vector(7 downto 0)) return T_BCD_Vector;
	
end package;

package body Utilities is 

    function bcd_to_bin(bcd_in : T_BCD_Vector(2 downto 0)) return std_logic_vector is
		variable result : std_logic_vector(7 downto 0);
		variable temp : integer;
	begin
		temp := to_integer(bcd_in(0)) + 
		        to_integer(bcd_in(1))*10 +
		        to_integer(bcd_in(2))*100;
		result := std_logic_vector(to_unsigned(temp, result'length));
	    return result;
	end function;
	
	function bin_to_bcd(bin_in : std_logic_vector(7 downto 0)) return T_BCD_Vector is
		variable i 			: integer := 0;
		variable temp 		: std_logic_vector(11 downto 0);
		variable result 	: T_BCD_Vector(2 downto 0);
		variable bin_int	: std_logic_vector(7 downto 0) := bin_in;
	begin
		for i in 0 to 7 loop
			temp(11 downto 1) := temp(10 downto 0);
			temp(0) := bin_int(7);
			bin_int(7 downto 1) := bin_int(6 downto 0);
			bin_int(0) := '0';

			if (i < 7 and temp(3 downto 0) > "0100") then
				temp(3 downto 0) := temp(3 downto 0) + "0011";
			end if;

			if (i < 7 and temp(7 downto 4) > "0100") then
				temp(7 downto 4) := temp(7 downto 4) + "0011";
			end if;

			if (i < 7 and temp(11 downto 8) > "0100") then
				temp(11 downto 8) := temp(11 downto 8) + "0011";
			end if;
		end loop;
		result(2) := unsigned(temp(11 downto 8));
		result(1) := unsigned(temp(7  downto 4));
		result(0) := unsigned(temp(3  downto 0));
		return result;
	end function;

	function log2(value:positive) return natural is
	begin
		for i in 0 to 31 loop
			if 2**i >= value then
				return i;
			end if;		
		end loop;
	end function;
	
	function bin2onehot(value : unsigned; size : positive) return std_logic_vector is
		variable result : std_logic_vector(size - 1 downto 0) := (others => '0');
	begin
		result(to_integer(value)) := '1';
		return result;
	end function;

end package body;