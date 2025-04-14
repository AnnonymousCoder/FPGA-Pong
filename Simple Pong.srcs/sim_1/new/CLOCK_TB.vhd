library IEEE;
use IEEE.STD_LOGIC_1164.ALL;



entity CLOCK_TB is
end CLOCK_TB;

architecture CLOCK_TB_ARCH of CLOCK_TB is

component CLOCK
Port(
    reset: in std_logic;
    clock: in std_logic;
    clckTick: out std_logic
);
end component;

signal reset:  std_logic;
signal clck:  std_logic;
signal clckTick:  std_logic;

constant ACTIVE: std_logic := '1';

begin

UUT: CLOCK port map(
    reset => reset,
    clock => clck,
    clckTick => clckTick
);

process
begin
    clck <= ACTIVE;
    wait for 5ns;
    clck <= not ACTIVE;
    wait for 5ns;    
end process;

end CLOCK_TB_ARCH;
