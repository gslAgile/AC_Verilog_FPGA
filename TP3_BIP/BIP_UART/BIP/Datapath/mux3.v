`timescale 1ns / 1ps
//////////////////////////////////////////////////////////////////////////////////
// Company: 
// Engineer: 
// 
// Create Date:    20:46:33 11/24/2016 
// Design Name: 
// Module Name:    mux3 
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
module mux3
(A,B,C,sel,salida);

	// Entradas modulo
	input wire [15:0] A, B, C;
	input wire [1:0] sel;
	
	// Salidas modulo
	output wire [15:0] salida;
	
	// Logica multiplexor
	assign salida =	(sel == 2'b00) ? A:
							(sel == 2'b01) ? B:
							(sel == 2'b10) ? C: 0;
							
endmodule
