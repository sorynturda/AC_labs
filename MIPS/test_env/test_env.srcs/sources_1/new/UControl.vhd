library IEEE;
use IEEE.STD_LOGIC_1164.ALL;
use IEEE.STD_LOGIC_UNSIGNED.ALL;

entity UControl is
    Port ( instruction : in STD_LOGIC_VECTOR (5 downto 0);
           reg_dst : out STD_LOGIC;
           ext_op : out STD_LOGIC;
           alu_src : out STD_LOGIC;
           branch : out STD_LOGIC;
           jump : out STD_LOGIC;
           alu_op : out STD_LOGIC_VECTOR (1 downto 0);
           mem_write : out STD_LOGIC;
           mem_to_reg : out STD_LOGIC;
           reg_write : out STD_LOGIC);
end UControl;

architecture Behavioral of UControl is       

begin

    process(instruction)
    begin
        reg_dst <= '0'; ext_op <='0'; alu_src <='0';
        branch <= '0'; jump <= '0'; mem_write <='0';
        mem_to_reg <= '0'; reg_write <= '0'; alu_op <= "00";
        case Instruction is
            when "000000" => -- R type
                reg_dst <= '1'; reg_write <= '1';
                alu_op <= "00";
            when "000100" => -- beg
                ext_op <= '0'; branch <= '1';
                alu_op <= "01";
            when "111111" => -- j
                jump <= '1';
            when "001000" => -- sw 
                ext_op <= '1'; mem_write <= '1';
                alu_src <= '1'; alu_op <= "10";
            when "000010" => -- ori
                alu_src <= '1'; reg_write <= '1';
                alu_op <= "11";
            when "100000" => -- addi
                ext_op <= '1'; reg_dst <= '1';
                alu_src <= '1'; reg_write <= '1';
                alu_op <= "10";
            when "010000" => -- lw
                ext_op <= '1'; alu_src <= '1'; mem_to_reg <= '1';
                reg_write <= '1'; alu_op <= "10";
            when "000001" => -- bne
                ext_op <= '1'; branch <= '1'; alu_op <="01";
            when others => alu_op <= "XX";
                mem_to_reg <='X';reg_write <='X';
                jump <= 'X'; branch <= 'X';
        end case;
    end process;

end Behavioral;
