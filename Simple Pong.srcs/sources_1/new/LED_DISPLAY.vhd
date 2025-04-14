library IEEE;
use IEEE.STD_LOGIC_1164.ALL;
use IEEE.NUMERIC_STD.ALL;
--******************************************************************************
--*
--* Name: LED_DISPLAY
--* Designer: Matthew Mwangi
--*
--*     This component is in charge of mapping the ball's position to the on   
--*     board leds
--*
--******************************************************************************

entity LED_DISPLAY is
  Port ( 
        pos:   in std_logic_vector(3 downto 0); --Ball's current position
        clock: in std_logic;
        reset: in std_logic;
        
        leds: out std_logic_vector(15 downto 0)
  );
end LED_DISPLAY;

architecture LED_DISPLAY_ARCH of LED_DISPLAY is
    constant ACTIVE: std_logic := '1';
begin

    DISPLAY:process(reset, clock, pos)
    begin 
        if reset = ACTIVE then
            leds <= (others=>'0');
        elsif rising_edge(clock) then
            leds <= (others=>'0');
            leds(to_integer(unsigned(pos))) <= ACTIVE; --maping ball's position to led position
        end if;
    end process DISPLAY;

end LED_DISPLAY_ARCH;
