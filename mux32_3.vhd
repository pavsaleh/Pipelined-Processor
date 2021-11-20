LIBRARY ieee;
USE ieee.std_logic_1164.ALL;

ENTITY mux32_3 IS
	PORT (
		a, b, c, d, e, f : IN STD_LOGIC_VECTOR(31 DOWNTO 0);
		s : IN STD_LOGIC_VECTOR(2 DOWNTO 0);
		y : OUT STD_LOGIC_VECTOR(31 DOWNTO 0));
END mux32_3;

ARCHITECTURE arch_mux32_3 OF mux32_3 IS
BEGIN

	WITH s SELECT
		y <= a WHEN "000",
		b WHEN "001",
		c WHEN "010",
		d WHEN "011",
		e WHEN "100",
		f WHEN OTHERS;
END arch_mux32_3;