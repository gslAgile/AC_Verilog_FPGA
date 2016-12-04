`timescale 1ns / 1ps
//////////////////////////////////////////////////////////////////////////////////
// Company: 
// Engineer: 
// 
// Create Date:    18:09:13 11/21/2016 
// Design Name: 
// Module Name:    CPU 
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
module CPU
(clk, reset, instruction, DM_in, AddrPM, AddrDM, ACC, Rd_out, Wr_out, Operand, SelA, SelB, Op, WrAcc);
	
	// Entradas modulo
	input wire clk, reset;
	input wire [15:0] instruction;
	input wire [15:0] DM_in;
	
	// Salidas modulo
	output wire [10:0] AddrPM;
	output wire [10:0] AddrDM;
	output wire [15:0] ACC;
	output wire Rd_out;
	output wire Wr_out;
	
	// Variables internas
	output wire [10:0] Operand;
	output wire WrAcc, SelB, Op;
	output wire [1:0] SelA;
	
	
	// Instanciacion Control
	Control C1(
		.clock(clk),
		.reset(reset),
		.Instruction(instruction),
		.SelA(SelA),
		.SelB(SelB),
		.Op(Op),
		.WrAcc(WrAcc),
		.WrRam(Wr_out),
		.RdRam(Rd_out),
		.Operand(Operand),
		.PC(AddrPM)
	);
	
	// Instanciacion Datapath
	Datapath2 D1(
		.clk(clk),
		.reset(reset),
		.Operand_in(Operand),
		.DM_in(DM_in),
		.SelA_in(SelA),
		.SelB_in(SelB),
		.WrAcc_in(WrAcc),
		.Op_in(Op),
		.ACC(ACC),
		.Operand_out(AddrDM)
	);
	

endmodule
