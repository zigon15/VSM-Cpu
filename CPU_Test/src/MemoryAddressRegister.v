`timescale 1ns / 1ps

module MemoryAddressRegister(
    input Clk,
    input Rst,
    inout [15:0]Bus,
    input RegIn,
    output [7:0]AddressOut
    );
    reg [7:0] Reg_d, Reg_q = 8'b0;

    assign AddressOut = Reg_q;

    always @ ( * ) begin
      Reg_d = Reg_q;
      if(RegIn)begin
        Reg_d = Bus[7:0];
      end
    end

    always @ (posedge Clk) begin
        if(Rst)begin
          Reg_q <= 8'b0;
        end else begin
          Reg_q <= Reg_d;
        end
    end

endmodule
