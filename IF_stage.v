//-----------------------------------------------------
// Design Name : Assignment 3
// File Name : IF_stage.v
// Function : This file will model the IF stage
// Coder    : Waleed Chaudhry
//--------------

module IF_stage(address, instruction);
	
	//Declaring wires and registers
	input wire [31:0] address;
	output wire [31:0] instruction;

	reg [7:0] instructionMemory[0:51];

	//Initializing the memory Instructions
	initial begin

		{instructionMemory[0], instructionMemory[1], instructionMemory[2], instructionMemory[3]} =  
		32'ha1020000; //sb $ 2, 0 ($8)

		{instructionMemory[4], instructionMemory[5], instructionMemory[6], instructionMemory[7]} =  
		32'h810afffc; //lb $10, -4 ($8)

		{instructionMemory[8], instructionMemory[9], instructionMemory[10], instructionMemory[11]} = 
		32'h00831820; //add $3, $4, $3

		{instructionMemory[12], instructionMemory[13], instructionMemory[14], instructionMemory[15]} =  
		32'h01263820; //add $7, $9, $6

		{instructionMemory[16], instructionMemory[17], instructionMemory[18], instructionMemory[19]} =  
		32'h01224820; //add $9, $9, $2

		{instructionMemory[20], instructionMemory[21], instructionMemory[22], instructionMemory[23]} =  
		32'h81180000; //lb $24, 0 ($8)

		{instructionMemory[24], instructionMemory[25], instructionMemory[26], instructionMemory[27]} =  
		32'h81510010; //lb $17, 16($10)

		{instructionMemory[28], instructionMemory[29], instructionMemory[30], instructionMemory[31]} =  
		32'h00624022; //sub $8, $3, $2

		{instructionMemory[32], instructionMemory[33], instructionMemory[34], instructionMemory[35]} =  
		32'h0; //nop

		{instructionMemory[36], instructionMemory[37], instructionMemory[38], instructionMemory[39]} =  
		32'h0; //nop

		{instructionMemory[40], instructionMemory[41], instructionMemory[42], instructionMemory[43]} =  
		32'h0; //nop

		{instructionMemory[44], instructionMemory[45], instructionMemory[46], instructionMemory[47]} =  
		32'h0; //nop

		//Dummy halt instruction to stop the execution of the program
		{instructionMemory[48], instructionMemory[49], instructionMemory[50], instructionMemory[51]} =  
		32'hffffffff; //halt

	end

	assign instruction =  {instructionMemory[address], instructionMemory[address+1], instructionMemory[address+2],instructionMemory[address+3]};

endmodule