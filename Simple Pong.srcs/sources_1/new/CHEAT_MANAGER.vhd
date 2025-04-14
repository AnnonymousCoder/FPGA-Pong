library IEEE;
use IEEE.STD_LOGIC_1164.ALL;
use IEEE.NUMERIC_STD.ALL;

entity CHEAT_MANAGER is
  Port ( 
        input: in std_logic;
        clock: in std_logic;
        reset: in std_logic;
        
        btnPress: out std_logic
   );
end CHEAT_MANAGER;

architecture CHEAT_MANAGER_ARCH of CHEAT_MANAGER is
    constant ACTIVE: std_logic := '1';
    
    signal inputTracker: std_logic_vector(1 downto 0);
begin

    CM: process(reset, clock, input)
    begin
        if reset = ACTIVE then
            inputTracker <= (others=>'0');
        elsif rising_edge(clock) then
            inputTracker <= input & inputTracker(1);
            if inputTracker = "10" then
                btnPress <= ACTIVE;
            else
                btnPress <= not ACTIVE;
            end if;
        end if;
    end process CM;
end CHEAT_MANAGER_ARCH;
