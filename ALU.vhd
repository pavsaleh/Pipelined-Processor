LIBRARY ieee;
USE ieee.std_logic_1164.ALL;

ENTITY alu IS
	PORT (
		A, B : IN STD_LOGIC_VECTOR(7 DOWNTO 0);
		ALUOP : IN STD_LOGIC_VECTOR(2 DOWNTO 0);
		zero : OUT STD_LOGIC;
		result : OUT STD_LOGIC_VECTOR(7 DOWNTO 0)
	);
END alu;

ARCHITECTURE arch_alu OF alu IS

	SIGNAL aluresult, addresult, subresult, andresult, orresult : STD_LOGIC_VECTOR(7 DOWNTO 0);

	COMPONENT eightbitfulladder IS
		PORT (
			M : IN STD_LOGIC_VECTOR (7 DOWNTO 0);
			N : IN STD_LOGIC_VECTOR (7 DOWNTO 0);
			Cin : IN STD_LOGIC;
			Cout : OUT STD_LOGIC;
			Sum : OUT STD_LOGIC_VECTOR (7 DOWNTO 0)
		);
	END COMPONENT;

	COMPONENT eightbitsubtractor IS
		PORT (
			M : IN STD_LOGIC_VECTOR (7 DOWNTO 0);
			N : IN STD_LOGIC_VECTOR (7 DOWNTO 0);
			Din : IN STD_LOGIC;
			Cout : OUT STD_LOGIC;
			Sum : OUT STD_LOGIC_VECTOR (7 DOWNTO 0)
		);
	END COMPONENT;

	COMPONENT eightbitor IS
		PORT (
			valA, valB : IN STD_LOGIC_VECTOR (7 DOWNTO 0);
			valO : OUT STD_LOGIC_VECTOR(7 DOWNTO 0)
		);
	END COMPONENT;

	COMPONENT eightbitand IS
		PORT (
			valA, valB : IN STD_LOGIC_VECTOR (7 DOWNTO 0);
			valO : OUT STD_LOGIC_VECTOR(7 DOWNTO 0)
		);
	END COMPONENT;

BEGIN
	ALU_ADD : eightbitfulladder PORT MAP(A, B, '0', OPEN, addresult);
	ALU_SUB : eightbitsubtractor PORT MAP(A, B, '0', OPEN, subresult);
	ALU_AND : eightbitand PORT MAP(A, B, andresult);
	ALU_OR : eightbitor PORT MAP(A, B, orresult);

	WITH ALUOP SELECT
		aluresult <= andresult WHEN "000",
		orresult WHEN "001",
		addresult WHEN "010",
		subresult WHEN "110",
		"00000000" WHEN OTHERS;

	result <= aluresult;

	zero <= NOT (aluresult(0) OR aluresult(1) OR aluresult(2) OR aluresult(3) OR aluresult(4) OR aluresult(5) OR aluresult(6) OR aluresult(7));

END arch_alu;