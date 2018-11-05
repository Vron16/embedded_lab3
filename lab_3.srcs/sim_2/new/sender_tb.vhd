library IEEE;
use IEEE.std_logic_1164.all;
use ieee.numeric_std.all;

entity sender_tb is
-- Port();
end sender_tb;

architecture Behavioral of sender_tb is

component sender
    port (
        rst,clk,en,btn,rdy : in std_logic;
        send : out std_logic;
        char : out std_logic_vector (7 downto 0)
    );
end component;

begin
   
    --mapping testbench to sender component
    dut : sender port map (
        clk => clk,
        en => en,
        rst => rst,
        btn => btn,
        rdy => rdy,
        send => send,
        char => char
    );
    
    -- clock process @125 MHz
    process begin
        clk <= '0';
        wait for 4 ns;
        clk <= '1';
        wait for 4 ns;
    end process;

    -- en process @ 125 MHz / 1085 = ~115200 Hz
    process begin
        en <= '0';
        wait for 8680 ns;
        en <= '1';
        wait for 8 ns;
    end process;  
    
    -- signal stimulation process
    process begin 
        for index in 0 to 5 loop
            rdy <= '1';
            btn <= '1';
            wait until en = '1';
            rdy <= '0';
            btn <= '0';
            wait for 200 ns; --delay to substitute time needed for the uart in the actual design to transmit the char output
            wait until clk = '1'; -- uart updates on rising edge of clk
            rdy <= '1'; -- simulating uart is done
        end loop;
    end processs;
end Behavioral;
            
