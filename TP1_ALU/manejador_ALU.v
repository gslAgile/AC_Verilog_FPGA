`timescale 1ns / 1ps
//////////////////////////////////////////////////////////////////////////////////
// Company: 
// Engineer: 
// 
// Create Date:    21:40:09 09/22/2016 
// Design Name: 
// Module Name:    manejador_ALU 
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
//`define NBITS 8
//`define MSB `NBITS-1


module manejador_ALU(clk, p_abc, buf_in, dato_R);
//Parametros internos
parameter nbits = 8; // numero de bits para buffers
parameter msb = nbits-1; // bit mas significativo

// Entaradas manejador ALU
input clk; // clock
input [2:0]p_abc; // pulsadores a -> p_abc[0], b-> p_abc[1] y c -> p_abc[2]
input [msb:0]buf_in; // buffer de entrada para capturar datos de operandos y codigos de op

// Salidas manejador ALU
output wire [msb:0] dato_R; // registro de salida asociado a ALU

// Variables internas
reg signed[msb:0] dato_A, dato_B; // registros que almacenaran los operandos
reg [5:0] dato_Op; // registro que almacena el codigo de operacion

// Captura de datos a traves de buf_in
always @(posedge clk)
begin
	if(p_abc == 3'b100)
			dato_A = buf_in;
	else if (p_abc == 3'b010)
		dato_B = buf_in;
	else if(p_abc == 3'b001)
		dato_Op = buf_in[5:0];
end

// Instanciacion de bloque ALU
bloque_ALU #(.nbits(nbits)) // paso de parametro, 8 bits en este caso
ALU1(
	.buf_A(dato_A),
	.buf_B(dato_B),
	.buf_Op(dato_Op),
	.buf_R(dato_R)//.dato_R(dato_R) -> repetando forma 2 de bloque ALU
);

endmodule
