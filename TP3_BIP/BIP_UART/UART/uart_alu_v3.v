`timescale 1ns / 1ps
//////////////////////////////////////////////////////////////////////////////////
// Company: 
// Engineer: 
// 
// Create Date:    17:12:01 11/03/2016 
// Design Name: 
// Module Name:    uart_alu_v3 
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
module uart_alu_v3
#(parameter		DBIT = 8, // numero de bits de datos
					SB_TICK = 16, // numero de tick en bit stop
					FIFO_W = 2 // numero de direcciones en buff fifo
)
(clk, reset, rx, tx_full, rx_empty, tx,
 result_alu, dato_A, dato_B, dato_Op);
	
	// Entradas modulo
	input clk;
	input reset;
	input rx;
	//input [DBIT-1:0] dato_tx;
	//input btn_wr;
	
	// Salidas modulo
	output tx;
	output wire tx_full, rx_empty;
	//output wire [DBIT-1:0] r_data; // testbench
	wire [DBIT-1:0] r_data; // realidad
	
	// Variables internas
	//reg clk;
	wire rd, wr; // wr_tick, rd_tick;
   wire [DBIT-1:0] rec_data, rec_data1;
	//wire [DBIT-1:0] buffer; // buffer salida de intf para entrada de manejador ALU
	output wire [DBIT-1:0] result_alu; // resultado de ALU y entrada de intf (alu_in)
	//wire [2:0] pulsadores;
	output wire [DBIT-1:0] dato_A,dato_B;
	output wire [5:0] dato_Op;
	//wire [2:0] pulsadores_tick; // Pulsadores sin rebote (antirrebote)

	// Instancia uart
   uart #(.DBIT(DBIT), .SB_TICK(SB_TICK), .FIFO_W(FIFO_W))
	uart_unit
      (.clk(clk), .reset(reset), .rd_uart(rd),
       .wr_uart(wr), .rx(rx), .w_data(rec_data1),
       .tx_full(tx_full), .rx_empty(rx_empty),
       .r_data(rec_data), .tx(tx));
		 
   /*/ Instancia circuito debounce (antirrebote en pulsadores)
   debounce btn_db_unit
      (.clk(clk), .reset(reset), .sw(rd),
       .db_level(), .db_tick(rd_tick));
		 
	 debounce btn_db_unit2
      (.clk(clk), .reset(reset), .sw(wr),
       .db_level(), .db_tick(wr_tick));*/

	// Instancia de ALU
	bloque_ALU #(.nbits(DBIT)) // paso de parametro, 8 bits en este caso
	ALU1(
		.buf_A(dato_A),
		.buf_B(dato_B),
		.buf_Op(dato_Op),
		.dato_R(result_alu)//.dato_R(dato_R) -> repetando forma 2 de bloque ALU
	);
	
	
	// Instancia de modulo intf
	intf_v2 #(.N(DBIT))
	iintf (
		.clk(clk), 
		.reset(reset), 
		.empty_uart(rx_empty), 
		.uart_in(rec_data), 
		.alu_in(result_alu), 
		.uart_out(rec_data1), // relaidad (rec_data1) 
		.dato_A(dato_A),
		.dato_B(dato_B),
		.dato_Op(dato_Op),
		.rd_uart(rd), 
		.wr_uart(wr)// poner wr
	);
	
	
	//assign rec_data1 = dato_tx + 1;
	//assign r_data = rec_data;
	// wr se ignora por ahora para testear


endmodule
