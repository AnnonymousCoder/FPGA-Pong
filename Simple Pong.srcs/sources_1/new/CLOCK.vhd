library IEEE;
use IEEE.STD_LOGIC_1164.ALL;

--******************************************************************************
--*
--* Name: CLOCK
--* Designer: Matthew Mwangi
--*
--*     This component dictates the game's gameplay speed, since using the onboard
--*     clock would result undesirably fast gameplay speed. It does this by 
--*     varying the clckTick output's frequency to the desired speed in this case
--*     10hz. The clckTick output is then used by the other components as their  
--*     clock when comes to the ball's movement.
--******************************************************************************

entity CLOCK is
Port(
    reset: in std_logic;
    clock: in std_logic;
    clckTick: out std_logic
);
end CLOCK;

architecture CLOCK_ARCH of CLOCK is

constant ACTIVE: std_logic := '1'; 
constant COUNT_10HZ: integer := (100000000/1000)-1;

begin
    
process(reset, clock)
    variable count: integer range 0 to COUNT_10HZ;
begin
    if (reset = ACTIVE) then
        count := 0;
    elsif (rising_edge(clock)) then
        if (count = COUNT_10HZ) then
            count := 0;
        else
            count := count + 1;
        end if;
    end if;
    
    clckTick <= not ACTIVE;
    if(count = COUNT_10HZ) then
        clckTick <= ACTIVE;
    end if;
end process;

end CLOCK_ARCH;
