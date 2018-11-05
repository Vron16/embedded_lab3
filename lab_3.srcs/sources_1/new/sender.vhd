----------------------------------------------------------------------------------
-- Company: 
-- Engineer: 

library ieee;
use ieee.std_logic_1164.all;
use ieee.numeric_std.all;

entity sender is
    port (
    rst,clk,en,btn,rdy : in std_logic;
    send : out std_logic;
    char : out std_logic_vector (7 downto 0) 
);
end sender;

architecture Behavioral of sender is

type state is (idle, busyA, busyB, busyC);
type vectorArray is array (0 to 4) of std_logic_vector (7 downto 0);

signal NETID : vectorArray := (std_logic_vector(to_unsigned(118, 8)), std_logic_vector(to_unsigned(114, 8)), std_logic_vector(to_unsigned(50, 8)), std_logic_vector(to_unsigned(53, 8)), std_logic_vector(to_unsigned(48, 8)));
signal send_sig : std_logic := '0';
signal char_sig : std_logic_vector(7 downto 0) := (others => '0');
signal i : std_logic_vector(7 downto 0) := (others => '0');
signal currSt : state := idle;


begin
    send <= send_sig;
    char <= char_sig;
    process (clk) begin
        if (rising_edge(clk)) then
            if (rst = '1') then
                i <= (others => '0');
                send_sig <= '0';
                char_sig <= (others => '0');
                currSt <= idle;
            elsif (en = '1') then
                case currSt is
                    when idle =>
                        if (rdy = '1' and btn = '1' and unsigned(i) < 5) then
                            send_sig <= '1';
                            char_sig <= NETID(to_integer(unsigned(i)));
                            i <= std_logic_vector(unsigned(i) + 1);
                            currSt <= busyA;
                        elsif (rdy = '1' and btn = '1' and unsigned(i) = 5) then
                            i <= (others => '0');
                        end if;
                    
                    when busyA =>
                        currSt <= busyB;
                    
                    when busyB =>
                        send_sig <= '0';
                        currSt <= busyC;
                    
                    when busyC =>
                        if (rdy = '0' and btn = '1') then
                            currSt <= idle;
                        end if;
                    
                    when others =>
                        currSt <= idle;
                 end case;
            end if;
            
        end if;
    end process;
            
            

end Behavioral;
