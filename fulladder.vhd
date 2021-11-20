LIBRARY ieee;
USE ieee.std_logic_1164.ALL;
USE ieee.std_logic_unsigned.ALL;

ENTITY fulladder IS
	PORT (
		A : IN STD_LOGIC;
		B : IN STD_LOGIC;
		Cin : IN STD_LOGIC;
		F : OUT STD_LOGIC;
		Cout : OUT STD_LOGIC
	);
END fulladder;

ARCHITECTURE circuit OF fulladder IS
BEGIN
	F <= A XOR B XOR Cin;
	Cout <= (A AND B) OR (Cin AND A) OR (Cin AND B);
END circuit;