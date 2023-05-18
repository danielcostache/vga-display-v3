library ieee;
use     ieee.std_logic_1164.all;
use     ieee.numeric_std.all;
use     work.Utilities.all;
use		ieee.std_logic_signed.all;

entity toplevel is
    port(
        Clock               : in  std_logic; 
        Reset_n             : in  std_logic; -- Default is reset LOW

        Buttons             : in  std_logic_vector(2 downto 0);

        VGA_red             : out std_logic_vector(3 downto 0);
        VGA_grn             : out std_logic_vector(3 downto 0);
        VGA_blu             : out std_logic_vector(3 downto 0);
        H_sync              : out std_logic; 
        V_sync              : out std_logic;

        seg7_cathodes_n		: out std_logic_vector(7 downto 0);
		seg7_anodes_n		: out std_logic_vector(7 downto 0)
    );
end entity;

architecture rtl of toplevel is

    constant CLOCK_FREQUENCY        : FREQUENCY :=  100 MHz;
    
    signal Reset        : std_logic;

    -- Pixel characteristics
    signal pixel_x      : std_logic_vector(9 downto 0);
    signal pixel_y      : std_logic_vector(9 downto 0);
    signal en_disp      : std_logic;

    signal red          : std_logic_vector(3 downto 0);
    signal grn          : std_logic_vector(3 downto 0);
    signal blu          : std_logic_vector(3 downto 0);

    -- Characteristics of the player's ship
    signal x_o          : std_logic_vector(9 downto 0);
    signal y_o          : std_logic_vector(9 downto 0);
    constant len_x      : POSITIVE := 30;
    constant len_y      : POSITIVE := 10;

    -- Characteristics of the player's bullet
    signal x_b          : std_logic_vector(9 downto 0); 
    signal y_b          : std_logic_vector(9 downto 0);
    constant len_x_b    : POSITIVE := 4;
    constant len_y_b    : POSITIVE := 8;

    -- Characteristics of the enemy's ship
    signal x_e          : std_logic_vector(9 downto 0) := (others => '0'); 
    signal y_e          : std_logic_vector(9 downto 0) := (others => '0');
    constant len_x_e    : POSITIVE := 20;
    constant len_y_e    : POSITIVE := 20;

    signal collision    : std_logic;

    signal refresh_clock    : std_logic;

    -- Parameters for the 7-segment LED display
    constant NUMBER_OF_DIGITS         : positive := 8;
    signal score 			          : T_BCD_Vector(NUMBER_OF_DIGITS-1 downto 0);
	signal seg7_cathodes              : std_logic_vector(7 downto 0);
	signal seg7_anodes 		          : std_logic_vector(NUMBER_OF_DIGITS-1 downto 0); --each digit connected to an anode
	
    signal draw_player  : std_logic;
    signal draw_bullet  : std_logic;
    signal draw_enemy   : std_logic;

