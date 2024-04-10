library IEEE;
use IEEE.STD_LOGIC_1164.ALL;
use IEEE.STD_LOGIC_UNSIGNED.ALL;

-- intrarile sunt Clk, Jump, PCSrc, Jump Address si Branch Address
entity IFetch is
    Port( 
        clk : in STD_LOGIC;
        jump : in STD_LOGIC;
        pcsrc : in STD_LOGIC;
        en : in STD_LOGIC;
        rst : in STD_LOGIC;
        jump_address : in STD_LOGIC_VECTOR (31 downto 0);
        branch_address : in STD_LOGIC_VECTOR (31 downto 0);
        instruction : out STD_LOGIC_VECTOR (31 downto 0);
        pc_plus4 : out STD_LOGIC_VECTOR (31 downto 0));
end IFetch;

architecture Behavioral of IFetch is

component MPG is
    Port ( enable : out STD_LOGIC;
           btn : in STD_LOGIC;
           clk : in STD_LOGIC);
end component;

signal mux1 : STD_LOGIC_VECTOR(31 downto 0);
signal mux2 : STD_LOGIC_VECTOR(31 downto 0);
signal pc : STD_LOGIC_VECTOR(31 downto 0);

type rom is array(0 to 4) of STD_LOGIC_VECTOR(31 downto 0);

signal mem : rom := (
 -- B"000000_00000_00000_00000_00000_000000",
    B"000000_00010_00001_00000_00000_000001",
    B"000000_00010_00001_00000_00000_001001",
    
    others => X"00000000"
);


begin

instruction <= mem(conv_integer(pc(4 downto 0)));
pc_plus4 <= pc + '1';

counter : process(clk)
    begin
    
        if rst = '1' then
            pc <= X"00000000";
        else
            if rising_edge(en) then
                pc <= pc + '1';
            end if;
        end if;
    end process counter;

mux1 <= branch_address when pcsrc = '1' else pc + '1';
mux2 <= mux1 when jump = '0' else pc;

end Behavioral;
