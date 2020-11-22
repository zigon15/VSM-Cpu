`timescale 1ns / 1ps

module InstructionRegister(
    input Clk,
    input Rst,
    inout [15:0]Bus,
    input InstructionRegIn,
    input InstructionRegOut,
    output [4:0]OpCodeOut,
    output [10:0]IRData
    );
    reg [15:0] Reg = 16'b0;

    assign Bus = InstructionRegOut?Reg[10:0]:16'bz;
    assign OpCodeOut = Reg[15:11];
    assign IRData = Reg[10:0];

    always @ ( * ) begin
      if(InstructionRegIn)begin
        Reg = Bus;
      end
    end

    always @ (posedge Clk) begin
        if(Rst)begin
          Reg <= 16'b0;
        end
    end

endmodule
