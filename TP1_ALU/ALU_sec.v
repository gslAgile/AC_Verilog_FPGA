`timescale 1ns / 1ps
//////////////////////////////////////////////////////////////////////////////////
// Company: 
// Engineer: 
// 
// Create Date:    19:15:27 09/15/2016 
// Design Name: 
// Module Name:    ALU_sec 
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
module ALU_sec
#(parameter msb = 7)
(buf_A, buf_B, buf_Op, p_a, p_b, p_c, buf_R);
	
	// Buffers de entrdas de ALU (switches)
	input [msb:0] buf_A, buf_B;
	input [5:0] buf_Op;
	
	// Entradas de seleccion de Buffer (pulsadores)
	input wire p_a, p_b, p_c;
	
	// Registros de memoria ALU (registros internos)
	reg signed [msb:0] dato_A = 0;
	reg signed [msb:0] dato_B = 0;
	reg [5:0] dato_Op = 6'b000000;
	
	// Salida como registro de la ALU (resultados sobre LEDs)
	output wire [msb:0] buf_R;
	
	//
	always@(p_a or p_b or p_c)
	// Detectamos seleccion de pulsador (forma 2)
	begin
		if(p_a == 1'b1)
			dato_A = buf_A;
		else if (p_b == 1'b1)
			dato_B = buf_B;
		else if(p_c == 1'b1)
			dato_Op = buf_Op;
	end
	// Detectamos seleccion de pulsador (forma 1)
//	case ({p_a,p_b,p_c})
//		3'b100: dato_A = buf_in;
//		3'b010: dato_B = buf_in;
//		3'b001: dato_Op = buf_in[5:0];
//		default: dato_Op = 6'b100100;
//	endcase
		
	
	assign buf_R = (dato_Op==6'b100000) ? dato_A+dato_B:// ADD
						(dato_Op==6'b100010) ? dato_A-dato_B:// SUB
						(dato_Op==6'b100100) ? dato_A&dato_B:// AND
						(dato_Op==6'b100101) ? dato_A|dato_B://OR	
						(dato_Op==6'b100110) ? dato_A^dato_B:// XOR
						(dato_Op==6'b000011) ? dato_A <<< dato_B://{dato_A[7],dato_A[7:1]}:// SRA
						(dato_Op==6'b000010) ? dato_A >> dato_B:// SRL
						(dato_Op==6'b100111) ? ~|dato_A: 0;// NOR

endmodule