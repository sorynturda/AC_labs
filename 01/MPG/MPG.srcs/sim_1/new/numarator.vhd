library IEEE;
use IEEE.STD_LOGIC_1164.ALL;
use ieee.std_logic_unsigned.all;

entity numarator is
    Port ( clk : in STD_LOGIC;
           cnt : out STD_LOGIC_VECTOR(3 downto 0)
    );
end numarator;

architecture Behavioral of numarator is
signal counter: STD_LOGIC_VECTOR(3 downto 0) := (others => '0');

begin
process (clk)
begin
    if rising_edge(clk) then
        counter <= counter + '1';
    end if;
end process;
cnt <= counter;
end Behavioral;
