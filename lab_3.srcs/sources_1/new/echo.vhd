----------------------------------------------------------------------------------
-- Company: 
-- Engineer: 

library ieee;
use ieee.std_logic_1164.all;

entity echo is
    port (
    clk,en,rdy,newChar : in std_logic;
    charIn : in std_logic_vector (7 downto 0);
    send : out std_logic;
    charOut : out std_logic_vector (7 downto 0) 
);
end echo;

architecture Behavioral of echo is

type state is (idle, busyA, busyB, busyC);
signal curr : state := idle;

begin
    process(clk) begin
            if (rising_edge(clk)) then
                if (en = '1') then
                case curr is
                    when idle =>
                        if (newChar = '1') then
                            send <= '1';
                            charOut <= charIn;
                            curr <= busyA;
                        end if;
                        
                    when busyA =>
                        curr <= busyB;
                        
                    when busyB =>
                        send <= '0';
                        curr <= busyC;
                        
                    when busyC =>
                        if (rdy = '1') then
                            curr <= idle;
                        end if;
                        
                    when others =>
                end case;
                end if;
            end if;
    end process;


end Behavioral;
