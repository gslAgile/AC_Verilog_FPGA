`timescale 1ns / 1ps
//////////////////////////////////////////////////////////////////////////////////
// Company: 
// Engineer: 
// 
// Create Date:    21:14:32 09/22/2016 
// Design Name: 
// Module Name:    bloque_ALU 
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
//`include"definiciones.vh"

`define ADD  6'b100000
`define SUB  6'b100010
`define AND  6'b100100
`define OR   6'b100101
`define XOR  6'b100110
`define SRA  6'b000011
`define SRL  6'b000010
`define NOR  6'b100111

module bloque_ALU
#(parameter nbits = 8) // Parametros externos, de instanciacion
(buf_A, buf_B, buf_Op, dato_R); // cambiar a buf_R en forma 1

// Parametros internos
localparam msb = nbits-1;// bit mas significativo

// Entradas de ALU
input wire signed[msb:0] buf_A, buf_B;
input wire [5:0] buf_Op;

// Salida de ALU
//output wire signed [msb:0] buf_R; // puede ser reg dato_R para forma 2.

// Circuito puramente combinacional forma 1:
//		assign buf_R = (buf_Op==`ADD) ? buf_A+buf_B:// ADD
//							(buf_Op==`SUB) ? buf_A-buf_B:// SUB
//							(buf_Op==`AND) ? buf_A&buf_B:// AND
//							(buf_Op==`OR) ? buf_A|buf_B://OR	
//							(buf_Op==`XOR) ? buf_A^buf_B:// XOR
//							(buf_Op==`SRA & buf_A[msb]== 1) ? buf_A >>> (buf_B&8'b00011111): // SRA -> Se Se realiza ANDing para no superar 31 avances
//							(buf_Op==`SRA & buf_A[msb]== 0) ? buf_A >> (buf_B&8'b00011111):
//							(buf_Op==`SRL) ? {0,buf_A} >> buf_B:// SRL
//							(buf_Op==`NOR) ? ~(buf_A|buf_B): 0;// NOR

// Circuito puramente combinacional forma 2:
// con
// Salida de ALU
output reg [msb:0] dato_R;

always@(*)
begin
	case(buf_Op)
		6'b100000: dato_R = buf_A+buf_B;// ADD
		6'b100010: dato_R = buf_A-buf_B;// SUB
		6'b100100: dato_R = buf_A&buf_B;// AND
		6'b100101: dato_R = buf_A|buf_B;//OR	
		6'b100110: dato_R = buf_A^buf_B;// XOR
		6'b000011: dato_R = buf_A >>> (buf_B&8'b00011111); // SRA -> Se Se realiza ANDing para no superar 31
		6'b000010: dato_R = {0,buf_A} >> buf_B;//buf_B;// SRL
		6'b100111: dato_R = ~(buf_A|buf_B);// NOR
		default: dato_R = 0;
	endcase
end

endmodule
