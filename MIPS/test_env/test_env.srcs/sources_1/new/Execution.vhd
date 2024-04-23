library IEEE;
use IEEE.STD_LOGIC_1164.ALL;
use IEEE.STD_LOGIC_ARITH.ALL;
use IEEE.STD_LOGIC_UNSIGNED.ALL;

entity Execution is
    Port ( rd1 : in STD_LOGIC_VECTOR (31 downto 0);
           alu_src : in STD_LOGIC;
           rd2 : in STD_LOGIC_VECTOR (31 downto 0);
           ext_imm : in STD_LOGIC_VECTOR (31 downto 0);
           sa : in STD_LOGIC_VECTOR (4 downto 0);
           func : in STD_LOGIC_VECTOR (5 downto 0);
           alu_op : in STD_LOGIC_VECTOR (1 downto 0);
           pc_plus4 : in STD_LOGIC_VECTOR (31 downto 0);
           zero : out STD_LOGIC;
           alu_res : out STD_LOGIC_VECTOR (31 downto 0);
           branch_address : out STD_LOGIC_VECTOR (31 downto 0));
end Execution;

architecture Behavioral of Execution is

signal alu_ctrl : STD_LOGIC_VECTOR (2 downto 0);
signal c : STD_LOGIC_VECTOR (31 downto 0);

begin



ALUControl : process(alu_op, func)
begin    
    case alu_op is 
        when "00" =>
            case func is
                when "000001" => alu_ctrl <= "000"; -- add
                when "000010" => alu_ctrl <= "001"; -- sub
                when "000100" => alu_ctrl <= "010"; -- xor
                when "000000" => alu_ctrl <= "100"; -- sll
                when "001000" => alu_ctrl <= "110"; -- slt
                when "000011" => alu_ctrl <= "111"; -- srl
                when "010000" => alu_Ctrl <= "011"; -- or
                when "100000" => alu_Ctrl <= "101"; -- and 
                when others => alu_ctrl <= "XXX";
            end case;
        when "01" => alu_ctrl <= "001"; -- sub
        when "10" => alu_ctrl <= "000"; -- add
        when "11" => alu_ctrl <= "011"; -- or
        when others => alu_ctrl <= "XXX";
    end case;
end process;

process(rd1, rd2, alu_ctrl, sa)
begin
    case alu_ctrl is 
        when "000" => C <= rd1 + rd2;
        when "001" => C <= rd1 - rd2;
        when "100" => C <= to_stdlogicvector(to_bitvector(rd2) sll conv_integer(sa));
        when "110" =>
            if signed(rd1) < signed(rd2) then C <= X"00000001";
            else C <= X"00000000";
            end if; 
        when "010" => C <= rd1 xor rd2;
        when "101" => C <= rd1 and rd2;
        when "011" => C <= rd1 or rd2;
        when "111" => C <= to_stdlogicvector(to_bitvector(rd2) sra conv_integer(sa));
        when others => C <= rd1;
    end case;
end process;

alu_res <= C;
zero <= '1' when C = 0 else '0';
branch_address <= pc_plus4 +  (ext_imm (29 downto 0) & "00");

end Behavioral;
