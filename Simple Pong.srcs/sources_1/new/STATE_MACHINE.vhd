library IEEE;
use IEEE.STD_LOGIC_1164.ALL;
use IEEE.NUMERIC_STD.ALL;

--******************************************************************************
--*
--* Name: STATE_MANAGER
--* Designer: Matthew Mwangi
--*
--*     This component handles three tasks. First, it manages the synchronization of the 
--*     reset, player 1 and 2's buttons through the use of the imported INPUT_SYNC and  
--*     RESET SYNC components. Second it manages the different game states and their  
--*     corresponding transitions. Third, it takes care of displaying the ball's position 
--*     through the use of the leds marked as output.
--*     
--*     Once the button inputs are synchronized the STATE_MANAGER process is tasked with
--*     performing a number of actions depending on the game's currentState. The possible
--*     game states are PLAYER_ONE, MOVE_BALL and PLAYER_TWO, the PLAYER_ONE STATE serves
--*     as the beggining game state on reset or start of the game. When p1BtnSync is ACTIVE
--*     when in PLAYER_ONE game state a transition is made to MOVE_BALL state where the
--*     ball movement is handled. This is done by having a count variable the starts at 15
--*     (player 1's side) and counts down to 0 (player 2's side) through the use of a
--*     direction variable that as the name suggest dictates the ball's move direction. Once
--*     the count variable counts down to 0 the state changes to PLAYER_TWO where player 2
--*     gets a chance to shoot the ball through the p2BtnSync input. If the ball is shot then
--*     the state changes back to MOVE_BALL where the opposite of what happened earlier 
--*     (count variable counts up to 15) occurs and Once 15 is reached the state swutches to
--*      the PLAYER_ONE state. The ball's positions is shown to the players through the leds.
--*
--*     When either player 1 or player 2 miss to take the shot at their turn then the player 
--*     that took the shot last gets a point which gets stored in the score signal(5 downto
--*     0) where the upper 3 bits is the player 1's score and lower 3 bits is Player 2's
--*     score. That player also gets tonext.
--******************************************************************************

entity STATE_MANAGER is
Port(
    p1Btn:   in std_logic;       --player 1 (left btn)
    p2Btn:   in std_logic;       --player 2 (right btn)
    
    reset:    in std_logic;        --reset the game (center btn)
    clock:    in std_logic;        --system clock
    clckTick: in std_logic;     --A pulse at 10HZ that serves as the LEDs clock
    
    ballPos:    out std_logic_vector(3 downto 0); -- ball's current position
    scoreSigP1: out std_logic;  --signal sent when player 1 score
    scoreSigP2: out std_logic   --signal sent when player 2 score
);
end STATE_MANAGER;


architecture STATE_MANAGER_ARCH of STATE_MANAGER is
    
    constant BLANK_LEDS: std_logic_vector(15 downto 0) := "0000000000000000";       --Sets all LEDs to LOW 
    
    constant ACTIVE: std_logic := '1';
    
    type States_t is (PLAYER_ONE, MOVE_BALL, PLAYER_TWO);   --Possible Game Loop States
    signal currentState: States_t;                          --Keeps track of the Current Game Loop State
    signal scrUpdate: std_logic;
    
    signal scrOnP1: std_logic_vector(1 downto 0);           --goes active when player 1 got scored on
    signal scrOnP2: std_logic_vector(1 downto 0);           --goes active when player 2 got scored on
    
    signal pos: integer range 0 to 15;                      --Keeps track of the led position
    
begin

---------------------------------------------------------------------------------------
------------------------------------------ BLOCK C ------------------------------------
--* STATE_MANAGER handles the logic behind the three gameloop states
--* (PLAYER_ONE, MOVE_BALL, PLAYER_TWO) and updates the pos signal appropraitely.
---------------------------------------------------------------------------------------
STATE_MANAGER: process(reset, clock, clckTick)
    variable direction: integer range -1 to 1;  --Serves as the ball direction indicator when 
                                --When direction = -1 then ball position goes from player 1 downto player 2
                                --When direction = 0 then stall at currentState
                                --When direction = 1 then ball position goes from player 2 to player 1                                        
    variable count: integer range 0 to 15 ;     --Ball's Position
    
