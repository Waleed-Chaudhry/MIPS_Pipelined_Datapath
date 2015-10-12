//-----------------------------------------------------
// Design Name : Assignment 3
// File Name : mainControl.v
// Function : This file handles the main Control of the Processor
// Coder    : Waleed Chaudhry
//--------------

module mainControl(opCode, controlData);
	input wire [5:0] opCode;
	output reg [8:0] controlData;

	always @ (*) begin
		case(opCode)
		    6'b000000: controlData = 9'b100_100_010; //R-Type
		    6'b100000: controlData = 9'b011_110_000; //lb
		    default:   controlData = 9'b010_001_000; //sb

	 	endcase 
	end
endmodule