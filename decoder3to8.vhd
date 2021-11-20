LIBRARY ieee;
USE ieee.std_logic_1164.ALL;

ENTITY decoder3to8 IS
	PORT (
		A : IN STD_LOGIC_VECTOR(2 DOWNTO 0);
		Y : OUT STD_LOGIC_VECTOR(7 DOWNTO 0)
	);
END decoder3to8;

ARCHITECTURE decode OF decoder3to8 IS
BEGIN
	Y <= "10000000" WHEN A = "000" ELSE
		"01000000" WHEN A = "001" ELSE
		"00100000" WHEN A = "010" ELSE
		"00010000" WHEN A = "011" ELSE
		"00001000" WHEN A = "100" ELSE
		"00000100" WHEN A = "101" ELSE
		"00000010" WHEN A = "110" ELSE
		"00000001";
END decode;