library IEEE;
use IEEE.STD_LOGIC_1164.ALL;
use IEEE.NUMERIC_STD.ALL;

--******************************************************************************
--*
--* Name: SCORE_TRACKER
--* Designer: Matthew Mwangi
--*
--*     This is component is in charge of tracking the Player's score though out  
--*     the gameplay by recieving a score signal the actual score gets updated 
--*     by one and is sent out to the seg7 component to handle its display.
--*     When score reaches 5 a gameOver signal is sent out to reset the game.
--******************************************************************************


entity SCORE_TRACKER is
  Port ( 
        scoreSigP1: in std_logic;   --signal recieved to notify us that player 1 scored
        scoreSigP2: in std_logic;   --signal recieved to notify us that player 2 scored
        
        reset:  in std_logic;
        clock:  in std_logic;
        
        gameOver:    out std_logic; --signal sent to signify the end of a round 
        score:       out std_logic_vector(5 downto 0) --keeps track of the player's scores
  );
end SCORE_TRACKER;

architecture SCORE_TRACKER_ARCH of SCORE_TRACKER is
    constant ACTIVE: std_logic := '1';
begin

UPDATE: process(reset, clock, scoreSigP1, scoreSigP2)
    variable scoreCountP1: integer range 0 to 5;
    variable scoreCountP2: integer range 0 to 5;
    variable gameOverChain:    std_logic_vector(1 downto 0);
begin
    if reset = ACTIVE then
        scoreCountP1 := 0;  --reset player 1 score to 0
        scoreCountP2 := 0;  --reset player 2 score to 0
        gameOverChain := (others=>'0'); --reset gameOver signal to 0
    elsif rising_edge(clock) then
        gameOverChain := gameOverChain(0) & not ACTIVE; --set gameOver to a recurring low on every rising clock edge
        if scoreSigP1 = ACTIVE then
            if scoreCountP1 < 4 then
                scoreCountP1 := scoreCountP1 + 1; --add to player 1 score
            else
                gameOverChain := ACTIVE & gameOverChain(0); --set gameOver to active
            end if;
        elsif scoreSigP2 = ACTIVE then
            if scoreCountP2 < 4 then
                scoreCountP2 := scoreCountP2 + 1;   --add to player 2 score
            else
                gameOverChain := ACTIVE & gameOverChain(0); --set gameOver to active
            end if;
        end if;
    end if;
    gameOver <= gameOverChain(1);   --Update the gameOver Signal
    score(5 downto 3) <= std_logic_vector(to_unsigned(scoreCountP1, score'length/2)); --store player 1 score in upper 3 bits
    score(2 downto 0) <= std_logic_vector(to_unsigned(scoreCountP2, score'length/2)); --store player 2 score in lower 3 bits
end process UPDATE;
end SCORE_TRACKER_ARCH;
