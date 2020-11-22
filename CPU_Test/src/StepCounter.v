`timescale 1ns / 1ps

module StepCounter (
    input Clk,
    input Rst,
    output [2:0]Step,
    input StepCounterReset
    );
    reg [2:0]Counter_d,Counter_q = 3'b0;

    assign Step = Counter_q;

    always @ (*) begin
        Counter_d = Counter_q + 1'b1;  //increase the counter by 1
    end

    always @ (posedge Clk) begin
        if(Rst)begin                     //if reset is high
          Counter_q <= 3'b0;              //set the counter to zero
        end else if(StepCounterReset)begin
          Counter_q <= 3'b0;              //set the counter to zero
        end else begin
          Counter_q <= Counter_d;
        end
    end
endmodule
