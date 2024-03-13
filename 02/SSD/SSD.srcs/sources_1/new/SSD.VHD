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
signal digits : STD_LOGIC_VECTOR(31 downto 0) := (others => '0');
signal an_map : STD_LOGIC_VECTOR (7 downto 0);
signal cat_map : STD_LOGIC_VECTOR (6 downto 0);
signal dir : STD_LOGIC;
signal cnt : STD_LOGIC_VECTOR(1 downto 0);

begin

maspg: MPG port map(en, btn(0),clk);
hkdsadj: SSSD port map(clk,digits,an,cat);
dir <= sw(15);
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

mux : process(cnt)
begin
    case cnt is
        when "00" => digits <= (X"0000000" & sw(3 downto 0)) + (X"0000000" & sw(7 downto 4));
        when "01" => digits <= (X"0000000" & sw(3 downto 0)) - (X"0000000" & sw(7 downto 4));
        when "10" => digits <= X"0000" & "000000" & sw(7 downto 0) & "00";
        when "11" => digits <= X"0000" & "0000000000" & sw(7 downto 2);
        when others => digits <= (others => 'X');
    end case;
end process;

process(digits)
begin
    if digits = X"00" then
        led(8) <= '1';
    else 
        led(8) <= '0';
    end if;
end process;
led(7 downto 0) <= sw(7 downto 0);
--ssd : process(clk)
--begin
--    an <= an_map;
--    cat <= cat_map;
--end process;
end Behavioral;
