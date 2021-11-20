LIBRARY ieee;
USE ieee.std_logic_1164.ALL;

ENTITY mux3to8 IS
	PORT (
		a1, a2, a3, a4, a5, a6, a7, a8 : IN STD_LOGIC_VECTOR(7 DOWNTO 0);
		s : IN STD_LOGIC_VECTOR(2 DOWNTO 0);
		m : OUT STD_LOGIC_VECTOR(7 DOWNTO 0)
	);
END mux3to8;

ARCHITECTURE circuit OF mux3to8 IS
BEGIN
	m <= a1 WHEN s = "000" ELSE
		a2 WHEN s = "001" ELSE
		a3 WHEN s = "010" ELSE
		a4 WHEN s = "011" ELSE
		a5 WHEN s = "100" ELSE
		a6 WHEN s = "011" ELSE
		a7 WHEN s = "110" ELSE
		a8 WHEN s = "111";
END circuit;