LIBRARY ieee;
USE ieee.std_logic_1164.ALL;

ENTITY ALUcontroller IS
	PORT (
		F : IN STD_LOGIC_VECTOR(5 DOWNTO 0);
		ALUOP : IN STD_LOGIC_VECTOR(1 DOWNTO 0);
		Operation : OUT STD_LOGIC_VECTOR(2 DOWNTO 0)
	);
END ALUcontroller;

ARCHITECTURE struct OF ALUcontroller IS

BEGIN

	Operation(0) <= ALUOP(1) AND (F(0) OR F(3));
	Operation(1) <= (NOT F(2)) OR (NOT ALUOP(1));
	Operation(2) <= ALUOP(0) OR (ALUOP(1) AND F(1));

END struct;