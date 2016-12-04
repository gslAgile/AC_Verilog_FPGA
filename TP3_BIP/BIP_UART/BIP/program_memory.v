`timescale 1ns / 1ps
//////////////////////////////////////////////////////////////////////////////////
// Company: 
// Engineer: 
// 
// Create Date:    13:42:03 11/17/2016 
// Design Name: 
// Module Name:    program_memory 
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
module program_memory
(clk, reset, Addr, Data);

// Entradas modulo
input wire clk, reset;
input wire [10:0] Addr;

// Salidas modulo
output reg [15:0] Data;

// variable interna
reg [15:0] buffer [9:0]; // baffer de memoria

always@(negedge clk, posedge reset)
begin
	if(reset)
	begin
		// Carga de valores de programa fijo
		buffer[0] <= 16'b0001100000010000; // LDI 16
		buffer[1] <= 16'b0000100000000001; // STO 1
		buffer[2] <= 16'b0001000000000001; // LD 1
		buffer[3] <= 16'b0010100011111111; // ADDI 255
		buffer[4] <= 16'b0000100000000010; // STO 2
		buffer[5] <= 16'b0001000000000010; // LD 2
		buffer[6] <= 16'b0000000000000000; // HLT
		buffer[7] <= 16'b0000000000000000; // HLT
		buffer[8] <= 16'b0000000000000000; // HLT
		buffer[9] <= 16'b0000000000000000; // HLT
		
		// Se muestra primer instruccion de las cargadas inicialmente
		//Data <= buffer[0];
	end
	
	else
		Data <= buffer[Addr];
	
end

//assign Data = 	(Addr >=0 && Addr <10) ? buffer[Addr]: 0;				

endmodule
