--filename: clock_div.vhd
--description: lab1 to divide 125 MHz clock down to 2Hz
--
------------------------------------------------------------------------------
library ieee;
    use ieee.std_logic_1164.all;
    use ieee.numeric_std.all;

entity clock_div is
    port(

        clk  : in std_logic;        -- 125 Mhz clock
        div : out std_logic        -- output 2Hz clock

    );
end clock_div;

architecture behavior of clock_div is

    signal counter : std_logic_vector(26 downto 0) := (others => '0');

begin

    process(clk)
    begin
    -- takes as input a 125 MHz clock signal and divides it down to 2 Hz. Utilize a looping testbench to drive 125 million clock cycles on the input of the module and verify that the output produces two full clock cycles
    if (rising_edge(clk)) then
        if (unsigned(counter) = 62500000) then
            div <= '1';
            counter <= ((others => '0'));
        else
            counter <= std_logic_vector(unsigned(counter) + 1);
            div <= '0';
        end if;
    end if;
           
    end process;
    
end behavior;