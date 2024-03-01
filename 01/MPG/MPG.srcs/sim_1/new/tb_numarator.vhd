library IEEE;
use IEEE.STD_LOGIC_1164.ALL;
use ieee.std_logic_unsigned.all;

entity tb_numarator is
--  Port ( );
end tb_numarator;

architecture Behavioral of tb_numarator is

component numarator is
    Port ( clk : in STD_LOGIC;
           cnt : out std_logic_vector(3 downto 0));
end component;

signal clk_test:std_logic;
signal cnt_test:std_logic_vector(3 downto 0);
constant perioada: TIME := 20ns;

begin

ust1: numarator port map (clk_test,cnt_test);

process
begin
    clk_test <= '0';
    wait for perioada/2;
    clk_test <= '1';
    wait for perioada/2;
end process;

--process
--begin
--    reset_test <= '1';
--    wait for perioada;
--    reset_test <= '0';
--    wait; --asteapta pana la sfarsitul simularii
--end process

end Behavioral;