begin
    
    -- Convert Reset signal to reset HIGH
    Reset <= not Reset_n;
    y_o <= std_logic_vector(to_unsigned(400, y_o'length));

    -- Syncs pixel positions
    vga_sync : entity work.vga_sync 
        port map(
            Clock => Clock,
            Reset => Reset,
            pos_x => pixel_x,
            pos_y => pixel_y,
            hsync => H_sync,
            vsync => V_sync,
            en => en_disp
        );

    refresh_divider : entity work.clock_divider
        port map (
            Clock_in => Clock,
            Reset => Reset,
            half_period => 420000,
            Clock_div => refresh_clock
        );

    -- Handles the movement of the player
    handle_movement : entity work.handle_movement
        generic map(
            len_x => len_x
        )
        port map(
            Clock => refresh_clock,
            buttons_in => Buttons,
            collision => collision,
            pos_x => x_o,
            new_x => x_o
        );

    -- Handles the movement of the enemy
    enemy_movement : entity work.enemy_movement
    generic map(
        len_x => len_x_e,
        len_y => len_y_e
    )
    port map(
        Clock => refresh_clock,
        pos_x => x_e,
        pos_y => y_e,
        collision => collision,
        new_x => x_e,
        new_y => y_e
    );

    -- Handles the firing of the player
    handle_firing : entity work.handle_firing
        generic map(
            len_x => len_x,
            len_y => len_y,
            len_x_b => len_x_b,
            len_y_b => len_y_b
        )
        port map(
            Clock => refresh_clock,
            button => Buttons(1),
            pos_x => x_o,
            pos_y => y_o,
            collision => collision,
            new_x => x_b,
            new_y => y_b
        );

    check_collision : entity work.check_collision
        generic map(
            len_x_e => len_x_e,
            len_y_e => len_y_e,
            len_x_p => len_x,
            len_y_p => len_y,
            len_x_b => len_x_b,
            len_y_b => len_y_b,
            NUMBER_OF_DIGITS => NUMBER_OF_DIGITS
        )
        port map(
            Clock => refresh_clock,
            x_e => x_e,
            y_e => y_e,
            x_b => x_b,
            y_b => y_b,
            x_p => x_o,
            y_p => y_o,
            score_in => score,
            score_out => score,
            collision => collision
        );
    
    seg7_display : entity work.seg7_display
        generic map(
            CLOCK_FREQUENCY => CLOCK_FREQUENCY,
            NUMBER_OF_DIGITS => NUMBER_OF_DIGITS
        )
        port map(
            Clock => Clock,
            Digits => score,
            Seg7_Cathodes => seg7_cathodes,
            Seg7_Anodes => seg7_anodes
        );

    seg7_cathodes_n <= not seg7_cathodes;
    seg7_anodes_n <= not seg7_anodes;

    DRAW_PIXELS : process(pixel_x, pixel_y, x_o, y_o, x_e, y_e, x_b, y_b, en_disp)
    begin
        draw_player <=  '1' when    to_integer(unsigned(pixel_x)) > to_integer(unsigned(x_o)) and
                                    to_integer(unsigned(pixel_x)) < to_integer(unsigned(x_o)) + len_x and
                                    to_integer(unsigned(pixel_y)) > to_integer(unsigned(y_o)) and
                                    to_integer(unsigned(pixel_y)) < to_integer(unsigned(y_o)) + len_y else
                        '0';
        draw_bullet <=  '1' when    to_integer(unsigned(pixel_x)) > to_integer(unsigned(x_b)) and
                                    to_integer(unsigned(pixel_x)) < to_integer(unsigned(x_b)) + len_x_b and
                                    to_integer(unsigned(pixel_y)) > to_integer(unsigned(y_b)) and
                                    to_integer(unsigned(pixel_y)) < to_integer(unsigned(y_b)) + len_y_b else
                        '0';
        draw_enemy  <=  '1' when    to_integer(unsigned(pixel_x)) > to_integer(unsigned(x_e)) and
                                    to_integer(unsigned(pixel_x)) < to_integer(unsigned(x_e)) + len_x_e and
                                    to_integer(unsigned(pixel_y)) > to_integer(unsigned(y_e)) and
                                    to_integer(unsigned(pixel_y)) < to_integer(unsigned(y_e)) + len_y_e else
                        '0';
        if (en_disp = '1') then
            if (draw_player = '1') then
                    red <= b"1111";
                    grn <= b"1111";
                    blu <= b"1111";
            elsif (draw_bullet = '1') then
                    red <= b"1111";
                    grn <= b"1111";
                    blu <= b"1111"; 
            elsif (draw_enemy = '1') then
                    red <= b"1111";
                    grn <= b"0000";
                    blu <= b"0000"; 
            else 
                red <= b"0000";
                grn <= b"0000";
                blu <= b"1111";
            end if;
        else 
            red <= b"0000";     
            grn <= b"0000";
            blu <= b"0000";       
        end if;
        VGA_red <= red;
        VGA_grn <= grn;
        VGA_blu <= blu;
    end process;

end architecture;  