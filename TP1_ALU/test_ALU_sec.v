`timescale 1ns / 1ps

////////////////////////////////////////////////////////////////////////////////
// Company: 
// Engineer:
//
// Create Date:   14:21:30 09/20/2016
// Design Name:   ALU_sec
// Module Name:   /home/gabriel/TP1_ALU/test_ALU_sec.v
// Project Name:  TP1_ALU
// Target Device:  
// Tool versions:  
// Description: 
//
// Verilog Test Fixture created by ISE for module: ALU_sec
//
// Dependencies:
// 
// Revision:
// Revision 0.01 - File Created
// Additional Comments:
// 
////////////////////////////////////////////////////////////////////////////////

module test_ALU_sec;

	// Paramatros ALU
	parameter msb = 7;
	
	// Inputs
	reg [msb:0] buf_A;
	reg [msb:0] buf_B;
	reg [5:0] buf_Op;
	reg p_a;
	reg p_b;
	reg p_c;

	// Outputs
	wire [msb:0] buf_R;

	// Instantiate the Unit Under Test (UUT)
	ALU_sec #(.msb(msb)) 
	uut(
		.buf_A(buf_A), 
		.buf_B(buf_B), 
		.buf_Op(buf_Op), 
		.p_a(p_a), 
		.p_b(p_b), 
		.p_c(p_c), 
		.buf_R(buf_R)
	);

	initial begin
		// Initialize Inputs
		buf_A = 20; // Cargamos B
		buf_B = 0;
		buf_Op = 6'b100100;
		p_a = 1; // pulsamos carga de A
		p_b = 0;
		p_c = 0;

		// Wait 100 ns for global reset to finish
		// Add stimulus here
		#100; // Cargamos A
		buf_B = 7;
		p_a = 0;
		p_b = 1; // pulsamos carga de B
		p_c = 0;
		
		#100; // Cargamos operacion suma
		buf_Op = 6'b100000; // ADD
		p_a = 0;
		p_b = 0;
		p_c = 1; // pulsamos para cargar operacion
		
		#100; // dejamos lapso sin pulsar, para verificar funcionamiento de proxima op
		buf_Op = 0;
		p_a = 0;
		p_b = 0;
		p_c = 0;
		
		#100; // Cargamos operacion resta
		buf_Op = 6'b100010; // SUB
		p_a = 0;
		p_b = 0;
		p_c = 1; // pulsamos para cargar operacion
		
		#100; // dejamos lapso sin pulsar, para verificar funcionamiento de proxima op
		buf_Op = 0;
		p_a = 0;
		p_b = 0;
		p_c = 0;
		
		#100; // Cargamo operacion and
		buf_Op = 6'b100100;// AND
		p_a = 0;
		p_b = 0;
		p_c = 1; // pulsamos para cargr la operacion
		
		#100; // dejamos lapso sin pulsar, para verificar funcionamiento de proxima op
		buf_Op = 0;
		p_a = 0;
		p_b = 0;
		p_c = 0;
		
		#100; // Cargamos operacion or
		buf_Op = 6'b100101; // OR
		p_a = 0;
		p_b = 0;
		p_c = 1; // pulsamos para cargar operacion
		
		#100; // dejamos lapso sin pulsar, para verificar funcionamiento de proxima op
		buf_Op = 0;
		p_a = 0;
		p_b = 0;
		p_c = 0;
		
		#100; // Cargamos operacion xor
		buf_Op = 6'b100110; // XOR
		p_a = 0;
		p_b = 0;
		p_c = 1; // pulsamos para cargar operacion
		
		#100; // dejamos lapso sin pulsar, para verificar funcionamiento de proxima op
		buf_Op = 0;
		buf_B = 2;// cargamos op B con 2, para desplazar 2 lugares
		p_a = 0;
		p_b = 1; // pulsamos para carga de op B
		p_c = 0;
		
		#100; // dejamos lapso sin pulsar, para verificar funcionamiento de proxima op
		buf_Op = 0;
		buf_A = -12; // cargamos operador A con negativo para verificar sra
		p_a = 1;// pulsamos para cargar A
		p_b = 0;
		p_c = 0;
		
		
		#100; // Cargamos operacion desplazamiento sra
		buf_Op = 6'b000011; // SRA
		p_a = 0;
		p_b = 0;
		p_c = 1; // pulsamos para cargar operacion
		
		#100; // dejamos lapso sin pulsar, para verificar funcionamiento de proxima op
		buf_Op = 0;
		p_a = 0;
		p_b = 0;
		p_c = 0;
		
		#100; // Cargamos operacion desplazamiento srl
		buf_Op = 6'b000010; // SRL
		p_a = 0;
		p_b = 0;
		p_c = 1; // pulsamos para cargar operacion
		
		#100; // dejamos lapso sin pulsar, para verificar funcionamiento de proxima op
		buf_Op = 0;
		p_a = 0;
		p_b = 0;
		p_c = 0;
		
		#100; // Cargamos operacion nor
		buf_Op = 6'b100111; // NOR
		p_a = 0;
		p_b = 0;
		p_c = 1; // pulsamos para cargar operacion

	end
	
	// Analisis
	initial $monitor($time, buf_A, buf_B, buf_Op, buf_R, p_a, p_b, p_c);
      
endmodule

