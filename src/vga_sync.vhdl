library ieee;
use     ieee.std_logic_1164.all;
use     ieee.numeric_std.all;
use		ieee.std_logic_signed.all;
use     work.Utilities.all;

entity vga_sync is 
    port(
        Clock       : in  std_logic;
        Reset       : in  std_logic;
        pos_x       : out std_logic_vector(9 downto 0); -- Horizontal position on screen
        pos_y       : out std_logic_vector(9 downto 0); -- Vertical position on screen
        hsync       : out std_logic; -- H-sync
        vsync       : out std_logic; -- V-sync
        en          : out std_logic  -- Enable signal
    );
end entity;

architecture rtl of vga_sync is 

    -- Horizontal display timing:
    -- Active area: 640 pixels,
    -- Front porch: 16 pixels,
    -- H-sync: 96 pixels,
    -- Back porch: 48 pixels,
    -- Total pixels: 800 pixels,
    -- Blanking space: 160 pixels
    constant HA_END     : integer := 639;
    constant HS_ST      : integer := HA_END + 16;
    constant HS_END     : integer := HS_ST + 96;
    constant H_END      : integer := 799;

    -- Vertical display timing:
    -- Active area: 480 pixels,
    -- Front porch: 10 pixels,
    -- V-sync: 2 pixels,
    -- Back porch: 33 pixels,
    -- Total pixels: 525 pixels,
    -- Blanking space: 45 pixels
    constant VA_END     : integer := 479;
    constant VS_ST      : integer := VA_END + 10;
    constant VS_END     : integer := VS_ST + 2;
    constant V_END      : integer := 524;

    -- Internal values for pos_x, pos_y
    signal x_int    : std_logic_vector(9 downto 0);
    signal y_int    : std_logic_vector(9 downto 0);

    signal pixel_clock : std_logic;

begin 

    vga_sync : entity work.clock_divider
        port map(
            Clock_in => Clock,
            Reset => Reset,
            half_period => 2,
            Clock_div => pixel_clock
        );

    COMB_SCREEN : process(pixel_clock, x_int, y_int)
    begin
        if rising_edge(pixel_clock) then
            -- When hsync is set to HIGH, a new line begins
            if (to_integer(unsigned(x_int)) >= HS_ST and 
            to_integer(unsigned(x_int)) < HS_END) then
                hsync <= '0';
            else 
                hsync <= '1';
            end if;
            -- When vsync is set to HIGH, a new frame begins
            if (to_integer(unsigned(y_int)) >= VS_ST and 
                to_integer(unsigned(y_int)) < VS_END) then
                vsync <= '0';
            else 
                vsync <= '1';
            end if;
            -- When pixel is in active area, en is set to HIGH
            -- and when it is in blanking area, en is set to LOW
            if (to_integer(unsigned(x_int)) <= HA_END and 
                to_integer(unsigned(y_int)) <= VA_END) then
                en <= '1';
            else 
                en <= '0';
            end if;
        end if;
    end process;

    PIXEL_POSITION : process(pixel_clock)
    begin
        if rising_edge(pixel_clock) then
            if (Reset = '1') then
                x_int <= (others => '0');
                y_int <= (others => '0');    
            elsif (to_integer(unsigned(x_int)) = H_END) then     -- Last pixel on line
                x_int <= (others => '0');
                if (to_integer(unsigned(y_int)) = V_END) then    -- Last line on screen
                    y_int <= (others => '0');
                else 
                    y_int <= std_logic_vector(unsigned(y_int) + 1);
                end if;
            else 
                x_int <= std_logic_vector(unsigned(x_int) + 1);
            end if;
            pos_x <= x_int;
            pos_y <= y_int;
        end if;
    end process;

end architecture;