`timescale 1ns / 1ps
//////////////////////////////////////////////////////////////////////////////////
// Company: 
// Engineer: 
// 
// Create Date:    20:50:47 11/24/2016 
// Design Name: 
// Module Name:    Datapath2 
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
module Datapath2
(clk, reset, Operand_in, DM_in, SelA_in, SelB_in, WrAcc_in, Op_in, ACC, Operand_out);

	// Entradas modulo
	input wire clk, reset;
	input wire [10:0] Operand_in;
	input wire [15:0] DM_in;
	input wire [1:0] SelA_in;
	input wire SelB_in;
	input wire WrAcc_in;
	input wire Op_in;
	
	
	// Salidas modulo
	output reg [15:0] ACC; // registrio ACC
	output wire [10:0] Operand_out;
	
	//Parametro local
	localparam msb_BAU = 15;
	
	// Variables internas 
	wire [15:0] signal_ext; // Signal Extension
	wire [15:0] salida_mux3;
	wire [15:0] salida_mux2;
	reg [15:0] ACC_next;
	wire [15:0] result_BAU;
	
	assign signal_ext = {5'b00000, Operand_in};
	
	
	always@(posedge clk, posedge reset)
	begin
		if(reset)
			ACC <= 0;
		
		else
			ACC <= ACC_next;
	end
	
	// Instaciacion de multiplexor mux3
	mux3 m1(
		.A(DM_in),
		.B(signal_ext),
		.C(result_BAU),
		.sel(SelA_in),
		.salida(salida_mux3)
	);
	
	// Instaciacion de multiplexor mux2
	mux2 m2(
		.A(signal_ext),
		.B(DM_in),
		.sel(SelB_in),
		.salida(salida_mux2)
	);
	
	
	// Instanciacion de bloque BAU
	bloque_BAU #(.msb(msb_BAU)) // paso de parametro, 16 bits en este caso
	BAU1(
		.A(ACC),
		.B(salida_mux2),
		.Op(Op_in),
		.Result(result_BAU)
	);
	
	always@(*)
	begin
		ACC_next = ACC;
		if(WrAcc_in)
			ACC_next = salida_mux3;
	end

	// Salidas
	assign Operand_out = Operand_in;

endmodule
