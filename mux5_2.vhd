LIBRARY ieee;
USE ieee.std_logic_1164.ALL;

ENTITY mux_5_2 IS
	PORT (
		a, b : IN STD_LOGIC_VECTOR(4 DOWNTO 0);
		sel : IN STD_LOGIC;
		y : OUT STD_LOGIC_VECTOR(4 DOWNTO 0));
END mux_5_2;

ARCHITECTURE arch_mux_5_2 OF mux_5_2 IS
BEGIN
	WITH sel SELECT
		y <= a WHEN '0',
		b WHEN OTHERS;
END arch_mux_5_2;