`timescale 1ns / 1ps

module ProgramCounter(
    input Clk,
    input Rst,
    inout [15:0]Bus,
    input ProgramCounterOut,
    input Jump,
    input CountEnable
    );

    reg [7:0]Counter_d,Counter_q = 8'b0;
    assign Bus = ProgramCounterOut?{8'b0,Counter_q}:16'bz;

    always @ (*) begin
        Counter_d = Counter_q;
        if(Jump)begin           //if the jump bit is set
          Counter_d = Bus[7:0];          //set the counter to the 8 LSB on the bus
        end else if(CountEnable)begin    //if the count enable bit is set
          Counter_d = Counter_q + 1'b1;  //increase the counter by 1
        end
    end

    always @ (posedge Clk) begin
        if(Rst)begin                     //if reset is high
          Counter_q = 8'b0;              //set the counter to zero
        end else begin
          Counter_q <= Counter_d;
        end
    end
endmodule
