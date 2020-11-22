`timescale 1ns / 1ps

module TestBench_tb(
    );
    reg clk, rst = 1'b0;
    wire [15:0] Output;
    reg [15:0] ClockCount = 16'b0;

    CPU Core1(
        .Clk(clk),
        .Rst(rst),
        .Output(Output)
      );

    initial begin
      clk = 1'b0;
      rst = 1'b1;
      repeat(5) #10 clk = ~clk;
      rst = 1'b0;
      forever #10 clk = ~clk;
    end

    always @ (posedge clk) begin
      if (rst) begin
          ClockCount = 16'b0;
      end else begin
          ClockCount = ClockCount + 1'd1;
      end
    end
endmodule
