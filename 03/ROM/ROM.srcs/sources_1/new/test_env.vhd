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
    Port ( 
        enable : out STD_LOGIC;
        btn : in STD_LOGIC;
        clk : in STD_LOGIC);
end component;

component SSD is
    Port ( clk : in STD_LOGIC;
           digits : in STD_LOGIC_VECTOR(31 downto 0);
           an : out STD_LOGIC_VECTOR(7 downto 0);
           cat : out STD_LOGIC_VECTOR(6 downto 0));
end component;

type ROM is array (0 to 31) of std_logic_vector(31 downto 0);
signal memorie : ROM := (
    X"1278A",
    X"9747F1",
    others => X"696969"
);

signal cnt : STD_LOGIC_VECTOR(4 downto 0) := (others => '0');
signal en : STD_LOGIC;
signal semnal : STD_LOGIC_VECTOR(31 downto 0);
begin
semnal <= memorie(conv_integer(cnt));
buton: MPG port map(en,btn(0),clk);
afisor: SSD port map(clk, semnal, an, cat);
counter : process(clk)
begin
    if rising_edge(clk) and en = '1' then
        cnt <= cnt + 1;
    end if;
end process;

end Behavioral;
