//-----------------------------------------------------
// Design Name : Assignment 3
// File Name   : mux32bit.v
// Function    : 2:1 Multiplexer for a 32 bit number
// Coder       : Waleed Chaudhry
//-----------------------------------------------------
module mux32bit(in0, in1, sel, out);
	input wire [31:0] in0;
	input wire [31:0] in1;
	input wire sel ;
	output reg [31:0] out;

	always @ (*) begin
		case(sel) 
		    1'b0: out = in0;
		    1'b1: out = in1;
	 	endcase 
	end

endmodule