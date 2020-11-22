`timescale 1ns / 1ps

module FlagsRegister(
    input Clk,
    input Rst,
    input FlagsRegIn,
    input [1:0] ALUFlagsIn,
    output [1:0] Flags
    );
    reg [1:0] Reg_d, Reg_q = 2'b0;

    assign Flags = Reg_q;

    always @ ( * ) begin
      Reg_d = Reg_q;
      if(FlagsRegIn)begin
        Reg_d = ALUFlagsIn;
      end
    end

    always @ (posedge Clk) begin
        if(Rst)begin
          Reg_q <= 'b0;
        end else begin
          Reg_q <= Reg_d;
        end
    end

endmodule
