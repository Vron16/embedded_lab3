----------------------------------------------------------------------------------
-- Company: 
-- Engineer: 

library ieee;
use ieee.std_logic_1164.all;

entity design_top is
port(
    clk, TXD : in std_logic;
    btn : in std_logic_vector(1 downto 0);
    RXD, CTS, RTS : out std_logic
);
end design_top;


architecture behavioral of design_top is

    signal dbnce : std_logic_vector(1 downto 0) := (others => '0');
    signal char : std_logic_vector(7 downto 0) := (others => '0');
    signal ready, div, send : std_logic := '0';

    component clock_div is
        port(   
            clk  : in std_logic;        -- 125 Mhz clock
            div : out std_logic        -- led, '1' = on 
    );
    end component;
    
    component debounce is
        port(
            clk  : in std_logic;        -- 125 Mhz clock
            btn  : in std_logic;        -- 125 Mhz clock
            dbnc : out std_logic       
     );
     end component;
     
     component uart is
        port (
         clk, en, send, rx, rst      : in std_logic;
         charSend                    : in std_logic_vector (7 downto 0);
         ready, tx, newChar          : out std_logic;
         charRec                     : out std_logic_vector (7 downto 0)
     
     );
     end component;
     
     component sender is
        port (
         rst,clk,en,btn,rdy : in std_logic;
         send : out std_logic;
         char : out std_logic_vector (7 downto 0) 
     );
     end component;

begin

    CTS <= '0';
    RTS <= '0';

    u1 : debounce
    port map (
        btn => btn(0),
        clk => clk,
        dbnc => dbnce(0)
    );
    
    u2 : debounce
    port map (
        btn => btn(1),
        clk => clk,
        dbnc => dbnce(1)
    );
    
    u3 : clock_div
    port map (
        clk => clk,
        div => div
    );
    
    u4 : sender
    port map (
        btn => dbnce(1),
        clk => clk,
        en => div,
        rdy => ready,
        rst => dbnce(0),
        char => char,
        send => send
    );
    
    u5 : uart
    port map (
        charSend => char,
        clk => clk,
        en => div,
        rst => dbnce(0),
        rx => TXD,
        send => send,
        ready => ready,
        tx => RXD
    );

end behavioral;
