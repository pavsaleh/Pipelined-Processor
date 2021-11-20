LIBRARY IEEE;
USE ieee.std_logic_1164.ALL;

ENTITY eightbitfulladder IS
	PORT (
		M : IN STD_LOGIC_VECTOR (7 DOWNTO 0);
		N : IN STD_LOGIC_VECTOR (7 DOWNTO 0);
		Cin : IN STD_LOGIC;
		Cout : OUT STD_LOGIC;
		Sum : OUT STD_LOGIC_VECTOR (7 DOWNTO 0)
	);
END eightbitfulladder;

ARCHITECTURE arch_eightbitfulladder OF eightbitfulladder IS
	SIGNAL s0, s1, s2, s3, s4, s5, s6 : STD_LOGIC;

	COMPONENT fulladder
		PORT (
			A : IN STD_LOGIC;
			B : IN STD_LOGIC;
			Cin : IN STD_LOGIC;
			F : OUT STD_LOGIC;
			Cout : OUT STD_LOGIC
		);
	END COMPONENT;

BEGIN

	l0 : fulladder PORT MAP(M(0), N(0), Cin, Sum(0), s0);
	l1 : fulladder PORT MAP(M(1), N(1), s0, Sum(1), s1);
	l2 : fulladder PORT MAP(M(2), N(2), s1, Sum(2), s2);
	l3 : fulladder PORT MAP(M(3), N(3), s2, Sum(3), s3);
	l4 : fulladder PORT MAP(M(4), N(4), s3, Sum(4), s4);
	l5 : fulladder PORT MAP(M(5), N(5), s4, Sum(5), s5);
	l6 : fulladder PORT MAP(M(6), N(6), s5, Sum(6), s6);
	l7 : fulladder PORT MAP(M(7), N(7), s6, Sum(7), Cout);

END arch_eightbitfulladder;