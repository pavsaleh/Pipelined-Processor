LIBRARY ieee;
USE ieee.std_logic_1164.ALL;

ENTITY mux_8_4 IS
	PORT (
		a, b, c, d : IN STD_LOGIC_VECTOR(7 DOWNTO 0);
		sel : IN STD_LOGIC_VECTOR(1 DOWNTO 0);
		y : OUT STD_LOGIC_VECTOR(7 DOWNTO 0));
END mux_8_4;

ARCHITECTURE arch_mux_8_4 OF mux_8_4 IS
BEGIN
	WITH sel SELECT
		y <= a WHEN "00",
		b WHEN "01",
		c WHEN "10",
		d WHEN OTHERS;
END arch_mux_8_4;