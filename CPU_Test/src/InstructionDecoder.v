`timescale 1ns / 1ps

module InstructionDecoder (
    input Clk,
    input Rst,
    input [1:0] FlagsRegister,
    input [4:0] OpCode,
    input [10:0] IRData,
    input [2:0] Step,
    output reg [19:0]ControlWord
    );

    //control word bit layout
    parameter PCO = 20'b00000000000000000001;   //Program counter out
    parameter J   = 20'b00000000000000000010;   //Jump (Program counter in)
    parameter PCE = 20'b00000000000000000100;   //Program counter enable (Increment)
    parameter MI  = 20'b00000000000000001000;   //Memory address register in
    parameter RI  = 20'b00000000000000010000;   //RAM in
    parameter RO  = 20'b00000000000000100000;   //RAM out
    parameter AI  = 20'b00000000000001000000;   //A register in
    parameter AO  = 20'b00000000000010000000;   //A register out
    parameter EO  = 20'b00000000000100000000;   //Sum out
    parameter OP0 = 20'b00000000001000000000;   //ALU Operation Bit 0
    parameter OP1 = 20'b00000000010000000000;   //ALU Operation Bit 1
    parameter OP2 = 20'b00000000100000000000;   //ALU Operation Bit 2
    parameter II  = 20'b00000001000000000000;   //Instruction register in
    parameter IO  = 20'b00000010000000000000;   //Instruction register out
    parameter BI  = 20'b00000100000000000000;   //B register in
    parameter BO  = 20'b00001000000000000000;   //B register out
    parameter SR  = 20'b00010000000000000000;   //Step Counter Reset
    parameter FI  = 20'b00100000000000000000;   //Flags register in
    parameter CI  = 20'b01000000000000000000;   //C register in
    parameter CO  = 20'b10000000000000000000;   //C register out

    //all the various varible that choose the control word
    //the 2 flags, 2 bits
    parameter CarryFlagSet = 2'b10;
    parameter ZeroFlagSet = 2'b01;
    //8 steps , 3 bits
    parameter S0 = 3'd0;
    parameter S1 = 3'd1;
    parameter S2 = 3'd2;
    parameter S3 = 3'd3;
    parameter S4 = 3'd4;
    parameter S5 = 3'd5;
    parameter S6 = 3'd6;
    parameter S7 = 3'd7;

    //up to 32 instructions, 5 bits
    parameter NOP = 5'b00000;      //No operation

    //register operations
    parameter LDA =  5'b00001;      //load data into register A from the address specified by the 8LSB in the 16bit instruction
    parameter LDB =  5'b00010;      //load data into register B from the address specified by the 8LSB in the 16bit instruction
    parameter LDC =  5'b00011;      //load data into register C from the address specified by the 8LSB in the 16bit instruction

    parameter LIA =  5'b00100;      //load the data specified by the 11LSB in the 16bit instruction into the A Register
    parameter LIB =  5'b00101;      //load the data specified by the 11LSB in the 16bit instruction into the B Register
    parameter LIC =  5'b00110;      //load the data specified by the 11LSB in the 16bit instruction into the C Register

    parameter STA =  5'b00111;      //stores the data present in A register in the address specified by the 8LSB
    parameter STB =  5'b01000;      //stores the data present in B register in the address specified by the 8LSB
    parameter STC =  5'b01001;      //stores the data present in C register in the address specified by the 8LSB

    parameter MOV =  5'b01010;      //moves data from one register to another depending on the 3 LSB, 000 A->B,001 A->C,010 B->A, 011 B->C, 100 C->A, 101 C->B

    //ALU operations
    parameter ADD =  5'b01011;      //add what ever is in the memory address specified by the 8LSB in the 16bit instruction and store it in the A register
    parameter SUB =  5'b01100;      //subtract what ever is in the memory address specified by the 8LSB in the 16bit instruction and store it in the A register

    //branch operations
    parameter JMP =  5'b01101;      //set the program counter to what ever is specified by the 8LSB in the 16 bit instruction
    parameter JMPZ = 5'b01110;     //set the program counter to whatever is specified by the 8LSB if the ALU value is zero
    parameter JMPL = 5'b01111;     //set the program counter to what ever is specified by the 8LSB in the 16bit instruction if the value in the A register is less than the value in the B register
    parameter JMPG = 5'b10000;     //set the program counter to what ever is specified by the 8LSB in the 16bit instruction if the value in the A register is greater than the value in the B register


    //commands that don't use the flags register
    always @ ( * ) begin
        case (OpCode)
          NOP:begin
              case (Step)
                S0:ControlWord = MI|PCO;
                S1:ControlWord = RO|II|PCE;
                S2:ControlWord = SR;
                S3:ControlWord = 20'b0;
                S4:ControlWord = 20'b0;
                S5:ControlWord = 20'b0;
                S6:ControlWord = 20'b0;
                S7:ControlWord = 20'b0;
              endcase
          end

          //register operations-------------------------------------------------
          LDA:begin
              case (Step)
                S0:ControlWord = MI|PCO;
                S1:ControlWord = RO|II|PCE;
                S2:ControlWord = MI|IO;
                S3:ControlWord = RO|AI|SR;
                S4:ControlWord = 20'b0;
                S5:ControlWord = 20'b0;
                S6:ControlWord = 20'b0;
                S7:ControlWord = 20'b0;
              endcase
          end
          LDB:begin
              case (Step)
                S0:ControlWord = MI|PCO;
                S1:ControlWord = RO|II|PCE;
                S2:ControlWord = MI|IO;
                S3:ControlWord = RO|BI|SR;
                S4:ControlWord = 20'b0;
                S5:ControlWord = 20'b0;
                S6:ControlWord = 20'b0;
                S7:ControlWord = 20'b0;
              endcase
          end
          LDC:begin
              case (Step)
                S0:ControlWord = MI|PCO;
                S1:ControlWord = RO|II|PCE;
                S2:ControlWord = MI|IO;
                S3:ControlWord = RO|CI|SR;
                S4:ControlWord = 20'b0;
                S5:ControlWord = 20'b0;
                S6:ControlWord = 20'b0;
                S7:ControlWord = 20'b0;
              endcase
          end
          LIA:begin
              case (Step)
                S0:ControlWord = MI|PCO;
                S1:ControlWord = RO|II|PCE;
                S2:ControlWord = IO|AI|SR;
                S3:ControlWord = 20'b0;
                S4:ControlWord = 20'b0;
                S5:ControlWord = 20'b0;
                S6:ControlWord = 20'b0;
                S7:ControlWord = 20'b0;
              endcase
          end
          LIB:begin
              case (Step)
                S0:ControlWord = MI|PCO;
                S1:ControlWord = RO|II|PCE;
                S2:ControlWord = IO|BI|SR;
                S3:ControlWord = 20'b0;
                S4:ControlWord = 20'b0;
                S5:ControlWord = 20'b0;
                S6:ControlWord = 20'b0;
                S7:ControlWord = 20'b0;
              endcase
          end
          LIC:begin
              case (Step)
                S0:ControlWord = MI|PCO;
                S1:ControlWord = RO|II|PCE;
                S2:ControlWord = IO|CI|SR;
                S3:ControlWord = 20'b0;
                S4:ControlWord = 20'b0;
                S5:ControlWord = 20'b0;
                S6:ControlWord = 20'b0;
                S7:ControlWord = 20'b0;
              endcase
          end
          STA:begin
              case (Step)
                S0:ControlWord = MI|PCO;
                S1:ControlWord = RO|II|PCE;
                S2:ControlWord = MI|IO;
                S3:ControlWord = AO|RI|SR;
                S4:ControlWord = 20'b0;
                S5:ControlWord = 20'b0;
                S6:ControlWord = 20'b0;
                S7:ControlWord = 20'b0;
              endcase
          end
          STB:begin
              case (Step)
                S0:ControlWord = MI|PCO;
                S1:ControlWord = RO|II|PCE;
                S2:ControlWord = MI|IO;
                S3:ControlWord = BO|RI|SR;
                S4:ControlWord = 20'b0;
                S5:ControlWord = 20'b0;
                S6:ControlWord = 20'b0;
                S7:ControlWord = 20'b0;
              endcase
          end
          STC:begin
              case (Step)
                S0:ControlWord = MI|PCO;
                S1:ControlWord = RO|II|PCE;
                S2:ControlWord = MI|IO;
                S3:ControlWord = BO|RI|SR;
                S4:ControlWord = 20'b0;
                S5:ControlWord = 20'b0;
                S6:ControlWord = 20'b0;
                S7:ControlWord = 20'b0;
              endcase
          end
          MOV:begin
              case (Step)
                S0:ControlWord = MI|PCO;
                S1:ControlWord = RO|II|PCE;
                S2:begin
                  case (IRData[2:0])
                    3'b000:ControlWord = AO|BI|SR;  //A->B
                    3'b001:ControlWord = AO|CI|SR;  //A->C
                    3'b010:ControlWord = BO|AI|SR;  //B->A
                    3'b011:ControlWord = BO|CI|SR;  //B->C
                    3'b100:ControlWord = CO|AI|SR;  //C->A
                    3'b101:ControlWord = CO|BI|SR;  //C->B
                  endcase
                end
                S3:ControlWord = 20'b0;
                S4:ControlWord = 20'b0;
                S5:ControlWord = 20'b0;
                S6:ControlWord = 20'b0;
                S7:ControlWord = 20'b0;
              endcase
          end

          //ALU operations------------------------------------------------------
          ADD:begin
              case (Step)
                S0:ControlWord = MI|PCO;
                S1:ControlWord = RO|II|PCE;
                S2:ControlWord = MI|IO;
                S3:ControlWord = RO|BI;
                S4:ControlWord = AI|EO|SR|FI;
                S5:ControlWord = 20'b0;
                S6:ControlWord = 20'b0;
                S7:ControlWord = 20'b0;
              endcase
          end
          SUB:begin
              case (Step)
                S0:ControlWord = MI|PCO;
                S1:ControlWord = RO|II|PCE;
                S2:ControlWord = MI|IO;
                S3:ControlWord = RO|BI;
                S4:ControlWord = AI|EO|SR|OP0|FI;
                S5:ControlWord = 20'b0;
                S6:ControlWord = 20'b0;
                S7:ControlWord = 20'b0;
              endcase
          end

          //Branch Operations---------------------------------------------------
          JMP:begin
              case (Step)
                S0:ControlWord = MI|PCO;
                S1:ControlWord = RO|II|PCE;
                S2:ControlWord = IO|J|SR;
                S3:ControlWord = 20'b0;
                S4:ControlWord = 20'b0;
                S5:ControlWord = 20'b0;
                S6:ControlWord = 20'b0;
                S7:ControlWord = 20'b0;
              endcase
          end
        endcase
    end

    //Instructions that use the flags register
    always @ (*) begin
        case (FlagsRegister)
          2'b00:begin
              case (OpCode)
                JMPZ:begin
                    case (Step)
                      S0:ControlWord = MI|PCO;
                      S1:ControlWord = RO|II|PCE;
                      S2:ControlWord = SR;
                      S3:ControlWord = 20'b0;
                      S4:ControlWord = 20'b0;
                      S5:ControlWord = 20'b0;
                      S6:ControlWord = 20'b0;
                      S7:ControlWord = 20'b0;
                    endcase
                end
                JMPL:begin
                    case (Step)
                      S0:ControlWord = MI|PCO;
                      S1:ControlWord = RO|II|PCE;
                      S2:ControlWord = OP2|FI;   //set the the alu operation to less than
                      S3:ControlWord = SR;
                      S4:ControlWord = 20'b0;
                      S5:ControlWord = 20'b0;
                      S6:ControlWord = 20'b0;
                      S7:ControlWord = 20'b0;
                    endcase
                end
                JMPG:begin
                    case (Step)
                      S0:ControlWord = MI|PCO;
                      S1:ControlWord = RO|II|PCE;
                      S2:ControlWord = OP2|OP0|FI;  //set the the alu operation to greater than
                      S3:ControlWord = SR;
                      S4:ControlWord = 20'b0;
                      S5:ControlWord = 20'b0;
                      S6:ControlWord = 20'b0;
                      S7:ControlWord = 20'b0;
                    endcase
                end
              endcase
          end
          //--------------------------------------------------------------------------------------//
          CarryFlagSet:begin  //if the CarryFlag is set
              case (OpCode)
                JMPZ:begin
                    case (Step)
                      S0:ControlWord = MI|PCO;
                      S1:ControlWord = RO|II|PCE;
                      S2:ControlWord = SR;
                      S3:ControlWord = 20'b0;
                      S4:ControlWord = 20'b0;
                      S5:ControlWord = 20'b0;
                      S6:ControlWord = 20'b0;
                      S7:ControlWord = 20'b0;
                    endcase
                end
                JMPL:begin
                    case (Step)
                      S0:ControlWord = MI|PCO;
                      S1:ControlWord = RO|II|PCE;
                      S2:ControlWord = OP2|FI;    //set the the alu operation to less than
                      S3:ControlWord = SR;
                      S4:ControlWord = 20'b0;
                      S5:ControlWord = 20'b0;
                      S6:ControlWord = 20'b0;
                      S7:ControlWord = 20'b0;
                    endcase
                end
                JMPG:begin
                    case (Step)
                      S0:ControlWord = MI|PCO;
                      S1:ControlWord = RO|II|PCE;
                      S2:ControlWord = OP2|OP0|FI;  //set the the alu operation to greater than
                      S3:ControlWord = SR;
                      S4:ControlWord = 20'b0;
                      S5:ControlWord = 20'b0;
                      S6:ControlWord = 20'b0;
                      S7:ControlWord = 20'b0;
                    endcase
                end
              endcase
          end
          //--------------------------------------------------------------------------------------//
          ZeroFlagSet:begin   //if the Zero Flag is set
              case (OpCode)
                JMPZ:begin
                    case (Step)
                      S0:ControlWord = MI|PCO;
                      S1:ControlWord = RO|II|PCE;
                      S2:ControlWord = IO|J|SR;
                      S3:ControlWord = 20'b0;
                      S4:ControlWord = 20'b0;
                      S5:ControlWord = 20'b0;
                      S6:ControlWord = 20'b0;
                      S7:ControlWord = 20'b0;
                    endcase
                end
              JMPL:begin
                    case (Step)
                      S0:ControlWord = MI|PCO;
                      S1:ControlWord = RO|II|PCE;
                      S2:ControlWord = OP2|FI;      //set the the alu operation to less than
                      S3:ControlWord = IO|J|SR;
                      S4:ControlWord = 20'b0;
                      S5:ControlWord = 20'b0;
                      S6:ControlWord = 20'b0;
                      S7:ControlWord = 20'b0;
                    endcase
                end
                JMPG:begin
                    case (Step)
                      S0:ControlWord = MI|PCO;
                      S1:ControlWord = RO|II|PCE;
                      S2:ControlWord = OP2|OP0|FI;   //set the the alu operation to greater than
                      S3:ControlWord = IO|J|SR;
                      S4:ControlWord = 20'b0;
                      S5:ControlWord = 20'b0;
                      S6:ControlWord = 20'b0;
                      S7:ControlWord = 20'b0;
                    endcase
                end
              endcase
          end
          //--------------------------------------------------------------------------------------//
          (ZeroFlagSet & CarryFlagSet):begin   //if both the zero and carry flag are set
              case (OpCode)
                JMPZ:begin
                    case (Step)
                      S0:ControlWord = MI|PCO;
                      S1:ControlWord = RO|II|PCE;
                      S2:ControlWord = IO|J|SR;
                      S3:ControlWord = 20'b0;
                      S4:ControlWord = 20'b0;
                      S5:ControlWord = 20'b0;
                      S6:ControlWord = 20'b0;
                      S7:ControlWord = 20'b0;
                    endcase
                end
                JMPL:begin
                    case (Step)
                      S0:ControlWord = MI|PCO;
                      S1:ControlWord = RO|II|PCE;
                      S2:ControlWord = OP2|FI;     //set the the alu operation to less than
                      S3:ControlWord = IO|J|SR;
                      S4:ControlWord = 20'b0;
                      S5:ControlWord = 20'b0;
                      S6:ControlWord = 20'b0;
                      S7:ControlWord = 20'b0;
                    endcase
                end
                JMPG:begin
                    case (Step)
                      S0:ControlWord = MI|PCO;
                      S1:ControlWord = RO|II|PCE;
                      S2:ControlWord = OP2|OP0|FI;   //set the the alu operation to greater than
                      S3:ControlWord = IO|J|SR;
                      S4:ControlWord = 20'b0;
                      S5:ControlWord = 20'b0;
                      S6:ControlWord = 20'b0;
                      S7:ControlWord = 20'b0;
                    endcase
                end
              endcase
          end
        endcase
    end
endmodule
