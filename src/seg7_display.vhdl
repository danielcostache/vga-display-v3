library ieee;
use		ieee.std_logic_1164.all;
use		ieee.numeric_std.all;
use		work.Utilities.all;

entity seg7_display is 
	generic(
		CLOCK_FREQUENCY 		: FREQUENCY;
		DISPLAY_REFRESH_RATE 	: FREQUENCY := 1 kHz;
	    NUMBER_OF_DIGITS 		: positive
	);	
	port(
		Digits 			: in T_BCD_Vector(NUMBER_OF_DIGITS-1 downto 0);
		Clock			: in std_logic;
	
		Seg7_Cathodes 	: out std_logic_vector(7 downto 0);
		Seg7_Anodes 	: out std_logic_vector(NUMBER_OF_DIGITS-1 downto 0)
	);
end entity;


architecture rtl of seg7_display is
	constant TICK_COUNTER_MODULO   : positive := CLOCK_FREQUENCY / DISPLAY_REFRESH_RATE;
	
	signal tick_1khZ 		       : std_logic;
	signal DigitSelect		       : unsigned(log2(NUMBER_OF_DIGITS)-1 downto 0);
	signal Digit 				   : T_BCD;
	signal Dot					   : std_logic;
begin

	cntTick : entity work.cycler
		generic map(
		MODULO => TICK_COUNTER_MODULO
		)
		port map (
			Clock => Clock,	
			Reset => '0',
			Enable => '1',
			DigitSelect => open,
			Wraparound => tick_1khZ
		);

	digSelector : entity work.cycler
		generic map (
			MODULO => NUMBER_OF_DIGITS
		)
		port map (
			Clock => Clock,
			Reset => '0',
			Enable => tick_1khZ,
			DigitSelect => DigitSelect,
			Wraparound => open
		);

	-- Onehot
	Digit <= Digits(to_integer(DigitSelect));
	Seg7_Anodes <= bin2onehot(DigitSelect,Seg7_Anodes'length);

	enc : entity work.seg7_encoder
		port map (
		binary => Digit,
		dot => '0',
		Seg7Code  => Seg7_Cathodes
		);	
end architecture;