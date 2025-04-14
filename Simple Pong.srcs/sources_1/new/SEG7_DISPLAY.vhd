library IEEE;
use IEEE.STD_LOGIC_1164.ALL;
use IEEE.NUMERIC_STD.ALL;


entity SEG7_DISPLAY is
Port(
    reset: in std_logic;
    clock: in std_logic;
    
    score: in std_logic_vector(5 downto 0);
    
    anodes: out std_logic_vector(3 downto 0);
    seg7:  out std_logic_vector(6 downto 0)
);
end SEG7_DISPLAY;

architecture SEG7_DISPLAY_ARCH of SEG7_DISPLAY is
  
    constant ACTIVE:  std_logic := '1';
    constant DEFAULT: integer   :=  0;  
    constant COUNT_1KHZ: integer := (100000000/1000)-1;

    constant SEG7_ZERO:     std_logic_vector(6 downto 0) := "1000000";
    constant SEG7_ONE:      std_logic_vector(6 downto 0) := "1111001";
    constant SEG7_TWO:      std_logic_vector(6 downto 0) := "0100100";
    constant SEG7_THREE:    std_logic_vector(6 downto 0) := "0110000";
    constant SEG7_FOUR:     std_logic_vector(6 downto 0) := "0011001";
    constant SEG7_FIVE:     std_logic_vector(6 downto 0) := "0010010";
    constant SEG7_BLANK:    std_logic_vector(6 downto 0) := "1111111";
    
    
    constant SELECT_DIGIT_0: std_logic_vector(3 downto 0)  := "1110";
    constant SELECT_DIGIT_3: std_logic_vector(3 downto 0)  := "0111";
    constant SELECT_NO_DIGIT: std_logic_vector(3 downto 0) := "1111";
    
    
    signal selectedDigit: integer range 0 to 5;
    signal p1_score:      integer range 0 to 5;
    signal p2_score:      integer range 0 to 5;
    signal enableCount:   std_logic;
    signal digitSelect:   unsigned(1 downto 0);
    
    
begin
    p1_score <= to_integer(unsigned(score(5 downto 3)));
    p2_score <= to_integer(unsigned(score(2 downto 0)));
    
    BINARY_TO_SEG7: seg7 <=   SEG7_ZERO  when selectedDigit = 0 else
                              SEG7_ONE   when selectedDigit = 1 else
                              SEG7_TWO   when selectedDigit = 2 else
                              SEG7_THREE when selectedDigit = 3 else
                              SEG7_FOUR  when selectedDigit = 4 else
                              SEG7_FIVE  when selectedDigit = 5 else
                              SEG7_BLANK;
    
    DIGIT_SELECT: with digitSelect select
                       selectedDigit <= p2_score when "00",
                                        p1_score when "11",
                                        DEFAULT when others;  
    
    ANODE_SELECT: process(digitSelect)
    begin
        case digitSelect is
            when "00" =>    anodes <= SELECT_DIGIT_0;
            when "11" =>    anodes <= SELECT_DIGIT_3;
            when others =>  anodes <= SELECT_NO_DIGIT;
        end case;
    end process ANODE_SELECT;
    
    
   SCAN_RATE: process(reset, clock)
        variable count: integer range 0 to COUNT_1KHZ;
   begin
        if reset = ACTIVE then
            count := 0;
        elsif rising_edge(clock) then
            if count >= COUNT_1KHZ then
                count := 0;
            else
                count := count + 1;
            end if;
        end if;
        
        enableCount <= not ACTIVE;
        if count = COUNT_1KHZ then
            enableCount <= ACTIVE;
        end if;
   end process SCAN_RATE; 
   
   DIGIT_COUNT:process(reset, clock)
   begin
        if reset = ACTIVE then
            digitSelect <= "00";
        elsif rising_edge(clock) then
            if enableCount = ACTIVE then
                digitSelect <= digitSelect + 1;
            end if; 
        end if;
   end process DIGIT_COUNT;

end SEG7_DISPLAY_ARCH;
