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

type rom is array(0 to 31) of STD_LOGIC_VECTOR(31 downto 0);

signal mem : rom := (
     -- B"000000_00000_00000_00000_00000_000000",
        B"000000_00000_00000_00000_00000_000100", -- xor $0, $0, $0         X"00000004"
        B"000000_00100_00100_00100_00000_000100", -- xor $4, $4, $4         X"00842004"
        B"100000_00000_00000_00000_00000_001100", -- addi $0, $0, 12        X"8000000C"
        B"100000_00100_00100_00000_00000_101000", -- addi $4, $4, 20        X"80840028"
        B"000000_01001_01001_01001_00000_000100", -- xor $9, $9, $9         X"01294804"
        B"000000_00000_01001_01001_00001_000000", -- sll $9, $9, 12         X"00094840"
        B"000100_01001_01000_00000_00000_001101", -- beq $0, $4, end_loop   X"1128000D"
        B"000000_00000_00100_01000_00000_001000", -- slt $8, $0, $4, greater X"00044008"
        B"000100_01000_01001_00000_00000_001011", -- beg $9, $8, 11         X"1109000B"
        B"000000_00000_00100_00000_00000_000010", -- sub $0, $0, $4         X"00040002"
        B"111111_00000_00000_00000_00000_001101", -- j 12                   X"FC00000D"
        B"000000_00100_00000_00100_00000_000010", -- sub $4, $4, $0         X"00802002"
        B"111111_00000_00000_00000_00000_000110", -- j 6                    X"FC000006"
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
