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

architecture fsm of uart_tx is

type state is (idle, start, transmit, stop);
signal currstate : state := idle;
signal count : std_logic_vector(2 downto 0) := (others => '0');
signal chars : std_logic_vector(7 downto 0) := (others => '0');

signal ready_sig, tx_sig : std_logic := '1';

begin

    ready <= ready_sig;
    tx <= tx_sig;
    
    process(clk) begin
        if (rising_edge(clk)) then
            if (rst = '1') then
                currstate <= idle;
                count <= (others => '0');
                chars <= (others => '0');
            elsif en = '1' then
                case currstate is 
                    when idle =>
                        if (send = '1') then
                            chars <= char;
                            currstate <= start;
                        end if;
                        
                    when start =>
                        tx_sig <= '0';
                        ready_sig <= '0';
                        currstate <= transmit;
                    
                    when transmit =>
                        if (unsigned(count) < 7) then
                            tx_sig <= chars(to_integer(unsigned(count)));
                            count <= std_logic_vector(unsigned(count) + 1);
                        else 
                            tx_sig <= chars(to_integer(unsigned(count)));
                            currstate <= stop;
                        end if;
              
                    when stop =>
                        tx_sig <= '1';
                        ready_sig <= '1';
                        count <= (others => '0');
                        chars <= (others => '0');
                        currstate <= idle;
                        
                    when others =>
                        currstate <= idle;
                end case;
            end if;
        end if;
   end process;
   
end fsm;