begin
    
if reset = ACTIVE then    --Detect any ACTIVE reset or gameOver signals
        currentState <= PLAYER_ONE;          --Sets the begin State to PLAYER_ONE
        scrUpdate <= not ACTIVE;
        scrOnP1 <= (others=>'0');
        scrOnP2 <= (others=>'0');
        direction := 0;                      --Set direction to zero
elsif rising_edge(clock) then
    scrOnP1 <= scrOnP1(0) & not ACTIVE; --set scrOnP1 to a recurring low on every rising clock edge
    scrOnP2 <= scrOnP2(0) & not ACTIVE; --set scrOnP2 to a recurring low on every rising clock edge
    case currentState is
        --------BUBBLE D: PLAYER_ONE------------------------------------------------------------------------------------
        when PLAYER_ONE =>
             count := 15;                           -- Set ball pos to player one
             if(p1Btn = ACTIVE) then            --Check if Player 1 has hit the ball
                  direction := -1;                  --updates the ball's move direction to Player 2
                  currentState <= MOVE_BALL;        --State change to MOVE_BALL
             else
                  if clckTick = ACTIVE and direction = 1 then  --missed shot -. send to Player 2 to start the game
                    direction := 0;  --Stall Indicator     
                      scrOnP1 <= ACTIVE & scrOnP1(0);          --set scrOnP1 to active
                    currentState <= PLAYER_TWO;                --Player 1 gives up its turn to serve to player 2
                  else 
                    currentState <= PLAYER_ONE; --Stalls at PLAYER_ONE when no state transition requirement is met
                  end if;
             end if;
        
        ------------------------------- BUBBLE E: MOVE_BALL -----------------------------------------------------------                         
        when MOVE_BALL  =>
            if((count = 15) and (direction > 0)) then      --Check whether the ball has reached player 1's side
                  currentState <= PLAYER_ONE;               --if so change currentState to PLAYER_ONE
            elsif ((count = 0) and (direction < 0)) then    --Check whether the ball has reached player 2's side
                  currentState <= PLAYER_TWO;               --if so change currentState to PLAYER_TWO
            elsif clckTick = ACTIVE then               --Updates ball's position only on the clckTick pulse 
                count := count + direction; --update's the position with respect to the direction set
            else
                  currentState <= MOVE_BALL;                    --Keeps updating ball position otherwise
            end if;
            
        -------------------------------------BUBBLE F: PLAYER_TWO-------------------------------------------------------            
        when PLAYER_TWO =>
            count := 0;                         --Sets the ball position to player 1
--            ballPos <= std_logic_vector(to_unsigned(count, ballPos'length));
            if(p2Btn = ACTIVE) then         --Checks if player 2 hits the ball
                  direction := 1;               --Updates the ball's move direction back to Player 1
                  currentState <= MOVE_BALL;    --State change to MOVE_BALL
            else
                if direction /= 0 then                  --Checks the ball's incoming direction
                      if clckTIck = ACTIVE then         --missed shot -. send to Player 1 to start the game
                        currentState <= PLAYER_ONE;
                          scrOnP2 <= ACTIVE & scrOnP2(0);   --set scrOnP2 to active
                      end if;
                else  
                   currentState <= PLAYER_TWO;          --Stall at current state (happens when direction = 0)  
                end if;
            end if;
    end case;
    
    scoreSigP1 <= scrOnP2(1);   --activates only for 1 clock cycle when scoreSigP1 when player 1 scores 
    scoreSigP2 <= scrOnP1(1);   --activates only for 1 clock cycle when scoreSigP2 when player 2 scores 
    ballPos <= std_logic_vector(to_unsigned(count, ballPos'length));    --store ball's position
end if;
end process STATE_MANAGER;

end STATE_MANAGER_ARCH;
