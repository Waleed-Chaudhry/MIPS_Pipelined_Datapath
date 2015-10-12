//-----------------------------------------------------
// Design Name : Assignment 3
// File Name : EX_Stage.v
// Function : This file models the ALU
// Coder    : Waleed Chaudhry
//--------------

module EX_stage(aluOperation, readData1, mux2Out, aluResult);
	input wire [3:0] aluOperation;
	input wire signed [31:0] readData1;
	input wire signed [31:0] mux2Out;

	output reg signed [31:0] aluResult;

	always @ (*) begin
		case(aluOperation) 
			4'b0110: aluResult = readData1 - mux2Out; //sub
		    default: aluResult = readData1 + mux2Out; //add
	 	endcase 
	end
endmodule