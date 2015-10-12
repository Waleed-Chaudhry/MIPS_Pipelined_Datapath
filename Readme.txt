The is the Readme file for a simplified version of the MIPS Pipelined Datapath

It implements R-Type and I-Type (loads and store) instructions
The lw and sw were simplified to lb and sb as per the specifications of the project
(the b refers to a byte as opposed a word, w)

I later changed the lb and sb to lw, sw and added branching instructions
The pipelined datapath was also enhanced to handle data hazards with full forwarding
The design was implemented on a Cyclone IV FPGA board using Quartus II

Test Program

sb $ 2, 0 ($8)
lb $10, -4 ($8)
add $3, $4, $3
add $7, $9, $6
add $9, $9, $2
lb $24, 0 ($8)
lb $17, 16($10)
sub $8, $3, $2

Initial Data Memory Configuration
The data memory was initialized to contain byte values from x00 to xFF 
in a recurring fashion

Initial Register Configuration
All Registers were set to 100 + register value

Result
The program prints out the correct register state (regular and pipeline) of the program at every clock cycle
Those states have been saved in Output.txt 
