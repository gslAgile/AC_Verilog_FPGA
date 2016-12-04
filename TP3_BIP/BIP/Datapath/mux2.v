`timescale 1ns / 1ps
//////////////////////////////////////////////////////////////////////////////////
// Company: 
// Engineer: 
// 
// Create Date:    20:40:10 11/24/2016 
// Design Name: 
// Module Name:    mux2 
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
module mux2
(A,B,sel,salida);

	// Entradas modulo
	input wire [15:0] A, B;
	input wire sel;
	
	// Salidas modulo
	output wire [15:0] salida;
	
	// Logica multiplexor
	assign salida = (sel) ? A: B;
	
endmodule
