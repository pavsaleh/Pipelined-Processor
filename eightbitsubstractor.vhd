LIBRARY IEEE;
USE ieee.std_logic_1164.ALL;

ENTITY eightbitsubtractor IS
	PORT (
		M : IN STD_LOGIC_VECTOR (7 DOWNTO 0);
		N : IN STD_LOGIC_VECTOR (7 DOWNTO 0);
		Din : IN STD_LOGIC;
		Cout : OUT STD_LOGIC;
		Sum : OUT STD_LOGIC_VECTOR (7 DOWNTO 0)
	);
END eightbitsubtractor;

ARCHITECTURE arch_eightbitsubtractor OF eightbitsubtractor IS
	SIGNAL s0, s1, s2, s3, s4, s5, s6 : STD_LOGIC;
	SIGNAL output : STD_LOGIC_VECTOR(7 DOWNTO 0);
	COMPONENT fullsubstractor
		PORT (
			A : IN STD_LOGIC;
			B : IN STD_LOGIC;
			C : IN STD_LOGIC;
			DIFFERENCE : OUT STD_LOGIC;
			BORROW : OUT STD_LOGIC
		);
	END COMPONENT;

BEGIN

	l0 : fullsubstractor PORT MAP(M(0), N(0), Din, output(0), s0);
	l1 : fullsubstractor PORT MAP(M(1), N(1), s0, output(1), s1);
	l2 : fullsubstractor PORT MAP(M(2), N(2), s1, output(2), s2);
	l3 : fullsubstractor PORT MAP(M(3), N(3), s2, output(3), s3);
	l4 : fullsubstractor PORT MAP(M(4), N(4), s3, output(4), s4);
	l5 : fullsubstractor PORT MAP(M(5), N(5), s4, output(5), s5);
	l6 : fullsubstractor PORT MAP(M(6), N(6), s5, output(6), s6);
	l7 : fullsubstractor PORT MAP(M(7), N(7), s6, output(7), cout);

	Sum <= output;

END arch_eightbitsubtractor;