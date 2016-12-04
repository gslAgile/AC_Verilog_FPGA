`timescale 1ns / 1ps
//////////////////////////////////////////////////////////////////////////////////
// Company: 
// Engineer: 
// 
// Create Date:    20:21:02 11/20/2016 
// Design Name: 
// Module Name:    bloque_BAU 
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
module bloque_BAU
#(parameter msb=10)
(A,B,Op,Result);

// Entrada modulo
input wire [msb:0] A;
input wire [msb:0] B;
input wire Op;

// Salidas modulo
output reg signed [msb:0] Result; 

always @(*)
	case(Op)
		1: Result=A+B;//ADD
		0: Result=A-B;//SUB
		default: Result = 0;
	endcase
endmodule
