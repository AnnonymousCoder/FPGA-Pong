library IEEE;
use IEEE.STD_LOGIC_1164.ALL;


--******************************************************************************
--*
--* Name: PONG_BASYS3
--* Designer: Matthew Mwangi
--*
--*     This is a wrapper that combines the CLOCK, 7SEG_DISPLAY and the STATE_MANAGER  
--*     components and maps their input and outputs to their corresponding Basys3
--*     board's input and outputs.
--******************************************************************************


entity PONG_BASYS3 is
Port(
    clk: in std_logic;
    btnC: in std_logic;    --reset
    btnR: in std_logic;    --player two
    btnL: in std_logic;    --player one
    led: out std_logic_vector(15 downto 0);  --game board
    seg: out std_logic_vector(6 downto 0);   --score display (uncomment for advanced pong)
    an : out std_logic_vector(3 downto 0)    --uncomment for advanced pong
);
end PONG_BASYS3;

architecture PONG_BASYS3_ARCH of PONG_BASYS3 is

component CLOCK     --Incharge of creating the clckTick signal for a 10Hz game play speed
Port(
    reset: in std_logic;
    clock: in std_logic;
    clckTick: out std_logic
);
end component;

component INPUT_SYNC
  Port ( 
    reset: in std_logic;
    clock: in std_logic;
    aSyncIn: in std_logic;
    syncOut: out std_logic
  );
end component;

component CHEAT_MANAGER
Port(
    input: in std_logic;
    clock: in std_logic;
    reset: in std_logic;
    
    btnPress: out std_logic
);
end component;
 
component RESET_SYNC
    Port(
        reset: in std_logic;
        clock: in std_logic;
        synchedReset: out std_logic
    );
end component;

component LED_DISPLAY
    Port(
        pos:   in std_logic_vector(3 downto 0);
        clock: in std_logic;
        reset: in std_logic;
        
        leds: out std_logic_vector(15 downto 0)
    );
end component;

component SCORE_TRACKER
    Port(
        scoreSigP1: in std_logic;
        scoreSigP2: in std_logic;
        
        reset:    in std_logic;
        clock:    in std_logic;
        
        gameOver: out std_logic;
        score: out std_logic_vector(5 downto 0)
    );
end component;

component STATE_MANAGER --Handles all the State changes and input synchronizations needed for the game
    Port(
        p1Btn: in std_logic;
        p2Btn: in std_logic;
        
        reset:    in std_logic;
        clock:    in std_logic;
        clckTick: in std_logic;
        
        ballPos:    out std_logic_vector(3 downto 0);
        scoreSigP1: out std_logic;
        scoreSigP2: out std_logic
        
    );
end component;

component SEG7_DISPLAY --Takes care of displaying the player's score's on the 7seg
Port(
    reset: in std_logic;
    clock: in std_logic;
    
    score: in std_logic_vector(5 downto 0);
    
    anodes: out std_logic_vector(3 downto 0);
    seg7  : out std_logic_vector(6 downto 0)
);
end component;

 signal clckTick : std_logic;
 signal score    : std_logic_vector(5 downto 0);  --uncomment for advanced pong
 signal synchedReset: std_logic;
 
 signal p1Btn: std_logic;
 signal p2Btn: std_logic;
 signal gameOver: std_logic;
 signal specialReset: std_logic;

 signal scoreSigP1: std_logic;
 signal scoreSigP2: std_logic;
 signal ballPos: std_logic_vector(3 downto 0);
 
 signal p1Btn_cm: std_logic;
 signal p2Btn_cm: std_logic;
 
begin
------BLOCK G-----------
CLCK_BLOCK: CLOCK port map(
    reset => btnC,
    clock => clk,
    clckTick => clckTick
);

----BLOCK A--------------------------------------
--*Handles synching the reset btn to the clock
RESET_SYNC_BLOCK: RESET_SYNC port map(
    reset => btnC,
    clock => clk,
    synchedReset => synchedReset
);

    
----BLOCK B SYNC_CHAIN --------------------------------------
--*Handles synching player 1's btn to the clock
SYNC_BLOCK_P1: INPUT_SYNC port map(
    reset => synchedReset,
    clock => clk,
    aSyncIn => btnL,
    syncOut => p1Btn
);
    
----BLOCK B SYNC_CHAIN --------------------------------------
--*Handles synching player 2's btn to the clock
SYNC_BLOCK_P2: INPUT_SYNC port map(
    reset => synchedReset,
    clock => clk,
    aSyncIn => btnR,
    syncOut => p2Btn
);

CM_BLOCK_P1: CHEAT_MANAGER port map(
    input => p1Btn,
    clock => clk,
    reset => synchedReset,
    btnPress => p1Btn_cm
    
);

CM_BLOCK_P2: CHEAT_MANAGER port map(
    input => p2Btn,
    clock => clk,
    reset => synchedReset,
    btnPress => p2Btn_cm
    
);

----BLOCK Y LED_DISPLAY_BLOCK --------------------------------------
LED_DISPLAY_BLOCK: LED_DISPLAY port map(
    pos => ballPos,
    clock => clk, --changed
    reset => synchedReset,
    
    leds => led
);

specialReset <= synchedReset or gameOver;

----BLOCK Z LED_DISPLAY_BLOCK --------------------------------------
SCORE_TRACKER_Block: SCORE_TRACKER port map(
    scoreSigP1 => scoreSigP1,
    scoreSigP2 => scoreSigP2,
    
    reset => specialReset,
    clock => clk,
    
    gameOver => gameOver,
    score => score
);

-----BLOCK C------------
SM_BLOCK: STATE_MANAGER port map(
    p1Btn => p1Btn_cm,
    p2Btn => p2Btn_cm, 
     
    reset => specialReset,
    clock => clk,
    clckTick => clckTick,
    
    ballPos => ballPos,
    scoreSigP1 => scoreSigP1,
    scoreSigP2 => scoreSigP2
--    syncReset => syncReset,  --uncomment for advanced pong
--    score => score,          --uncomment for advanced pong
--    led => led
);

-------BLOCK H------------
SCORE_DISPLAY: SEG7_DISPLAY port map(
    reset => synchedReset,
    clock => clk,
    
    score => score,
    
    anodes => an,
    seg7   => seg
);

end PONG_BASYS3_ARCH;
