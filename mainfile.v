//-----------------------------------------------------
// Design Name : Assignment 3
// File Name : mainfile.v
// Function : This program will be the mainfile for the assignment
// Coder    : Waleed Chaudhry
//--------------
`include "secClock.v"
`include "mainControl.v"
`include "IF_stage.v"
`include "mux5bit.v"
`include "ID_stage.v"
`include "mux32bit.v"
`include "aluControl.v"
`include "EX_stage.v"
`include "MEM_stage.v"

module mainfile;

//Declaring wires and registers

//Step 0: Control
	wire clock;
	reg halt;
	integer cycleNumber;
	wire [8:0] controlSignals;

//Step 1: IF
	reg [31:0] address;
	wire [31:0] instruction;

	reg [31:0] IF_ID_Write;
	reg [31:0] IF_ID_Read;

//Step 2: ID
	wire [4:0] muxOut;

	wire regDst;
	wire regWrite;
	wire signed [31:0] writeData;
	wire signed [31:0] readData1;
	wire signed [31:0] readData2;
	wire signed [31:0] signedImmediate;

	reg [120:0] ID_EX_Write;
	reg [120:0] ID_EX_Read;

//Step 3
	wire aluScr;
	wire signed [31:0] mux2Out;
	wire [3:0] aluOperation;
	wire [1:0] aluOp;
	wire signed [31:0] aluResult;

	reg[49:0] EX_MEM_Read;
	reg[49:0] EX_MEM_Write;

assign regDst = ID_EX_Read[104];

assign aluScr = ID_EX_Read[103];
assign aluOp = ID_EX_Read[97:96];

//Step 4
	wire signed [7:0] readData;
	wire signed [31:0] mux3out;
	wire signed [31:0] signedReadData;
	wire memWrite;
	wire memRead;
	wire memToReg;

	reg[46:0] MEM_WB_Read;
	reg[46:0] MEM_WB_Write;

	assign memRead = EX_MEM_Read[36];
	assign memWrite = EX_MEM_Read[35];

//Step 5
	assign memToReg = MEM_WB_Read[46];
	assign regWrite = MEM_WB_Read[45];


assign signedReadData = {{24{MEM_WB_Read[44]}}, MEM_WB_Read[44:37]};

//Initializing the variables 
	initial begin
	// //Step 0
		cycleNumber = 1'd0;
		address = 32'h0;
		halt = 1'b0;
	end

//Step 0: Setting the clock and generating the control signals
	secClock getClock(halt,clock);

//Step 1: IF
	IF_stage step1(address, instruction);
	mainControl generateControl(IF_ID_Read[31:26], controlSignals);

//Step 2: ID
	ID_stage step2(IF_ID_Read[25:21], IF_ID_Read[20:16], MEM_WB_Read[4:0], writeData, regWrite, readData1, readData2, clock);
	assign signedImmediate = {{16{IF_ID_Read[15]}}, IF_ID_Read[15:0]};

//Step 3: EX
	mux5bit mux1(ID_EX_Read[120:116], ID_EX_Read[115:111], regDst, muxOut);
	mux32bit mux2(ID_EX_Read[63:32], ID_EX_Read[31:0], aluScr, mux2Out);
	aluControl control2(ID_EX_Read[110:105], aluOp, aluOperation);

	EX_stage step3(aluOperation, ID_EX_Read[95:64], mux2Out, aluResult);

//Step 4: Reading to and Writing From Memory
	MEM_stage step4(EX_MEM_Read[31:0], EX_MEM_Read[44:37], memWrite, memRead, readData,clock);

//Step 5: Write Back
	mux32bit mux3(MEM_WB_Read[36:5], signedReadData, memToReg, writeData);


	always @ (posedge clock) begin
		address <= address + 4;
		cycleNumber <= cycleNumber + 1;

		//IF_stage();
		IF_ID_Write <= instruction;
		IF_ID_Read <= IF_ID_Write;

		#1 //ID_stage();
		ID_EX_Write <= {IF_ID_Read[20:16], IF_ID_Read[15:11], IF_ID_Read [5:0], controlSignals,readData1,readData2, signedImmediate};
		ID_EX_Read <= ID_EX_Write;

		#1 //EX_stage();
		EX_MEM_Write <= {muxOut,ID_EX_Read[39:32],ID_EX_Read[100:98],ID_EX_Read[102:101],aluResult};
		EX_MEM_Read <= EX_MEM_Write;

		#1 //MEM_stage();
		MEM_WB_Write <= {EX_MEM_Read[33:32], readData,EX_MEM_Read[31:0],EX_MEM_Read[49:45]};
		MEM_WB_Read <= MEM_WB_Write;
	end

	always @(negedge clock) begin
		$display("Clock Cycle %d \n", cycleNumber);		
		$display("IF/ID Write");
		$display("Inst = %h \n", IF_ID_Write[31:0]);

		$display("IF/ID Read");
		$display("Inst = %h \n", IF_ID_Read[31:0]);

		$display("ID/EX Write");
		$display("Control: RegDst = %b, ALUSrc = %b, ALUOp = %b, MemRead = %h, MemWrite = %h", ID_EX_Write[104], ID_EX_Write[103], ID_EX_Write[97:96], ID_EX_Write[100], ID_EX_Write[99]);
		$display("Branch = %b, MemToReg = %b, regWrite = %b \n", ID_EX_Write[98], ID_EX_Write[102], ID_EX_Write[101]);
		
		$display("ReadReg1Value = %h, ReadReg2Value = %h, SEOffset = %h", ID_EX_Write[95:64], ID_EX_Write[63:32], ID_EX_Write[31:0]);
		$display("WriteReg_20_16 = %d, WriteReg_15_11 = %d, Function = %h \n", ID_EX_Write[120:116], ID_EX_Write[115:111],ID_EX_Write[110:105]);

		$display("ID/EX Read");
		$display("Control: RegDst = %b, ALUSrc = %b, ALUOp = %b, MemRead = %h, MemWrite = %h", ID_EX_Read[104], ID_EX_Read[103], ID_EX_Read[97:96], ID_EX_Read[100], ID_EX_Read[99]);
		$display("Branch = %b, MemToReg = %b, RegWrite = %b \n", ID_EX_Read[98], ID_EX_Read[102], ID_EX_Read[101]);
		
		$display("ReadReg1Value = %h, ReadReg2Value = %h, SEOffset = %h", ID_EX_Read[95:64], ID_EX_Read[63:32], ID_EX_Read[31:0]);
		$display("WriteReg_20_16 = %d, WriteReg_15_11 = %d, Function = %h \n", ID_EX_Read[120:116], ID_EX_Read[115:111],ID_EX_Read[110:105]);

		$display("EX/MEM Write");
		$display("Control: MemRead = %b, MemWrite = %b, Branch = %b, MemToReg = %b, RegWrite %b", EX_MEM_Write[36],EX_MEM_Write[35],EX_MEM_Write[34],EX_MEM_Write[33],EX_MEM_Write[32]);
		$display("SWB = %h, WriteRegNum = %d, ALUResult = %h \n", EX_MEM_Write[44:37],EX_MEM_Write[49:45],EX_MEM_Write[31:0]);

		$display("EX/MEM Read");
		$display("Control: MemRead = %b, MemWrite = %b, Branch = %b, MemToReg = %b, RegWrite %b", EX_MEM_Read[36],EX_MEM_Read[35],EX_MEM_Read[34],EX_MEM_Read[33],EX_MEM_Read[32]);
		$display("SWB = %h, WriteRegNum = %d, ALUResult = %h \n", EX_MEM_Read[44:37],EX_MEM_Read[49:45],EX_MEM_Read[31:0]);
		
		$display("MEM/WB Write");
		$display("Control: = MemToReg = %b, RegWrite = %b", MEM_WB_Write[46],MEM_WB_Write[45]);
		$display("LWB = %h, ALUResult = %h, WriteRegNum = %d \n", MEM_WB_Write[44:37], MEM_WB_Write[36:5],MEM_WB_Write[4:0]);

		$display("MEM/WB Read");
		$display("Control: = MemToReg = %b, RegWrite = %b", MEM_WB_Read[46],MEM_WB_Read[45]);
		$display("LVDataValue = %h, ALUResult = %h, WriteRegNum = %d \n", MEM_WB_Read[44:37], MEM_WB_Read[36:5],MEM_WB_Read[4:0]);
		halt <= &instruction;
	end

endmodule