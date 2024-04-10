library IEEE;
use IEEE.STD_LOGIC_1164.ALL;
use IEEE.STD_LOGIC_UNSIGNED.ALL;


entity test_env is
    Port ( clk : in STD_LOGIC;
           btn : in STD_LOGIC_VECTOR (4 downto 0);
           sw : in STD_LOGIC_VECTOR (15 downto 0);
           led : out STD_LOGIC_VECTOR (15 downto 0);
           an : out STD_LOGIC_VECTOR (7 downto 0);
           cat : out STD_LOGIC_VECTOR (6 downto 0));
end test_env;

architecture Behavioral of test_env is

component MPG is
    Port ( enable : out STD_LOGIC;
           btn : in STD_LOGIC;
           clk : in STD_LOGIC);
end component;

component SSD is
    Port ( clk : in STD_LOGIC;
           digits : in STD_LOGIC_VECTOR(31 downto 0);
           an : out STD_LOGIC_VECTOR(7 downto 0);
           cat : out STD_LOGIC_VECTOR(6 downto 0));
end component;


component IFetch is
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
end component;


signal en, rstIF, jump, pcsrc : STD_LOGIC;
signal digits, instruction, pc_plus4, jump_address, branch_address :  STD_LOGIC_VECTOR (31 downto 0);


begin

mpg1: MPG port map(en, btn(0), clk);
mpg2: MPG port map(rstIF, btn(1), clk);
ifetch_map: IFetch port map(clk, jump, pcsrc, en, rstIF, jump_address, branch_address, instruction, pc_plus4);
portssd: SSD port map(clk, digits, an, cat);

digits <= instruction when sw(7) = '1' else pc_plus4;

led(0) <= en;
led(5) <= btn(0);
led(1) <= sw(1);
end Behavioral;
