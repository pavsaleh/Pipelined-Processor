LIBRARY ieee;
USE ieee.std_logic_1164.ALL;

ENTITY ForwardingUnit IS
	PORT (
		EXMEMRegWrite, MEMWBRegWrite : IN STD_LOGIC;
		EXMEMRD, IDEXRS, IDEXRT, MEMWBRD : IN STD_LOGIC_VECTOR(4 DOWNTO 0);
		forwardA, forwardB : OUT STD_LOGIC_VECTOR(1 DOWNTO 0)
	);
END ForwardingUnit;

ARCHITECTURE arch_ForwardingUnit OF ForwardingUnit IS

	SIGNAL t0, t1, t2, t3, eqRS_EXMEM, eq2, eqRT_EXMEM, eqRS_MEMWB, eqRT_MEMWB : STD_LOGIC;

BEGIN

	eqRS_EXMEM <= (EXMEMRD(4) XNOR IDEXRS(4)) AND (EXMEMRD(3) XNOR IDEXRS(3)) AND (EXMEMRD(2) XNOR IDEXRS(2)) AND (EXMEMRD(1) XNOR IDEXRS(1)) AND (EXMEMRD(0) XNOR IDEXRS(0));
	eqRT_EXMEM <= (EXMEMRD(4) XNOR IDEXRT(4)) AND (EXMEMRD(3) XNOR IDEXRT(3)) AND (EXMEMRD(2) XNOR IDEXRT(2)) AND (EXMEMRD(1) XNOR IDEXRT(1)) AND (EXMEMRD(0) XNOR IDEXRT(0));
	eqRS_MEMWB <= (MEMWBRD(4) XNOR IDEXRS(4)) AND (MEMWBRD(3) XNOR IDEXRS(3)) AND (MEMWBRD(2) XNOR IDEXRS(2)) AND (MEMWBRD(1) XNOR IDEXRS(1)) AND (MEMWBRD(0) XNOR IDEXRS(0));
	eqRT_MEMWB <= (MEMWBRD(4) XNOR IDEXRT(4)) AND (MEMWBRD(3) XNOR IDEXRT(3)) AND (MEMWBRD(2) XNOR IDEXRT(2)) AND (MEMWBRD(1) XNOR IDEXRT(1)) AND (MEMWBRD(0) XNOR IDEXRT(0));

	t0 <= EXMEMRegWrite AND (EXMEMRD(4) OR EXMEMRD(3) OR EXMEMRD(2) OR EXMEMRD(1) OR EXMEMRD(0)) AND eqRS_EXMEM;
	t1 <= EXMEMRegWrite AND (EXMEMRD(4) OR EXMEMRD(3) OR EXMEMRD(2) OR EXMEMRD(1) OR EXMEMRD(0)) AND eqRT_EXMEM;
	t2 <= MEMWBRegWrite AND (MEMWBRD(4) OR MEMWBRD(3) OR MEMWBRD(2) OR MEMWBRD(1) OR MEMWBRD(0)) AND eqRS_MEMWB;
	t3 <= MEMWBRegWrite AND (MEMWBRD(4) OR MEMWBRD(3) OR MEMWBRD(2) OR MEMWBRD(1) OR MEMWBRD(0)) AND eqRT_MEMWB;

	forwardA <= ((NOT t0) AND t2) & t0;
	forwardB <= ((NOT t1) AND t3) & t1;

END arch_ForwardingUnit;