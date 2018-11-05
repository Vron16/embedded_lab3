library IEEE;
use IEEE.std_logic_1164.all;
use ieee.numeric_std.all;

entity echo_tb is
--  Port ( );
end echo_tb;

architecture Behavioral of echo_tb is

component echo     
    port (
        clk,en,rdy,newChar : in std_logic;
        charIn : in std_logic_vector (7 downto 0);
        send : out std_logic;
        charOut : out std_logic_vector (7 downto 0) 
    );
    end component;

    type str is array (0 to 4) of std_logic_vector(7 downto 0);
    signal word : str := (x"48", x"65", x"6C", x"6C", x"6F");

    signal clk, en, send, rdy, newChar : std_logic := '0';
    signal charIn, charOut : std_logic_vector(7 downto 0) := (others => '0');

begin

    -- the sender UART
    dut: echo port map(
        clk => clk,
        en => en,
        send => send,
        charIn => charIn,
        rdy => rdy,
        newChar => newChar,
        charOut => charOut);


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


        for index in 0 to 4 loop
            rdy <= '1';
            wait until en = '1';
            newChar <= '1';
            charIn <= word(index);
            rdy <= '0';
            wait for 200 ns;
            newChar <= '0';
            charIn <= (others => '0');
            rdy <= '1';
            wait until send = '0' and en = '1';
            wait until en = '1';

            if charOut /= word(index) then
                report "Send/Receive MISMATCH at time: " & time'image(now) &
                lf & "expected: " &
                integer'image(to_integer(unsigned(word(index)))) &
                lf & "received: " & integer'image(to_integer(unsigned(charOut)))
                severity ERROR;
            end if;

        end loop;

        wait for 1000 ns;
        report "End of testbench" severity FAILURE;

    end process;


end Behavioral;
