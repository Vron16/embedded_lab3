----------------------------------------------------------------------------------
-- Company: 
-- Engineer: 

library ieee;
use ieee.std_logic_1164.all;

entity design_top_ec is
port(
    clk, TXD : in std_logic;
    btn : in std_logic;
    RXD, CTS, RTS : out std_logic
);
end design_top_ec;


architecture behavioral of design_top_ec is

    signal dbnce, newChar, ready, div, send : std_logic := '0';
    signal charRec, charSend : std_logic_vector(7 downto 0) := (others => '0');

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
     
     component echo is
    port (
     clk,en,rdy,newChar : in std_logic;
     charIn : in std_logic_vector (7 downto 0);
     send : out std_logic := '0';
     charOut : out std_logic_vector (7 downto 0) 
 );
     end component;

begin

    CTS <= '0';
    RTS <= '0';

    u1 : debounce
    port map (
        btn => btn,
        clk => clk,
        dbnc => dbnce
    );

    u3 : clock_div
    port map (
        clk => clk,
        div => div
    );
    
    u4 : echo
    port map (
        clk => clk,
        en => div,
        rdy => ready,
        charIn => charRec,
        charOut => charSend,
        newChar => newChar,
        send => send
    );
    
    u5 : uart
    port map (
        charSend => charSend,
        clk => clk,
        en => div,
        rst => dbnce,
        rx => TXD,
        send => send,
        ready => ready,
        tx => RXD,
        charRec => charRec,
        newChar => newChar
    );

end behavioral;
