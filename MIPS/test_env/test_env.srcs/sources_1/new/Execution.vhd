library IEEE;
use IEEE.STD_LOGIC_1164.ALL;
use IEEE.STD_LOGIC_ARITH.ALL;

entity Execution is
    Port ( rd1 : in STD_LOGIC_VECTOR (31 downto 0);
           alu_src : in STD_LOGIC;
           rd2 : in STD_LOGIC_VECTOR (31 downto 0);
           ext_imm : in STD_LOGIC_VECTOR (31 downto 0);
           sa : in STD_LOGIC_VECTOR (4 downto 0);
           func : in STD_LOGIC_VECTOR (5 downto 0);
           alu_op : in STD_LOGIC;
           pc_plus4 : in STD_LOGIC_VECTOR (31 downto 0);
           zero : out STD_LOGIC;
           alu_res : out STD_LOGIC_VECTOR (31 downto 0);
           branch_address : out STD_LOGIC_VECTOR (31 downto 0));
end Execution;

architecture Behavioral of Execution is

signal alu_ctrl : STD_LOGIC_VECTOR (2 downto 0);

begin

ALUControl : process(alu_op, func)
begin
    
    case alu_op is 
        when "00" =>
            case func is
                when ""
    
end process;

end Behavioral;
