library IEEE;
use IEEE.STD_LOGIC_1164.ALL;

entity STATE_MANAGER_TB is
end STATE_MANAGER_TB;

architecture STATE_MANAGER_TB_ARCH of STATE_MANAGER_TB is

component CLOCK
Port(
    reset: in std_logic;
    clock: in std_logic;
    clckTick: out std_logic
);
end component;

component STATE_MANAGER
Port(
    p1Btn: in std_logic;
    p2Btn: in std_logic;
    
    reset: in std_logic;
    clock: in std_logic;
    clckTick: in std_logic;
    
    syncReset: out std_logic;
    score    : out std_logic_vector(5 downto 0);
    led: out std_logic_vector(15 downto 0)
);
end component;

signal p1Btn: std_logic;
signal p2Btn: std_logic;

--signal p1_syncBtn: std_logic;

signal reset: std_logic;
signal clck: std_logic;
signal clckTick: std_logic;

signal syncReset:  std_logic;
signal score    :  std_logic_vector(5 downto 0);
signal led: std_logic_vector(15 downto 0);

constant ACTIVE: std_logic := '1';

begin

CLOCK_DRIVE: CLOCK port map(
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

UUT: STATE_MANAGER port map(
    p1Btn => p1Btn,
    p2Btn => p2Btn,
    
    reset => reset,
    clock => clck,
    clckTick => clckTick,

    syncReset => syncReset,
    score => score,
    led => led
);

SM_DRIVER: process
begin
    
    reset  <= not ACTIVE;
    p1Btn <= not ACTIVE;
    p2Btn <= not ACTIVE;
    
    wait for 10ns;
    
    reset <= ACTIVE;
    wait for 1ns;
    reset <= not ACTIVE;
    
    wait until (led(15) = ACTIVE); --wait until synchronous reset is done
    
    p1Btn <= ACTIVE;
    wait for 100ns;
    p1Btn <= not ACTIVE;
    
    wait until (led(0) = ACTIVE); -- wait till player 2 recieves the ball
    
    p2Btn <= ACTIVE;
    wait for 100ns;
    p2Btn <= not ACTIVE;
    
    wait until (led(15) = ACTIVE); -- wait till player 1 recieves the ball
   
    p1Btn <= ACTIVE;
    wait for 100ns;
    p1Btn <= not ACTIVE;
    
    wait;
end process;

end STATE_MANAGER_TB_ARCH;
