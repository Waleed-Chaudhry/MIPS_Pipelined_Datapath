//-----------------------------------------------------
// Design Name : Mips_Processor
// File Name : MEM_stage.v
// Function : This file models the memory of the processor
// Coder    : Waleed Chaudhry
//--------------

module MEM_stage(address, writeData, memWrite, memRead, readData, clock);
	input wire signed [31:0] address;
	input wire signed [7:0] writeData;
	input wire memWrite;
	input wire memRead;

	input wire clock;
	reg [7:0] Main_Mem[0:1023];
	integer i;

	output reg signed [7:0] readData;

	initial begin
		for (i = 0; i < 1024; i = i +1) begin
			Main_Mem[i] = i[15:0];
		end
	end

	//Main Memory Read/Memory Write Functionality
	always @(*) begin
		if (memRead) begin
			readData = Main_Mem[address];	
		end

		if (memWrite) begin
			Main_Mem[address] =writeData;
		end

	end
endmodule