`timescale 1ns / 1ps

module ControlUnit(
    input Clk,
    input Rst,
    input StepCounterReset,
    input [1:0] FlagsRegister,
    input [4:0] OpCode,
    input [10:0] IRData,
    output [19:0]ControlWord
    );

    wire [2:0]Step;
    reg [4:0] OpCode_q = 8'b0;
    StepCounter  InstructionStepCounter(
        .Clk(Clk),
        .Rst(Rst),
        .Step(Step),
        .StepCounterReset(StepCounterReset)
      );

    InstructionDecoder  InstructionDecoder1(
        .Clk(Clk),
        .Rst(Rst),
        .FlagsRegister(FlagsRegister),
        .OpCode(OpCode_q),
        .IRData(IRData),
        .Step(Step),
        .ControlWord(ControlWord)
      );

      always @ (posedge Clk) begin
        OpCode_q <= OpCode;
      end
endmodule
