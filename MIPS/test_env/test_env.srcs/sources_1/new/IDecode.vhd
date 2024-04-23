library IEEE;
use IEEE.STD_LOGIC_1164.ALL;
use IEEE.STD_LOGIC_UNSIGNED.ALL;

entity IDecode is
    Port ( clk : in STD_LOGIC;
           reg_write : in STD_LOGIC;
           reg_dst : in STD_LOGIC;
           wd : in STD_LOGIC_VECTOR (31 downto 0);
           en : in STD_LOGIC;
           ext_op : in STD_LOGIC;
           instruction : in STD_LOGIC_VECTOR (25 downto 0);
           rd1 : out STD_LOGIC_VECTOR (31 downto 0);
           rd2 : out STD_LOGIC_VECTOR (31 downto 0);
           ext_imm : out STD_LOGIC_VECTOR (31 downto 0);
           func : out STD_LOGIC_VECTOR (5 downto 0);
           sa : out STD_LOGIC_VECTOR (4 downto 0));
end IDecode;

architecture Behavioral of IDecode is

type reg_array is array (0 to 31) of STD_LOGIC_VECTOR(31 downto 0);
signal RF : reg_array := (
    others => X"00000000");
signal write_addr : STD_LOGIC_VECTOR(4 downto 0);

begin
   
    process(clk)
    begin
        if rising_edge(clk) then
            if en = '1' and reg_write = '1' then    
                RF(conv_integer(write_addr)) <= wd;
            end if;
        end if;
    end process;

write_addr <= instruction(15 downto 11) when reg_dst = '1' else instruction(20 downto 16);
rd1 <= RF(conv_integer(instruction(25 downto 21)));
rd2 <= RF(conv_integer(instruction(20 downto 16)));
func <= instruction(5 downto 0);
sa <= instruction (10 downto 6);

end Behavioral;
