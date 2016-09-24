`timescale 1ns / 1ps

////////////////////////////////////////////////////////////////////////////////
// Company: 
// Engineer:
//
// Create Date:   23:27:11 09/22/2016
// Design Name:   manejador_ALU
// Module Name:   /home/gabriel/TP1_ALU/test_manejador_v1.v
// Project Name:  TP1_ALU
// Target Device:  
// Tool versions:  
// Description: 
//
// Verilog Test Fixture created by ISE for module: manejador_ALU
//
// Dependencies:
// 
// Revision:
// Revision 0.01 - File Created
// Additional Comments:
// 
////////////////////////////////////////////////////////////////////////////////
`define ADD  6'b100000
`define SUB  6'b100010
`define AND  6'b100100
`define OR   6'b100101
`define XOR  6'b100110
`define SRA  6'b000011
`define SRL  6'b000010
`define NOR  6'b100111


module test_manejador_v1;

	// Parametros internos utilizados en test bench
	parameter msb = 7;
	// Inputs
	reg clk;
	reg [2:0] p_abc;
	reg [msb:0] buf_in;

	// Outputs
	wire [msb:0]dato_R;

	// Instantiate the Unit Under Test (UUT)
	manejador_ALU #(.nbits(msb+1))
	uut (
		.clk(clk), 
		.p_abc(p_abc), 
		.buf_in(buf_in), 
		.dato_R(dato_R)
	);

	initial begin
		// Initialize Inputs
		buf_in = 20; // cargamos operando A con 20
		p_abc = 3'b100; // presionamos pulsador A para tomar carga
		
		// Add stimulus here

		// Wait 100 ns for global reset to finish
		#100;
		buf_in = 7; // cargamos operando B con 7
		p_abc = 3'b010; // presionamos pulsador B para tomar carga
		
		// Verificacion de operaciones aritmeticas
		#100;
		buf_in = `ADD; //ADD; // cargamos operacion ADD
		p_abc = 3'b001; // presionamos pulsador para tomar operacion
		
		#100;
		buf_in = `SUB;//SUB; // cargamos operacion SUB
		p_abc = 3'b000; // presionamos pulsador para tomar operacion
		
		#100;
		buf_in = `SUB;//SUB; // cargamos operacion SUB
		p_abc = 3'b001; // presionamos pulsador para tomar operacion
		
		// Verificacion de operaciones logicas
		#100;
		buf_in = `AND;// // cargamos operacion AND
		p_abc = 3'b001; // presionamos pulsador para tomar operacion
		
		#100;
		buf_in = `OR;//OR; // cargamos operacion OR
		p_abc = 3'b001; // presionamos pulsador para tomar operacion
		
		#100;
		buf_in = `XOR;//XOR; // cargamos operacion XOR
		p_abc = 3'b001; // presionamos pulsador para tomar operacion
		
		#100;
		buf_in = `NOR;//NOR; // cargamos operacion NOR
		p_abc = 3'b001; // presionamos pulsador para tomar operacion
		
		//Recargamos valores de A y B
		#100;
		buf_in = 8'b01100000; // cargamos operando A
		p_abc = 3'b100; // presionamos pulsador A para tomar carga
		
		#100;
		buf_in = 2; // cargamos operando B con 2 desplazamientos
		p_abc = 3'b010; // presionamos pulsador B para tomar carga
		
		// Verificacion de operaciones de desplazamiento
		#100;
		buf_in = `SRL;//SRL; // cargamos operacion SRL
		p_abc = 3'b001; // presionamos pulsador para tomar operacion
		
		#100;
		buf_in = `SRA;//SRA; // cargamos operacion SRA
		p_abc = 3'b001; // presionamos pulsador para tomar operacion
		
		//Recargamos valores de A y B
		#100;
		buf_in = 8'b11100000; // cargamos operando A
		p_abc = 3'b100; // presionamos pulsador A para tomar carga
		
		// Verificacion de operaciones de desplazamiento
		#100;
		buf_in = `SRL;//SRL; // cargamos operacion SRL
		p_abc = 3'b001; // presionamos pulsador para tomar operacion
		
		#100;
		buf_in = `SRA;//SRA; // cargamos operacion SRA
		p_abc = 3'b001; // presionamos pulsador para tomar operacion
		

	end
	
	
	// Generacion de clock en circuito secuencial
	always begin
		clk = 1'b0;
		#(100/2) clk = 1'b1;
		#(100/2);
	
	end
      
endmodule

