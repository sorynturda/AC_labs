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

component SSSD is
    Port ( clk : in STD_LOGIC;
           digits : in STD_LOGIC_VECTOR(31 downto 0);
           an : out STD_LOGIC_VECTOR(7 downto 0);
           cat : out STD_LOGIC_VECTOR(6 downto 0));
end component;

signal en : STD_LOGIC;
signal cnt : STD_LOGIC_VECTOR(31 downto 0) := (others => '0');
signal an_map : STD_LOGIC_VECTOR (7 downto 0);
signal cat_map : STD_LOGIC_VECTOR (6 downto 0);
signal dir : STD_LOGIC;
begin

maspg: MPG port map(en, btn(0),clk);
hkdsadj: SSSD port map(clk,cnt,an,cat);
dir <= sw(0);
counter : process(clk, en)
begin
    if rising_edge(clk) then
        if en = '1' then
            if dir = '0' then
                cnt <= cnt + '1';
            else
                cnt <= cnt - '1';
            end if;
        end if;
    end if;
end process;

--ssd : process(clk)
--begin
--    an <= an_map;
--    cat <= cat_map;
--end process;
end Behavioral;
