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

component UControl is
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
end component;

component IDecode is
    Port ( clk : in STD_LOGIC;
        reg_write : in STD_LOGIC;
        wa : in STD_LOGIC_VECTOR(4 downto 0);
        wd : in STD_LOGIC_VECTOR (31 downto 0);
        en : in STD_LOGIC;
        ext_op : in STD_LOGIC;
        instruction : in STD_LOGIC_VECTOR (25 downto 0);
       rd1 : out STD_LOGIC_VECTOR (31 downto 0);
       rd2 : out STD_LOGIC_VECTOR (31 downto 0);
       ext_imm : out STD_LOGIC_VECTOR (31 downto 0);
       func : out STD_LOGIC_VECTOR (5 downto 0);
       sa : out STD_LOGIC_VECTOR (4 downto 0);
       rt : out STD_LOGIC_VECTOR(4 downto 0);
       rd : out STD_LOGIC_VECTOR(4 downto 0));
end component;

component Execution is
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
       branch_address : out STD_LOGIC_VECTOR (31 downto 0);
       rd : in STD_LOGIC_VECTOR(4 downto 0);
       rt : in STD_LOGIC_VECTOR(4 downto 0);
       reg_dst : in STD_LOGIC;
       rwa : out STD_LOGIC_VECTOR(4 downto 0));
end component;

component Memory is
    Port ( mem_write : in STD_LOGIC;
           alu_res_in : in STD_LOGIC_VECTOR (31 downto 0);
           rd2 : in STD_LOGIC_VECTOR (31 downto 0);
           clk : in STD_LOGIC;
           en : in STD_LOGIC;
           mem_data : out STD_LOGIC_VECTOR (31 downto 0);
           alu_res_out : out STD_LOGIC_VECTOR (31 downto 0));
end component;

signal en, rstIF, jump, pcsrc, zero : STD_LOGIC;
signal reg_write, reg_dst, ext_op, alu_src, branch, mem_write, mem_to_reg: STD_LOGIC;
signal alu_op : STD_LOGIC_VECTOR (1 downto 0);
signal digits, instruction, pc_plus4, jump_address, branch_address :  STD_LOGIC_VECTOR (31 downto 0);

signal alu_res_in, alu_res_out, mem_data : STD_LOGIC_VECTOR (31 downto 0);
signal rd1, rd2, ext_imm, wd : STD_LOGIC_VECTOR (31 downto 0);
signal func : STD_LOGIC_VECTOR (5 downto 0);
signal sa, rt, rd, wa, rwa : STD_LOGIC_VECTOR (4 downto 0);

--pipeline
signal pc_plus4_if_id, instruction_if_id, pc_plus4_id_ex, mem_data_mem_wb, alu_res_out_mem_wb : STD_LOGIC_VECTOR(31 downto 0);
signal rd1_id_ex, rd2_id_ex, ext_imm_id_ex, branch_address_ex_mem : STD_LOGIC_VECTOR(31 downto 0);
signal alu_res_in_ex_mem, rd2_ex_mem : STD_LOGIC_VECTOR(31 downto 0);
signal sa_id_ex, rd_id_ex, rt_id_ex, rd_ex_mem, rd_mem_wb : STD_LOGIC_VECTOR(4 downto 0);
signal func_id_ex : STD_LOGIC_VECTOR(5 downto 0);
signal mem_to_reg_id_ex, reg_write_id_ex, mem_write_id_ex, branch_id_ex, alu_src_id_ex, reg_dst_id_ex, zero_ex_mem : STD_LOGIC; 
signal mem_to_reg_mem_wb, reg_write_mem_wb, mem_to_reg_ex_mem, reg_write_ex_mem, mem_write_ex_mem, branch_ex_mem : STD_LOGIC;
signal alu_op_id_ex : STD_LOGIC_VECTOR(1 downto 0);

--pipeline


begin

process(clk)
begin
    if rising_edge(clk) then
        if en = '1' then
            -- IF/ID
            pc_plus4_if_id <= pc_plus4;
            instruction_if_id <= instruction;
            -- ID/EX
            pc_plus4_id_ex <= pc_plus4_if_id;
            rd1_id_ex <= rd1;
            rd2_id_ex <= rd2;
            ext_imm_id_ex <= ext_imm;
            sa_id_ex <= sa;
            func_id_ex <= func;
            rt_id_ex <= rt;
            rd_id_ex <= rd;
            mem_to_reg_id_ex <= mem_to_reg;
            reg_write_id_ex <= reg_write;
            mem_write_id_ex <= mem_write;
            branch_id_ex <= branch;
            alu_src_id_ex <= alu_src;
            alu_op_id_ex <= alu_op;
            reg_dst_id_ex <= reg_dst;
            -- EX/MEM
            branch_address_ex_mem <= branch_address;
            zero_ex_mem <= zero;
            alu_res_in_ex_mem <= alu_res_in;
            rd2_ex_mem <= rd2;
            rd_ex_mem <= rwa;
            mem_to_reg_ex_mem <= mem_to_reg_id_ex;
            reg_write_ex_mem <= reg_write_id_ex;
            mem_write_ex_mem <= mem_write_id_ex;
            branch_ex_mem <= branch_id_ex;
            -- MEM/WB
            mem_data_mem_wb <= mem_data;
            alu_res_out_mem_wb <= alu_res_out;
            rd_mem_wb <= rd_ex_mem;
            mem_to_reg_mem_wb <= mem_to_reg_ex_mem;
            reg_write_mem_wb <= reg_write_ex_mem;
       end if;
    end if;
end process;


mpg1: MPG port map(en, btn(0), clk);
ifetch_map: IFetch port map(clk, jump, pcsrc, en, rstIF, jump_address, branch_address_ex_mem, instruction, pc_plus4);
portssd: SSD port map(clk, digits, an, cat);
ucontr: UControl port map(instruction_if_id(31 downto 26), reg_dst, ext_op, alu_src, branch, jump, alu_op, mem_write, mem_to_reg, reg_write);
idecod: IDecode port map(en, reg_write, wa, wd, en, ext_op, instruction_if_id (25 downto 0), rd1, rd2, ext_imm, func, sa, rt, rd);
memm: Memory port map (mem_write_ex_mem, alu_res_out_ex_mem, rd2_ex_mem, clk, en, mem_data, alu_res_out);
exx: Execution port map (rd1_id_ex, alu_src_id_ex, rd2_id_ex, ext_imm_id_ex, sa_id_ex, func, alu_op_id_ex, pc_plus4_id_ex, zero, alu_res_out, branch_address, rd, rt, reg_dst_id_ex, rwa);


pcsrc <= zero and branch;

jump_address <= pc_plus4 (31 downto 28) & instruction (25 downto 0) & "00";

with mem_to_reg_mem_wb select
    wd <= mem_data_mem_wb when '1',
          alu_res_out_mem_wb when '0',
          (others => 'X') when others;

with sw(7 downto 5) select
        digits <=  instruction when "000", 
                   pc_plus4 when "001",
                   rd1 when "010",
                   rd2 when "011",
                   ext_imm when "100",
                   alu_res_out when "101",
                   alu_res_in when "110",
                   wd when "111",
                   (others => 'X') when others; 

wd <= alu_res_in when mem_to_reg ='1' else mem_data;
led(9 downto 0) <= alu_op & reg_dst & ext_op & alu_src & branch & jump & mem_write & mem_to_reg & reg_write;
end Behavioral;
