LIBRARY ieee;
USE ieee.std_logic_1164.ALL;

ENTITY top IS
	PORT (
		gclock, greset : IN STD_LOGIC;
		valueselect, instrselect : IN STD_LOGIC_VECTOR(2 DOWNTO 0);
		muxout : OUT STD_LOGIC_VECTOR(7 DOWNTO 0);
		instructionout : OUT STD_LOGIC_VECTOR(31 DOWNTO 0);
		branchout, zeroout, memwriteout, regwriteout : OUT STD_LOGIC
	);
END top;

ARCHITECTURE arch_top OF top IS

	COMPONENT eightbitregister IS
		PORT (
			i_resetBar, i_en : IN STD_LOGIC;
			i_clock : IN STD_LOGIC;
			i_Value : IN STD_LOGIC_VECTOR(7 DOWNTO 0);
			o_Value : OUT STD_LOGIC_VECTOR(7 DOWNTO 0));
	END COMPONENT;

	COMPONENT rom IS
		PORT (
			address : IN STD_LOGIC_VECTOR(7 DOWNTO 0);
			instruction : OUT STD_LOGIC_VECTOR(31 DOWNTO 0));
	END COMPONENT;

	COMPONENT eightbitfulladder IS
		PORT (
			M : IN STD_LOGIC_VECTOR (7 DOWNTO 0);
			N : IN STD_LOGIC_VECTOR (7 DOWNTO 0);
			Cin : IN STD_LOGIC;
			Cout : OUT STD_LOGIC;
			Sum : OUT STD_LOGIC_VECTOR (7 DOWNTO 0)
		);
	END COMPONENT;

	COMPONENT thirtytwobitregister IS
		PORT (
			i_resetBar, i_en : IN STD_LOGIC;
			i_clock : IN STD_LOGIC;
			i_Value : IN STD_LOGIC_VECTOR(31 DOWNTO 0);
			o_Value : OUT STD_LOGIC_VECTOR(31 DOWNTO 0));
	END COMPONENT;

	COMPONENT registerfile IS
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
	END COMPONENT;

	COMPONENT controlLogic IS
		PORT (
			OP : IN STD_LOGIC_VECTOR(5 DOWNTO 0);
			RegDst, Jump, ALUSrc, MemtoReg, RegWrite, MemRead, MemWrite, Branch, ALUOp1, ALUOp0 : OUT STD_LOGIC
		);
	END COMPONENT;

	COMPONENT fivebitregister IS
		PORT (
			i_resetBar, i_en : IN STD_LOGIC;
			i_clock : IN STD_LOGIC;
			i_Value : IN STD_LOGIC_VECTOR(4 DOWNTO 0);
			o_Value : OUT STD_LOGIC_VECTOR(4 DOWNTO 0)
		);
	END COMPONENT;

	COMPONENT alu IS
		PORT (
			A, B : IN STD_LOGIC_VECTOR(7 DOWNTO 0);
			ALUOP : IN STD_LOGIC_VECTOR(2 DOWNTO 0);
			zero : OUT STD_LOGIC;
			result : OUT STD_LOGIC_VECTOR(7 DOWNTO 0)
		);
	END COMPONENT;

	COMPONENT ALUcontroller IS
		PORT (
			F : IN STD_LOGIC_VECTOR(5 DOWNTO 0);
			ALUOP : IN STD_LOGIC_VECTOR(1 DOWNTO 0);
			Operation : OUT STD_LOGIC_VECTOR(2 DOWNTO 0)
		);
	END COMPONENT;

	COMPONENT ram IS
		PORT (
			clk : IN STD_LOGIC;
			mem_access_addr : IN STD_LOGIC_VECTOR(7 DOWNTO 0);
			mem_write_data : IN STD_LOGIC_VECTOR(7 DOWNTO 0);
			mem_write_en, mem_read : IN STD_LOGIC;
			mem_read_data : OUT STD_LOGIC_VECTOR(7 DOWNTO 0)
		);
	END COMPONENT;

	COMPONENT mux_8_2 IS
		PORT (
			a, b : IN STD_LOGIC_VECTOR(7 DOWNTO 0);
			sel : IN STD_LOGIC;
			y : OUT STD_LOGIC_VECTOR(7 DOWNTO 0));
	END COMPONENT;

	COMPONENT enARdFF_2 IS
		PORT (
			i_resetBar : IN STD_LOGIC;
			i_d : IN STD_LOGIC;
			i_enable : IN STD_LOGIC;
			i_clock : IN STD_LOGIC;
			o_q, o_qBar : OUT STD_LOGIC);
	END COMPONENT;

	COMPONENT mux_5_2 IS
		PORT (
			a, b : IN STD_LOGIC_VECTOR(4 DOWNTO 0);
			sel : IN STD_LOGIC;
			y : OUT STD_LOGIC_VECTOR(4 DOWNTO 0));
	END COMPONENT;

	COMPONENT mux8_3 IS
		PORT (
			a, b, c, d, e, f : IN STD_LOGIC_VECTOR(7 DOWNTO 0);
			s : IN STD_LOGIC_VECTOR(2 DOWNTO 0);
			y : OUT STD_LOGIC_VECTOR(7 DOWNTO 0));
	END COMPONENT;

	COMPONENT mux32_3 IS
		PORT (
			a, b, c, d, e, f : IN STD_LOGIC_VECTOR(31 DOWNTO 0);
			s : IN STD_LOGIC_VECTOR(2 DOWNTO 0);
			y : OUT STD_LOGIC_VECTOR(31 DOWNTO 0));
	END COMPONENT;

	COMPONENT mux_8_4 IS
		PORT (
			a, b, c, d : IN STD_LOGIC_VECTOR(7 DOWNTO 0);
			sel : IN STD_LOGIC_VECTOR(1 DOWNTO 0);
			y : OUT STD_LOGIC_VECTOR(7 DOWNTO 0));
	END COMPONENT;

	COMPONENT ForwardingUnit IS
		PORT (
			EXMEMRegWrite, MEMWBRegWrite : IN STD_LOGIC;
			EXMEMRD, IDEXRS, IDEXRT, MEMWBRD : IN STD_LOGIC_VECTOR(4 DOWNTO 0);
			forwardA, forwardB : OUT STD_LOGIC_VECTOR(1 DOWNTO 0)
		);
	END COMPONENT;

	COMPONENT HazardUnit IS
		PORT (
			IDEXreadMEM : IN STD_LOGIC;
			IDEXrt, IFIDrs, IFIDrt : IN STD_LOGIC_VECTOR(4 DOWNTO 0);
			stall : OUT STD_LOGIC
		);
	END COMPONENT;

	COMPONENT mux_1_2 IS
		PORT (
			a, b : IN STD_LOGIC;
			sel : IN STD_LOGIC;
			y : OUT STD_LOGIC
		);
	END COMPONENT;

	-- IF 
	SIGNAL PCin, PCout, Pcplusfourout : STD_LOGIC_VECTOR(7 DOWNTO 0);
	SIGNAL InstructionOut1 : STD_LOGIC_VECTOR(31 DOWNTO 0);
	SIGNAL PCWrite : STD_LOGIC;

	-- IF/ID (datapath)
	SIGNAL IFIDPCplusfourout : STD_LOGIC_VECTOR(7 DOWNTO 0);
	SIGNAL InstructionOut2 : STD_LOGIC_VECTOR(31 DOWNTO 0);
	SIGNAL IFIDWrite : STD_LOGIC;

	-- ID (datapath)
	SIGNAL readdata1out, readdata2out : STD_LOGIC_VECTOR(7 DOWNTO 0);
	SIGNAL MuxControlRegWrite, MuxControlMemWrite : STD_LOGIC;

	-- ID (control)
	SIGNAL RegDst, Jump, ALUSrc, MemtoReg, RegWrite, MemRead, MemWrite, Branch, ALUOp1, ALUOp0 : STD_LOGIC;
	SIGNAL stall : STD_LOGIC;

	-- ID/EX (datapath)
	SIGNAL IDEXPCplusfourout, IDEXreaddata1out, IDEXreaddata2out, IFIDaddressout : STD_LOGIC_VECTOR(7 DOWNTO 0);
	SIGNAL IDEXrdout, IDEXrtout, IDEXrsout : STD_LOGIC_VECTOR(4 DOWNTO 0);
	SIGNAL InstructionOut3 : STD_LOGIC_VECTOR(31 DOWNTO 0);

	-- ID/EX (control)
	SIGNAL IDEXAluSrcout, IDEXRegdstout, IDEXALUOp1out, IDEXAluOp0out, IDEXBranchout, IDEXMemReadout, IDEXMemWriteout, IDEXRegWriteout, IDEXMemtoRegout : STD_LOGIC;

	-- IDEXAluSrcout,

	-- EX (datapath)
	SIGNAL EXPCplusfourout, EXALUSrcout, aluresultout : STD_LOGIC_VECTOR(7 DOWNTO 0);
	SIGNAL EXWriteRegisterout : STD_LOGIC_VECTOR(4 DOWNTO 0);
	SIGNAL alucontrolout : STD_LOGIC_VECTOR(2 DOWNTO 0);
	SIGNAL EXALUOP : STD_LOGIC_VECTOR(1 DOWNTO 0);
	SIGNAL zero : STD_LOGIC;
	SIGNAL forwardA, forwardB : STD_LOGIC_VECTOR(1 DOWNTO 0);
	SIGNAL AluSrcMuxAOut, AluSrcMuxBOut : STD_LOGIC_VECTOR(7 DOWNTO 0);

	-- EX (control)

	-- EX/MEM (datapath)
	SIGNAL EXMEMPCplusfourout, EXMEMaluresultout : STD_LOGIC_VECTOR(7 DOWNTO 0);
	SIGNAL EXMEMWriteRegisterout : STD_LOGIC_VECTOR(4 DOWNTO 0);
	SIGNAL EXMEMzero : STD_LOGIC;
	SIGNAL InstructionOut4 : STD_LOGIC_VECTOR(31 DOWNTO 0);
	SIGNAL EXMEMRdout : STD_LOGIC_VECTOR(4 DOWNTO 0);
	SIGNAL EXMEMWriteDataOut : STD_LOGIC_VECTOR(7 DOWNTO 0);

	-- EX/MEM (control)
	SIGNAL EXMEMBranchout, EXMEMMemReadout, EXMEMMemWriteout, EXMEMRegWriteout, EXMEMMemtoRegout : STD_LOGIC;

	-- MEM (datapath)
	SIGNAL MEMRAMout : STD_LOGIC_VECTOR(7 DOWNTO 0);
	SIGNAL MEMBranch : STD_LOGIC;

	-- MEM (control)

	-- MEM/WB (datapath)
	SIGNAL MEMWBRAMout, MEMWBaluresultout : STD_LOGIC_VECTOR(7 DOWNTO 0);
	SIGNAL MEMWBWriteRegisterout : STD_LOGIC_VECTOR(4 DOWNTO 0);
	SIGNAL InstructionOut5 : STD_LOGIC_VECTOR(31 DOWNTO 0);
	SIGNAL MEMWBRdout : STD_LOGIC_VECTOR(4 DOWNTO 0);

	-- MEM/WB (control)
	SIGNAL MEMWBRegWriteout, MEMWBMemtoRegout : STD_LOGIC;

	-- WB
	SIGNAL WBWriteDataOut : STD_LOGIC_VECTOR(7 DOWNTO 0);

	-- output
	SIGNAL flags : STD_LOGIC_VECTOR(7 DOWNTO 0);

