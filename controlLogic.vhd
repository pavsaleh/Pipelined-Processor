LIBRARY ieee;
USE ieee.std_logic_1164.ALL;

ENTITY controlLogic IS
	PORT (
		OP : IN STD_LOGIC_VECTOR(5 DOWNTO 0);
		RegDst, Jump, ALUSrc, MemtoReg, RegWrite, MemRead, MemWrite, Branch, ALUOp1, ALUOp0 : OUT STD_LOGIC
	);
END controlLogic;

ARCHITECTURE struct OF controlLogic IS

	SIGNAL Rformat, lw, sw, beq : STD_LOGIC;

BEGIN

	Rformat <= NOT OP(5) AND NOT OP(4) AND NOT OP(3) AND NOT OP(2) AND NOT OP(1) AND NOT OP(0);
	lw <= OP(5) AND NOT OP(4) AND NOT OP(3) AND NOT OP(2) AND OP(1) AND OP(0);
	sw <= OP(5) AND NOT OP(4) AND OP(3) AND NOT OP(2) AND OP(1) AND OP(0);
	beq <= NOT OP(5) AND NOT OP(4) AND NOT OP(3) AND OP(2) AND NOT OP(1) AND NOT OP(0);

	RegDst <= Rformat;
	Jump <= NOT OP(5) AND NOT OP(4) AND NOT OP(3) AND NOT OP(2) AND OP(1) AND NOT OP(0);
	ALUSrc <= lw OR sw;
	MemtoReg <= lw;
	RegWrite <= Rformat OR lw;
	MemRead <= lw;
	MemWrite <= sw;
	Branch <= beq;
	ALUOp1 <= Rformat;
	ALUOp0 <= beq;

END struct;