library IEEE;
use IEEE.STD_LOGIC_1164.ALL;
use IEEE.STD_LOGIC_UNSIGNED.ALL;

entity Memory is
    Port ( mem_write : in STD_LOGIC;
           alu_res_in : in STD_LOGIC_VECTOR (31 downto 0);
           rd2 : in STD_LOGIC_VECTOR (31 downto 0);
           clk : in STD_LOGIC;
           en : in STD_LOGIC;
           mem_data : out STD_LOGIC_VECTOR (31 downto 0);
           alu_res_out : out STD_LOGIC_VECTOR (31 downto 0));
end Memory;

architecture Behavioral of Memory is

type ram is array(0 to 64) of STD_LOGIC_VECTOR (31 downto 0);

signal MEM : ram := (others => X"00000000");
signal address : STD_LOGIC_VECTOR(5 downto 0);

begin
address <= alu_res_in(5 downto 0);
process(clk)
    begin
        if rising_edge(clk) then 
            if en='1' and mem_write='1' then
                MEM(conv_integer(address)) <= rd2;
            end if;
        end if;
end process;

alu_res_out <= alu_res_in;
mem_data <= MEM(conv_integer(address));

end Behavioral;
