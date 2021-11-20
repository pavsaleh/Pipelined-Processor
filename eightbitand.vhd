LIBRARY ieee;
USE ieee.std_logic_1164.ALL;

ENTITY eightbitand IS
	PORT (
		valA, valB : IN STD_LOGIC_VECTOR (7 DOWNTO 0);
		valO : OUT STD_LOGIC_VECTOR(7 DOWNTO 0)
	);
END eightbitand;

ARCHITECTURE arch_eightbitand OF eightbitand IS
BEGIN
	valO <= valB AND valA;
END ARCHITECTURE arch_eightbitand;