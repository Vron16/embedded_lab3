----------------------------------------------------------------------------------
-- Company: 
-- Engineer: 
-- 
-- Create Date: 10/31/2018 09:14:59 PM
-- Design Name: 
-- Module Name: uart_tx - Behavioral
-- Project Name: 
-- Target Devices: 
-- Tool Versions: 
-- Description: 
-- 
-- Dependencies: 
-- 
-- Revision:
-- Revision 0.01 - File Created
-- Additional Comments:
-- 
----------------------------------------------------------------------------------


library IEEE;
use IEEE.STD_LOGIC_1164.ALL;
use ieee.numeric_std.all;



entity uart_tx is
    port (
        clk, en, send, rst :  in  std_logic;
        char  : in  std_logic_vector(7 downto 0);
        ready, tx : out std_logic 
    );
end uart_tx;

architecture Behavioral of uart_tx is

type state is (idle, start, transmit, stop);
signal currstate : state := idle;
signal count : std_logic_vector(2 downto 0) := (others => '0');
signal chars : std_logic_vector(7 downto 0) := (others => '0');

begin

    process(clk) begin
        if (rising_edge(clk)) then
            if (rst = '1') then
                currstate <= idle;
                count <= (others => '0');
                chars <= (others => '0');
            else
                case currstate is 
                    when idle =>
                        if (send = '1' and en = '1') then
                            currstate <= start;
                        else
                            ready <= '1';
                            tx <= '1';
                        end if;
                        
                    when start =>
                        tx <= '0';
                        ready <= '1';
                        chars <= char;
                        currstate <= transmit;
                    
                    when transmit =>
                        if (unsigned(count) < 7) then
                            tx <= chars(to_integer(unsigned(count)));
                            ready <= '0';
                            count <= std_logic_vector(unsigned(count) + 1);
                        elsif (unsigned(count) = 7) then
                            currstate <= stop;
                            ready <= '0';
                        end if;
              
                    when stop =>
                        tx <= '1';
                        ready <= '0';
                        count <= (others => '0');
                        chars <= (others => '0');
                        currstate <= idle;
                        
                    when others =>
                        currstate <= idle;
                end case;
            end if;
        end if;
   end process;
   
end Behavioral;
