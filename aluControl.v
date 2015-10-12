//-----------------------------------------------------
// Design Name : Assignment 3
// File Name : aluControl.v
// Function : This file generates the ALU Operation Code
// Coder    : Waleed Chaudhry
//--------------

module aluControl (opCode, aluOp, aluOperation);
	input wire [5:0] opCode;
	input wire [1:0] aluOp;

	output reg [3:0] aluOperation;

	always @ (*) begin
		// $display("Value of aluOp is %b", aluOp);
		casex(aluOp) 
			2'b1x: begin //R-Type Instructions
		    	case(opCode)        
			        6'b100000: aluOperation = 4'b0010;    //Add
			        default: aluOperation = 4'b0110;    //Sub
		    	endcase
			end 
			// I-Type Instructions 
		    2'b00: begin // lw/sw Instuction
		        aluOperation = 4'b0010;
		    end
		endcase   
	end
endmodule