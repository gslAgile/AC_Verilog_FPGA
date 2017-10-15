`timescale 1ns / 1ps
//////////////////////////////////////////////////////////////////////////////////
// Company: 
// Engineer: 
// 
// Create Date:    22:36:32 11/24/2016 
// Design Name: 
// Module Name:    data_memory2 
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
module data_memory2
(clk, reset, Rd, Wr, Addr, In_data, Out_data);

	// Entradas modulo
	input wire clk, reset;
	input wire Rd, Wr;
	input wire [10:0] Addr;
	input wire [15:0] In_data;

	// Salidas modulo
	output reg [15:0] Out_data;

	// Variables internas
	reg [15:0] data_list [9:0]; // lista de datos (10 registros de 16 bits)
	reg [3:0] i;

	always@(negedge clk, posedge reset)
	begin
		if(reset)
		begin
			for( i = 0 ; i< 9 ; i=i+1)
				data_list[i] <= 0;
		
			data_list[9] <= 0;
			Out_data <= 0;
		end
	
		else
		begin
			case ({Rd,Wr})
				2'b01: // Write
				begin
					data_list [Addr] <= In_data;
					Out_data <= In_data ;
				end
				2'b10:// Read
				begin
					Out_data <= data_list [Addr];
				end
		endcase
		end
	end


endmodule
