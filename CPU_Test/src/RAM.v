`timescale 1ns / 1ps

module Ram(
    input Clk,
    input Rst,
    inout [15:0]Bus,
    input [7:0]AddressIn,
    input RamIn,
    input RamOut
    );
    wire [15:0]DataOut;
    assign Bus = RamOut?DataOut:16'bz;

    RAM_256Byte RAM1 (
      .clka(~Clk), // input clka
      .rsta(Rst), // input rsta
      .ena(1'b1), // input ena
      .wea(RamIn), // input [0 : 0] wea
      .addra(AddressIn), // input [7 : 0] addra
      .dina(Bus), // input [15 : 0] dina
      .douta(DataOut) // output [15 : 0] douta
    );
endmodule
