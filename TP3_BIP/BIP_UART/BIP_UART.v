`timescale 1ns / 1ps
//////////////////////////////////////////////////////////////////////////////////
// Company: 
// Engineer: 
// 
// Create Date:    13:04:56 11/25/2016 
// Design Name: 
// Module Name:    BIP_UART 
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
module BIP_UART
#(parameter		DBIT = 8, // numero de bits de datos
					SB_TICK = 16, // numero de tick en bit stop
					FIFO_W = 2 // numero de direcciones en buff fifo
)
(clk, reset, rx, tx_full, rx_empty, tx,
 result_ACC);
	
	// Entradas modulo
	input clk;
	input reset;
	input rx;
	
	// Salidas modulo
	output tx;
	output wire tx_full, rx_empty;
	wire [DBIT-1:0] r_data; // realidad
	
	// Variables internas
	wire [15:0] instruction;
	wire rd, wr; // wr_tick, rd_tick;
   wire [DBIT-1:0] rec_data, rec_data1;
	output wire [15:0] result_ACC; // resultado ACC
	wire reset_aux, reset_or;
	wire [10:0] PCw; // PC wire

	// Instancia uart
   uart #(.DBIT(DBIT), .SB_TICK(SB_TICK), .FIFO_W(FIFO_W))
	uart_unit
      (.clk(clk), .reset(reset), .rd_uart(rd),
       .wr_uart(wr), .rx(rx), .w_data(rec_data1),
       .tx_full(tx_full), .rx_empty(rx_empty),
       .r_data(rec_data), .tx(tx));

	// Instancia de BIP
	BIP2 bip_unit (
		.clk(clk), 
		.reset(reset_or),
		.instruction(instruction),
		.ACC(result_ACC),
		.PC(PCw)
	);
	
	
	// Instancia de modulo interface
	interface #(.N(DBIT))
	intf_unit (
		.clk(clk), 
		.reset(reset), 
		.instruction_in(instruction),
		.empty_uart(rx_empty),
		.tx_full(tx_full),
		.uart_in(rec_data),
		.bip_ACC_in(result_ACC),
		.PC_in(PCw),
		.uart_out(rec_data1), // relaidad (rec_data1) 
		.rd_uart(rd),
		.wr_uart(wr),// poner wr
		.reset_outw(reset_aux)
	);
	
	assign reset_or = (reset | reset_aux); // or entre reset y reset_aux para resetear BIP segun cualquier de los reset
	


endmodule