BEGIN

	-- IF stage
	IF_Pcplusfour : mux_8_2 PORT MAP(PCplusfourout, EXMEMPCplusfourout, MEMBranch, PCin);
	PCWrite <= NOT stall;
	programcounter : eightbitregister PORT MAP(greset, PCWrite, gclock, PCin, PCout);
	instructionmemory : rom PORT MAP(PCout, InstructionOut1);
	pcplusfouradder : eightbitfulladder PORT MAP(PCout, "00000100", '0', OPEN, PCplusfourout);

	-- IF/ID pipeline register (datapath)
	IFIDWrite <= NOT stall;
	IF_ID_PCplusfour : eightbitregister PORT MAP(greset, IFIDWrite, gclock, PCplusfourout, IFIDPCplusfourout);
	IF_ID_ROM : thirtytwobitregister PORT MAP(greset, IFIDWrite, gclock, InstructionOut1, InstructionOut2);

	-- ID stage
	ID_registerfile : registerfile PORT MAP(gclock, greset, InstructionOut2(25 DOWNTO 21), InstructionOut2(20 DOWNTO 16), MEMWBWriteRegisterout, WBWriteDataOut, RegWrite, readdata1out, readdata2out);
	ID_controllogic : controlLogic PORT MAP(InstructionOut2(31 DOWNTO 26), RegDst, Jump, ALUSrc, MemtoReg, RegWrite, MemRead, MemWrite, Branch, ALUOp1, ALUOp0);
	ID_Hazard_Unit : HazardUnit PORT MAP(IDEXMemReadout, IDEXRtout, InstructionOut2(25 DOWNTO 21), InstructionOut2(20 DOWNTO 16), stall);
	ID_Mux_Control_RegWrite : mux_1_2 PORT MAP(RegWrite, '0', stall, MuxControlRegWrite);
	ID_Mux_Control_MemWrite : mux_1_2 PORT MAP(MemWrite, '0', stall, MuxControlMemWrite);

	-- ID/EX pipeline register (datapath)
	ID_EX_PCplusfour : eightbitregister PORT MAP(greset, '1', gclock, IFIDPCplusfourout, IDEXPCplusfourout);
	ID_EX_readdata1 : eightbitregister PORT MAP(greset, '1', gclock, readdata1out, IDEXreaddata1out);
	ID_EX_readdata2 : eightbitregister PORT MAP(greset, '1', gclock, readdata2out, IDEXreaddata2out);
	ID_EX_rs : fivebitregister PORT MAP(greset, '1', gclock, InstructionOut2(25 DOWNTO 21), IDEXRsout);
	ID_EX_rd : fivebitregister PORT MAP(greset, '1', gclock, InstructionOut2(15 DOWNTO 11), IDEXRdout);
	ID_EX_rt : fivebitregister PORT MAP(greset, '1', gclock, InstructionOut2(20 DOWNTO 16), IDEXRtout);
	ID_EX_address : eightbitregister PORT MAP(greset, '1', gclock, InstructionOut2(7 DOWNTO 0), IFIDaddressout);
	ID_EX_ROM : thirtytwobitregister PORT MAP(greset, '1', gclock, InstructionOut2, InstructionOut3);

	-- ID/EX pipeline register (control)
	ID_EX_RegDst : enARdFF_2 PORT MAP(greset, regDst, '1', gclock, IDEXRegdstout);
	ID_EX_ALUOP1 : enARdFF_2 PORT MAP(greset, ALUOp1, '1', gclock, IDEXALUOp1out);
	ID_EX_ALUOP0 : enARdFF_2 PORT MAP(greset, AluOp0, '1', gclock, IDEXAluOp0out);
	ID_EX_ALUSrc : enARdFF_2 PORT MAP(greset, AluSrc, '1', gclock, IDEXAluSrcout);
	ID_EX_Branch : enARdFF_2 PORT MAP(greset, Branch, '1', gclock, IDEXBranchout);
	ID_EX_MemRead : enARdFF_2 PORT MAP(greset, MemRead, '1', gclock, IDEXMemReadout);
	ID_EX_MemWrite : enARdFF_2 PORT MAP(greset, MuxControlMemWrite, '1', gclock, IDEXMemWriteout);
	ID_EX_RegWrite : enARdFF_2 PORT MAP(greset, MuxControlRegWrite, '1', gclock, IDEXRegWriteout);
	ID_EX_MemtoReg : enARdFF_2 PORT MAP(greset, MemToReg, '1', gclock, IDEXMemtoRegout);

	-- EX stage
	EXALUOP <= IDEXALUOp1out & IDEXAluOp0out;
	EX_PCplusfour : eightbitfulladder PORT MAP(IDEXPCplusfourout, IFIDaddressout, '0', OPEN, EXPCplusfourout);
	EX_alusrc : mux_8_2 PORT MAP(AluSrcMuxBOut, IFIDaddressout, IDEXAluSrcout, EXALUSrcout);
	EX_alucontroller : alucontroller PORT MAP(IFIDaddressout(5 DOWNTO 0), EXALUOP, alucontrolout);
	EX_alu : alu PORT MAP(AluSrcMuxAOut, EXALUSrcout, alucontrolout, zero, aluresultout);
	EX_WriteRegister : mux_5_2 PORT MAP(IDEXRdout, IDEXRtout, IDEXRegdstout, EXWriteRegisterout);
	ALUSrcAMux : mux_8_4 PORT MAP(IDEXreaddata1out, WBWriteDataOut, EXMEMaluresultout, "00000000", forwardA, AluSrcMuxAOut);
	ALUSrcBMux : mux_8_4 PORT MAP(IDEXreaddata2out, WBWriteDataOut, EXMEMaluresultout, "00000000", forwardB, AluSrcMuxBOut);
	EX_fowarding_unit : ForwardingUnit PORT MAP(EXMEMRegWriteout, MEMWBRegWriteout, EXMEMRdout, IDEXRsout, IDEXRtout, MEMWBRdout, forwardA, forwardB);

	-- EX/MEM pipeline register (datapath)
	EX_MEM_PCplusfour : eightbitregister PORT MAP(greset, '1', gclock, EXPCplusfourout, EXMEMPCplusfourout);
	EX_MEM_aluresult : eightbitregister PORT MAP(greset, '1', gclock, aluresultout, EXMEMaluresultout);
	EX_MEM_zero : enARdFF_2 PORT MAP(greset, zero, '1', gclock, EXMEMzero);
	EX_MEM_EXMEMWrite : eightbitregister PORT MAP(greset, '1', gclock, AluSrcMuxBOut, EXMEMWriteDataOut);
	EX_MEM_WriteRegister : fivebitregister PORT MAP(greset, '1', gclock, EXWriteRegisterout, EXMEMWriteRegisterout);
	EX_MEM_ROM : thirtytwobitregister PORT MAP(greset, '1', gclock, InstructionOut3, InstructionOut4);
	EX_MEM_rd : fivebitregister PORT MAP(greset, '1', gclock, IDEXRdout, EXMEMRdout);

	-- EX/MEM pipeline register (control)
	EX_MEM_Branch : enARdFF_2 PORT MAP(greset, IDEXBranchout, '1', gclock, EXMEMBranchout);
	EX_MEM_MemRead : enARdFF_2 PORT MAP(greset, IDEXMemReadout, '1', gclock, EXMEMMemReadout);
	EX_MEM_MemWrite : enARdFF_2 PORT MAP(greset, IDEXMemWriteout, '1', gclock, EXMEMMemWriteout);
	EX_MEM_RegWrite : enARdFF_2 PORT MAP(greset, IDEXRegWriteout, '1', gclock, EXMEMRegWriteout);
	EX_MEM_MemtoReg : enARdFF_2 PORT MAP(greset, IDEXMemtoRegout, '1', gclock, EXMEMMemtoRegout);

	-- MEM stage
	MEMBranch <= EXMEMBranchout AND EXMEMzero;
	MEM_RAM : ram PORT MAP(gclock, EXMEMaluresultout, EXMEMWriteDataOut, EXMEMMemWriteout, EXMEMMemReadout, MEMRAMout);

	-- MEM/WB pipeline register (datapath)
	MEM_WB_RAMout : eightbitregister PORT MAP(greset, '1', gclock, MEMRAMout, MEMWBRAMout);
	MEM_WB_aluresult : eightbitregister PORT MAP(greset, '1', gclock, EXMEMaluresultout, MEMWBaluresultout);
	MEM_WB_WriteRegister : fivebitregister PORT MAP(greset, '1', gclock, EXMEMWriteRegisterout, MEMWBWriteRegisterout);
	MEM_WB_ROM : thirtytwobitregister PORT MAP(greset, '1', gclock, InstructionOut4, InstructionOut5);
	MEM_WB_rd : fivebitregister PORT MAP(greset, '1', gclock, EXMEMRdout, MEMWBRdout);

	-- MEM/WB pipeline register (control)
	MEM_WB_RegWrite : enARdFF_2 PORT MAP(greset, EXMEMRegWriteout, '1', gclock, MEMWBRegWriteout);
	MEM_WB_MemtoReg : enARdFF_2 PORT MAP(greset, EXMEMMemtoRegout, '1', gclock, MEMWBMemtoRegout);

	-- WB stage
	WBWriteData : mux_8_2 PORT MAP(MEMWBaluresultout, MEMWBRAMout, MEMWBMemtoRegout, WBWriteDataOut);
	-- output

	flags <= '0' & RegDst & Jump & MemRead & MemtoReg & AluOp1 & AluOp0 & alusrc;

	muxoutput : mux8_3 PORT MAP(PCout, aluresultout, readdata1out, readdata2out, WBWriteDataOut, flags, valueselect, muxout);
	instructionoutput : mux32_3 PORT MAP(InstructionOut1, InstructionOut2, InstructionOut3, InstructionOut4, InstructionOut5, "00000000000000000000000000000000", instrselect, instructionout);
	branchout <= branch;
	zeroout <= zero;
	memwriteout <= memWrite;
	regwriteout <= regWrite;

END ARCHITECTURE arch_top;