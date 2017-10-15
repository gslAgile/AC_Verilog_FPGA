`timescale 1ns / 1ps
//////////////////////////////////////////////////////////////////////////////////
// Company: 
// Engineer: 
// 
// Create Date:    17:33:04 11/21/2016 
// Design Name: 
// Module Name:    Control 
// Project Name: 
// Target Devices: 
// Tool versions: 
// Description: 
//
// Dependencies: 
//
// Revision: 
// Revision 0.01 - File Created
// Additional Comments: 
//
//////////////////////////////////////////////////////////////////////////////////
module Control
(
	input wire clock, 
	input wire reset,
	input wire [15:0] Instruction,

	output wire [1:0] SelA,
	output wire SelB,
	output wire WrAcc,
	output wire Op,
	output wire WrRam,
	output wire RdRam,	
	output reg [10:0] Operand,
	output reg [10:0] PC
);


wire [10:0] Result;
wire WrPC;

reg [4:0] Opcode;
reg [10:0] PC_next;
reg OpPC;
reg [10:0] Cte;

always@*
begin
	PC_next=PC;
	if(WrPC && Opcode > 0)
		PC_next=Result;
end

always@(posedge clock,posedge reset)
begin 
		if(reset)
		begin
			PC<=11'b00000000000;
			OpPC<=1;
			Cte<=11'b00000000001;
		end
		else
		begin
			PC<=PC_next;	
			Opcode<=Instruction[15:11];
			Operand<=Instruction[10:0];
		end
end

Instruction_decoder ID1
(		
		.WrPC(WrPC),
		.SelA(SelA),
		.SelB(SelB),
		.WrAcc(WrAcc),
		.Op(Op),
		.WrRam(WrRam),
		.RdRam(RdRam),
		.Opcode(Opcode)
);

bloque_BAU BAU1
(		
		.A(PC), 
		.B(Cte), 
		.Op(OpPC),
		.Result(Result)
);
	


endmodule
