library IEEE;
use IEEE.STD_LOGIC_1164.ALL;

--******************************************************************************
--*
--* Name: INPUT_SYNC
--* Designer: Matthew Mwangi
--*
--*     This is a component that handles synching its input in this case the aSyncIn 
--*     active clock, to avoid metastability issues.
--*     
--******************************************************************************


entity INPUT_SYNC is
  Port ( 
    reset: in std_logic;
    clock: in std_logic;
    aSyncIn: in std_logic;
    syncOut: out std_logic
  );
end INPUT_SYNC;

architecture INPUT_SYNC_ARCH of INPUT_SYNC is
    constant ACTIVE: std_logic := '1';
    signal syncChain: std_logic_vector(1 downto 0);
begin
    process(reset, clock)
    begin
        if reset = ACTIVE then
            syncChain <= (others=>'0');
        elsif rising_edge(clock) then
            syncChain <= syncChain(0) & aSyncIn;
        end if;
    end process;
    
    syncOut <= syncChain(1);
end INPUT_SYNC_ARCH;
