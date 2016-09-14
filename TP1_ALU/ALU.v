`timescale 1ns / 1ps
//////////////////////////////////////////////////////////////////////////////////
// Company: 
// Engineer: 
// 
// Create Date:    18:48:46 09/13/2016 
// Design Name: 
// Module Name:    ALU 
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
module ALU(A,B,Op,R);

	input [3:0]A,B;
	input [5:0]Op;
	output [3:0]R;
	
	assign R = (Op==6'b100000) ? A+B:// ADD
				  (Op==6'b100010) ? A-B:// SUB
				  (Op==6'b100100) ? A&B:// AND
				  (Op==6'b100101) ? A|B://OR	
				  (Op==6'b100110) ? A^B:// XOR
				  (Op==6'b000011) ? {A[3],A[3:1]}:// SRA
				  (Op==6'b000010) ? A >> 1:// SRL
				  (Op==6'b100111) ? ~|A: 4'b0000;// NOR

endmodule
