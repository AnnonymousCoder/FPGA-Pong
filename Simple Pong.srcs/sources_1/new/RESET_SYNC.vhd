library IEEE;
use IEEE.STD_LOGIC_1164.ALL;

--******************************************************************************
--*
--* Name: RESET_SYNC
--* Designer: Matthew Mwangi
--*
--*     This is a component that handles synching its input in this case the reset 
--*     active clock, to avoid metastability issues.
--*     
--******************************************************************************


entity RESET_SYNC is
  Port (
        reset: in std_logic;
        clock: in std_logic;
        synchedReset: out std_logic
   );
end RESET_SYNC;

architecture RESET_SYNC_ARCH of RESET_SYNC is
    constant ACTIVE_RESET: std_logic := '1';
    signal chain: std_logic_vector(1 downto 0);
begin
    process(reset, clock)
    begin
        if reset = ACTIVE_RESET then
            chain <= (others=>ACTIVE_RESET);
        elsif rising_edge(clock) then
            chain <= chain(0) & not ACTIVE_RESET;
        end if;
    end process;
    
    synchedReset <= chain(chain'high);
end RESET_SYNC_ARCH;
