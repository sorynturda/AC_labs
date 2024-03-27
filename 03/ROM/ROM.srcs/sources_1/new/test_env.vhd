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

component reg_file is
    port (  clk : in std_logic;
            ra1 : in std_logic_vector(4 downto 0);
            ra2 : in std_logic_vector(4 downto 0);
            wa : in std_logic_vector(4 downto 0);
            wd : in std_logic_vector(31 downto 0);
            regwr : in std_logic;
            rd1 : out std_logic_vector(31 downto 0);
            rd2 : out std_logic_vector(31 downto 0));
end component;

component ram_wr_1st is
    port (  clk : in std_logic;
            we : in std_logic;
            --en : in std_logic; -- opțional
            addr : in std_logic_vector(5 downto 0);
            di : in std_logic_vector(31 downto 0);
            do : out std_logic_vector(31 downto 0));
end component;

--type ROM is array (0 to 31) of std_logic_vector(31 downto 0);
--signal memorie : ROM := (
--    X"1278A",
--    X"9747F1",
--    others => X"696969"
--);

signal cnt : STD_LOGIC_VECTOR(5 downto 0) := (others => '0'); --regfile are 5 
signal rst, en, regwr, we : STD_LOGIC;
signal digits, rd1, rd2, tmp : STD_LOGIC_VECTOR(31 downto 0);
begin

tmp <= digits(31 downto 2) & "00";
--semnal <= memorie(conv_integer(cnt));

buton2: MPG port map(rst,btn(2),clk);
buton0: MPG port map(en,btn(0),clk);
buton1regwr: MPG port map(regwr, btn(1),clk);
buton2we : MPG port map(we, btn(1),clk);
afisor: SSD port map(clk, digits, an, cat);
--regfile: reg_file port map(clk, cnt, cnt, cnt, digits, regwr, rd1, rd2);
ramwr: ram_wr_1st port map(clk, we, cnt, tmp, digits);

digits <= rd1 + rd2;
    counter : process(clk)
    begin
        if rst = '1' then 
            cnt <= "000000";
        else 
            if rising_edge(clk) and en = '1' then
                cnt <= cnt + 1;
            end if;
         end if;
    end process;

led(0) <= btn(0);
led(1) <= btn(1);
led(2) <= btn(2);
led(3) <= btn(3);
led(4) <= btn(4);

end Behavioral;
