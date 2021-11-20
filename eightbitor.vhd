LIBRARY ieee;
USE ieee.std_logic_1164.ALL;

ENTITY eightbitor IS
	PORT (
		valA, valB : IN STD_LOGIC_VECTOR (7 DOWNTO 0);
		valO : OUT STD_LOGIC_VECTOR(7 DOWNTO 0)
	);
END eightbitor;

ARCHITECTURE arch_eightbitor OF eightbitor IS

BEGIN
	valO <= valB OR valA;
END ARCHITECTURE arch_eightbitor;