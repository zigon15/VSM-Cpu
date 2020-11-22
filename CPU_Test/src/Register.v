`timescale 1ns / 1ps

module Register #(parameter RegWidth = 16)(
    input Clk,
    input Rst,
    inout [15:0]Bus,
    input RegIn,
    input RegOut
    );
    reg [RegWidth-1:0] Reg_d, Reg_q = 'b0;

    assign Bus = RegOut?Reg_q:'bz;

    always @ ( * ) begin
      Reg_d = Reg_q;
      if(RegIn)begin
        Reg_d = Bus;
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
