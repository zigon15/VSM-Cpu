`timescale 1ns / 1ps

module CPU(
		input Clk,
		input Rst,
		output [15:0] Output
    );

		//Location of various control bits in the control word
		parameter PCO = 0;
		parameter J = 1;
		parameter PCE = 2;
		parameter MI = 3;
		parameter RI = 4;
		parameter RO = 5;
		parameter AI = 6;
		parameter AO = 7;
		parameter EO = 8;
		parameter OP0 = 9;
		parameter OP1 = 10;
		parameter OP2 = 11;
		parameter II = 12;
		parameter IO = 13;
		parameter BI = 14;
		parameter BO = 15;
		parameter SR = 16;
		parameter FI = 17;
		parameter CI = 18;
		parameter CO = 19;

		wire [19:0]ControlWord;
		wire [15:0]Bus;

		wire [15:0] ALU_REG1;
		wire [15:0] ALU_REG2;
		wire [7:0] RAM_ADDRESS;
		wire [4:0] OP_CODE;
		wire [1:0] ALU_FLAGS;
		wire [1:0] CPU_FLAGS;
		wire [10:0] IRData;

		ProgramCounter PC(
			.Clk(Clk),
			.Rst(Rst),
			.Bus(Bus),
			.ProgramCounterOut(ControlWord[PCO]),
			.Jump(ControlWord[J]),
			.CountEnable(ControlWord[PCE])
			);

		ALURegister #(.RegWidth(16)) A_Register(
			.Clk(Clk),
			.Rst(Rst),
			.Bus(Bus),
			.RegIn(ControlWord[AI]),
			.RegOut(ControlWord[AO]),
			.RegOutALU(ALU_REG1)
			);

		ALU ALU1(
			.Clk(Clk),
			.Rst(Rst),
			.Bus(Bus),
			.Reg1(ALU_REG1),
			.Reg2(ALU_REG2),
			.SumOut(ControlWord[EO]),
			.Operation(ControlWord[OP2:OP0]),
			.Flags(ALU_FLAGS)
			);

		ALURegister #(.RegWidth(16)) B_Register(
			.Clk(Clk),
			.Rst(Rst),
			.Bus(Bus),
			.RegIn(ControlWord[BI]),
			.RegOut(ControlWord[BO]),
			.RegOutALU(ALU_REG2)
			);

		OutputRegister #(.RegWidth(16)) C_Register(
			.Clk(Clk),
			.Rst(Rst),
			.Bus(Bus),
			.RegIn(ControlWord[CI]),
			.RegOut(ControlWord[CO]),
			.RegOutput(Output)
			);

		MemoryAddressRegister MAR(
			.Clk(Clk),
			.Rst(Rst),
			.Bus(Bus),
			.RegIn(ControlWord[MI]),
			.AddressOut(RAM_ADDRESS)
			);

		Ram RAM1(
			.Clk(Clk),
			.Rst(Rst),
			.Bus(Bus),
			.AddressIn(RAM_ADDRESS),
			.RamIn(ControlWord[RI]),
			.RamOut(ControlWord[RO])
			);

		InstructionRegister IR(
			.Clk(Clk),
			.Rst(Rst),
			.Bus(Bus),
			.InstructionRegIn(ControlWord[II]),
			.InstructionRegOut(ControlWord[IO]),
			.OpCodeOut(OP_CODE),
			.IRData(IRData)
			);

		FlagsRegister FR(
			.Clk(Clk),
			.Rst(Rst),
			.FlagsRegIn(ControlWord[FI]),
			.ALUFlagsIn(ALU_FLAGS),
			.Flags(CPU_FLAGS)
			);

		ControlUnit CU(
			.Clk(Clk),
			.Rst(Rst),
			.StepCounterReset(ControlWord[SR]),
			.FlagsRegister(CPU_FLAGS),
			.OpCode(OP_CODE),
			.ControlWord(ControlWord),
			.IRData(IRData)
			);

endmodule
