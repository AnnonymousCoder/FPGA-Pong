library IEEE;
use IEEE.STD_LOGIC_1164.ALL;


entity INPUT_SYNC_TB is
end INPUT_SYNC_TB;

architecture INPUT_SYNC_TB_ARCH of INPUT_SYNC_TB is
 component INPUT_SYNC
    Port ( 
        reset: in std_logic;
        clock: in std_logic;
        aSyncIn: in std_logic;
        syncOut: out std_logic
      );
 end component;
 
 constant ACTIVE: std_logic := '1';
 
 signal reset: std_logic;
 signal clck: std_logic;
 signal aSyncIn: std_logic;
 signal syncOut: std_logic;
 
begin
    process
    begin
        clck <= ACTIVE;
        wait for 5ns;
        clck <= not ACTIVE;
        wait for 5ns;    
    end process;
    
    
UUT: INPUT_SYNC port map(
    reset => reset,
    clock => clck,
    aSyncIn => aSyncIn,
    syncOut => syncOut
);

    process
    begin
        
        aSyncIn <= not ACTIVE;
        
        wait for 1ns;
        
        reset <= ACTIVE;
        wait for 10ns;
        reset <= not ACTIVE;
        
        wait until (reset = not ACTIVE); 
    
        aSyncIn <= ACTIVE;
        wait for 10ns;
        aSyncIn <= not ACTIVE;
        wait;   
    end process;

end INPUT_SYNC_TB_ARCH;
