`timescale 1ns / 1ps

module ALU(
    input Clk,
    input Rst,
    inout [15:0]Bus,
    input [15:0]Reg1,
    input [15:0]Reg2,
    input SumOut,
    input [2:0]Operation,
    output [1:0]Flags
    );
    reg [16:0] Reg = 17'b0;
    reg ZeroFlag = 1'b0;
    reg CarryFlag = 1'b0;
    assign Flags[0] = ZeroFlag;
    assign Flags[1]= CarryFlag;

    assign Bus = SumOut?Reg[15:0]:'bz;

    always @ (*) begin
        case (Operation)
          3'b000:Reg = Reg1 + Reg2;     //addition
          3'b001:Reg = Reg1 - Reg2;     //subtraction
          3'b010:Reg = Reg1 << Reg2;    //output is Reg1 bitshifted left Reg2 bits
          3'b011:Reg = Reg1 >> Reg2;    //output is Reg1 bitshifted right Reg2 bits
          3'b100:Reg = (Reg1 < Reg2)?8'b0:8'd1;     //if Reg1 is less than Reg2 return 0, else 1
          3'b101:Reg = (Reg1 > Reg2)?8'b0:8'd1;     //if Reg1 if greater than Reg2 return 0, else 1
          3'b110:Reg = Reg1 ^ Reg2;     //logical xor
          3'b111:Reg = !Reg1;           //logical not
        endcase

        if(Reg[16])begin
          CarryFlag = 1'b1;
        end else begin
          CarryFlag = 1'b0;
        end

        if((Reg | 17'b0) == 1'b0)begin
          ZeroFlag = 1'b1;
        end else begin
          ZeroFlag = 1'b0;
        end
    end
endmodule
