LIBRARY ieee;
USE ieee.std_logic_1164.ALL;

ENTITY registerfile IS
	PORT (
		clk, resetBar : IN STD_LOGIC;
		readRegister1 : IN STD_LOGIC_VECTOR(4 DOWNTO 0);
		readRegister2 : IN STD_LOGIC_VECTOR(4 DOWNTO 0);
		writeRegister : IN STD_LOGIC_VECTOR(4 DOWNTO 0);
		writeData : IN STD_LOGIC_VECTOR(7 DOWNTO 0);
		RegWrite : IN STD_LOGIC;
		readData1 : OUT STD_LOGIC_VECTOR(7 DOWNTO 0);
		readData2 : OUT STD_LOGIC_VECTOR(7 DOWNTO 0)
	);
END registerfile;

ARCHITECTURE rtl OF registerfile IS

	SIGNAL decodeout, out0, out1, out2, out3, out4, out5, out6, out7 : STD_LOGIC_VECTOR(7 DOWNTO 0);
	SIGNAL tmp : STD_LOGIC_VECTOR(7 DOWNTO 0);

	COMPONENT eightbitregister
		PORT (
			i_resetBar, i_en : IN STD_LOGIC;
			i_clock : IN STD_LOGIC;
			i_Value : IN STD_LOGIC_VECTOR(7 DOWNTO 0);
			o_Value : OUT STD_LOGIC_VECTOR(7 DOWNTO 0));
	END COMPONENT;

	COMPONENT decoder3to8
		PORT (
			A : IN STD_LOGIC_VECTOR(2 DOWNTO 0);
			Y : OUT STD_LOGIC_VECTOR(7 DOWNTO 0)
		);
	END COMPONENT;

	COMPONENT mux3to8
		PORT (
			a1, a2, a3, a4, a5, a6, a7, a8 : IN STD_LOGIC_VECTOR(7 DOWNTO 0);
			s : IN STD_LOGIC_VECTOR(2 DOWNTO 0);
			m : OUT STD_LOGIC_VECTOR(7 DOWNTO 0)
		);
	END COMPONENT;

BEGIN
	decode : decoder3to8 PORT MAP(writeRegister(2 DOWNTO 0), decodeout);

	tmp(0) <= regwrite AND decodeout(7);
	tmp(1) <= regwrite AND decodeout(6);
	tmp(2) <= regwrite AND decodeout(5);
	tmp(3) <= regwrite AND decodeout(4);
	tmp(4) <= regwrite AND decodeout(3);
	tmp(5) <= regwrite AND decodeout(2);
	tmp(6) <= regwrite AND decodeout(1);
	tmp(7) <= regwrite AND decodeout(0);

	r0 : eightbitregister PORT MAP(resetBar, tmp(0), clk, writeData, out0);
	r1 : eightbitregister PORT MAP(resetBar, tmp(1), clk, writeData, out1);
	r2 : eightbitregister PORT MAP(resetBar, tmp(2), clk, writeData, out2);
	r3 : eightbitregister PORT MAP(resetBar, tmp(3), clk, writeData, out3);
	r4 : eightbitregister PORT MAP(resetBar, tmp(4), clk, writeData, out4);
	r5 : eightbitregister PORT MAP(resetBar, tmp(5), clk, writeData, out5);
	r6 : eightbitregister PORT MAP(resetBar, tmp(6), clk, writeData, out6);
	r7 : eightbitregister PORT MAP(resetBar, tmp(7), clk, writeData, out7);

	mux1 : mux3to8 PORT MAP(out0, out1, out2, out3, out4, out5, out6, out7, readRegister1(2 DOWNTO 0), readData1);
	mux2 : mux3to8 PORT MAP(out0, out1, out2, out3, out4, out5, out6, out7, readRegister2(2 DOWNTO 0), readData2);

END rtl;