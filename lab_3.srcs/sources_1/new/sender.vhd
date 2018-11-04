----------------------------------------------------------------------------------
-- Company: 
-- Engineer: 

library ieee;
use ieee.std_logic_1164.all;

entity sender is
    port (
    rst,clk,en,btn,rdy : in std_logic;
    send : out std_logic;
    char : out std_logic_vector (7 downto 0) 
);
end sender;

architecture Behavioral of sender is

begin


end Behavioral;
