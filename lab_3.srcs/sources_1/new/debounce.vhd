--filename: debounce.vhd
--description: lab1 to divide 125 MHz clock down to 2Hz
--
------------------------------------------------------------------------------
library ieee;
    use ieee.std_logic_1164.all;
    use ieee.numeric_std.all;

entity debounce is
    port(

        clk  : in std_logic;        -- 125 Mhz clock
        btn  : in std_logic;        -- button
        dbnc : out std_logic        -- output btn stable

    );
end debounce;

architecture behavior of debounce is

    signal counter : std_logic_vector(22 downto 0) := ((others => '0'));
    signal shiftReg : std_logic_vector(1 downto 0) := ((others => '0'));

begin

    process(clk, btn)
    begin
    -- takes as input a 125 MHz clock signal and divides it down to 2 Hz. Utilize a looping testbench to drive 125 million clock cycles on the input of the module and verify that the output produces two full clock cycles
    if (rising_edge(clk)) then
        shiftReg(1) <= shiftReg(0);
        shiftReg(0) <= btn;
        if (shiftReg(1) = '1') and (unsigned(counter) < 2500000) then
            counter <= std_logic_vector(unsigned(counter) + 1);
        elsif (shiftReg(1) = '0') then
            counter <= ((others => '0'));
        end if;
        if (unsigned(counter) = 2500000) then
            dbnc <= '1';
        else
            dbnc <= '0';
        end if;
    end if;
           
    end process;
    
end behavior;