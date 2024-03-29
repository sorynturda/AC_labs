library IEEE;
use IEEE.STD_LOGIC_1164.ALL;
use IEEE.STD_LOGIC_UNSIGNED.ALL;


entity IFetch is
    Port ( address : in STD_LOGIC_VECTOR (4 downto 0);
           instrucion : out STD_LOGIC_VECTOR (31 downto 0));
end IFetch;

architecture Behavioral of IFetch is

type rom is array(0 to 4) of STD_LOGIC_VECTOR(31 downto 0);
signal mem : rom := (
    B"000000_00000_00001_00100_00000_000001", -- add
    B"000000_00000_00001_00010_00000_000010", -- sub
    B"000000_00000_00000_10000_00010_000000", -- sll 2 bits
    B"000000_00000_00000_10000_00010_000011", -- srl 2 bits
    B"000000_00011_00010_11000_00000_100000", -- and
    B"000000_00000_00001_01100_00000_010000", -- or
    B"000000_01000_10000_01100_00000_001000", -- slt
    B"000000_01000_10000_00110_00000_000100", -- xor
    
    B"100000_00000_00100_0000000000000001", -- addi 1
    others => X"00000000"
);

begin


end Behavioral;
