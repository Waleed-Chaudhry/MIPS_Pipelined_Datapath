//-----------------------------------------------------
// Design Name : Assignment 3
// File Name : IF_Stage.v
// Function : This file will decode the instruction
// Coder    : Waleed Chaudhry
//--------------

module ID_stage(readRegister1, readRegister2, writeRegister, writeData, regWrite, readData1, readData2, clock);
	input wire [4:0] readRegister1;
	input wire [4:0] readRegister2;
	input wire [4:0] writeRegister;

	input wire signed [31:0] writeData;
	input wire regWrite;
	output reg signed [31:0] readData1;
	output reg signed [31:0] readData2;

	
	reg [31:0] Regs[0:31];
	integer i;

	input clock;
	
	//Initializing the register memory
	initial begin
	Regs[0] = 0;
		for (i = 1; i < 32; i = i +1) begin
			Regs[i] = 32'h100 + i;
		end
	end


	//The Main Decode Step
	always @ (*) begin
		readData1 <= Regs[readRegister1];
		readData2 <= Regs[readRegister2];
	end

	always @ (writeData) begin
		if (regWrite) begin
			Regs[writeRegister] = writeData;	
		end
	end

	always @ (negedge clock) begin
	#10
		$display("The Register Values are");
		for (i = 0; i < 32; i = i +8) begin
			$display("%h, %h, %h, %h, %h, %h, %h, %h", 
			Regs[i],	Regs[i+1],Regs[i+2],Regs[i+3],
			Regs[i+4],Regs[i+5],Regs[i+6],Regs[i+7],);
		end
		$display("\n");
	end
endmodule