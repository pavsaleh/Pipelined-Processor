LIBRARY ieee;
USE ieee.std_logic_1164.ALL;

ENTITY mux_1_2 IS
	PORT (
		a, b : IN STD_LOGIC;
		sel : IN STD_LOGIC;
		y : OUT STD_LOGIC
	);
END mux_1_2;

ARCHITECTURE arch_mux_1_2 OF mux_1_2 IS
BEGIN
	WITH sel SELECT
		y <= a WHEN '0',
		b WHEN OTHERS;
END arch_mux_1_2;