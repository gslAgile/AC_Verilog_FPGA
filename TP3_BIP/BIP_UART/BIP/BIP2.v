`timescale 1ns / 1ps
//////////////////////////////////////////////////////////////////////////////////
// Company: 
// Engineer: 
// 
// Create Date:    13:09:28 11/25/2016 
// Design Name: 
// Module Name:    BIP2 
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
module BIP2
(clk, reset, ACC, instruction, PC);
	
	// Entradas modulo
	input clk, reset;
	
	// Salidas modulo
	//output wire [15:0] result;
	
	// Variables internas
	wire Rd, Wr;
	output wire [15:0] instruction;
	wire [10:0] AddrPM, AddrDM;
	output wire [15:0] ACC;
	wire [15:0] Out_data;
	output wire [10:0] PC;
	
	
	
	// Instanciacion de PM
	program_memory PM(
		.clk(clk), 
		.reset(reset),
		.Addr(AddrPM),
		.Data(instruction)
	);
	
	
	// Instanciacion de DM
	data_memory2 DM(
		.clk(clk),
		.reset(reset),
		.Rd(Rd),
		.Wr(Wr),
		.Addr(AddrDM),
		.In_data(ACC),
		.Out_data(Out_data)
	);
	
	// Instanciacion de CPU
	CPU CPU1(
		.clk(clk),
		.reset(reset),
		.instruction(instruction),
		.DM_in(Out_data),
		.AddrPM(AddrPM),
		.AddrDM(AddrDM),
		.ACC(ACC),
		.Rd_out(Rd),
		.Wr_out(Wr)
	);
	
	assign PC = AddrPM;
	 
endmodule
