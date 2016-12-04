`timescale 1ns / 1ps
//////////////////////////////////////////////////////////////////////////////////
// Company: 
// Engineer: 
// 
// Create Date:    12:19:13 11/25/2016 
// Design Name: 
// Module Name:    interface 
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
module interface
#(parameter N = 8) // N: numero de bits de datos
(clk, reset, instruction_in, empty_uart, tx_full, uart_in, bip_ACC_in, PC_in,
 uart_out, rd_uart, wr_uart, reset_outw);
	// Entradas intf
	//input wire [3:0] buff_in; // buffer de entrada vinculado a la FPGA y asociado a cada estado de carga de valores en manejador_ALU
	input wire empty_uart, tx_full; // bandera empty de uart como entrada y full de uart
	input wire [N-1:0] uart_in;
	input wire [15:0] bip_ACC_in;
	input wire [15:0] instruction_in;
	input wire clk, reset; // clk: clock de FPGA - reset: señal para resetear FSM
	input wire [10:0] PC_in;
	//input wire s_tick_clk; // s_tick_clk: clock de baud rate gen.
	
	// Salidas intf
	output wire [N-1:0] uart_out;	
	output reg rd_uart=0, wr_uart=0;
	output wire reset_outw;
	 
	// Declaracion de estados
   localparam [4:0]
      idle = 5'b00001, // estado de espera para cambio de estado
		start_BIP = 5'b00010,// estado para almacenar recepcion de UART en dato_A de manejador_ALU
      idle_HALT = 5'b00100,// estado para almacenar recepcion de UART en dato_B de manejador_ALU
      result_ACC  = 5'b01000;// estado para avisar resultado a transmitir por UART

   // Declaracion de señales con inicializacion en cada una
   reg [4:0] state, state_next=idle;// estados de 4 bits
	reg reset_out, reset_out_next=1;
	reg enable, enable_next = 1'b1; // bit de habilitacion para cargar dato
	reg [1:0] turn, turn_next = 0; 	// turno de carga de estados
												// si turn = 00 -> se carga A
												// si turn = 01 -> se carga B
												// si turn = 10 -> se carga Op
	reg [N-1:0] reg_uart_out = 52;
	reg [N-1:0] entrada_op = 1;
	reg [3:0] cont, cont_next = 0, ct, ct_next=0; // contador de transmisiones
	

   // Estados de la FSM
   always @(posedge clk, posedge reset)
      if (reset)
         begin
            state <= idle;
				turn  <= 2'b00;
				enable <= 1'b1;
				reset_out <= 1'b1;
				cont <= 0;
				ct <= 0;
         end
      else
         begin
            state <= state_next;
				turn <= turn_next;
				enable <= enable_next;
				reset_out <= reset_out_next;
				cont <= cont_next;
				ct <= ct_next;
         end

   // Logica de siguiente estado
   always @*
   begin
		// default: por defecto se mantienen los valores anteriores
      state_next = state;
		enable_next = enable;
		turn_next = turn;
		rd_uart = 1'b0; // recepcion no leida
		wr_uart = 1'b0; // no realizar transmision
		reset_out_next = reset_out;
		cont_next = cont;
		ct_next = ct;
		//reset_out_next = reset_out;
      case (state)
         idle:
				begin
            if(enable && ~empty_uart)
					begin
						if(turn[0]==0 && turn[1]==0)
							state_next = start_BIP; // estado sig -> start_BIP (inicio de ejecucion BIP)
					
						else if(turn[0] && turn[1]==0)
							state_next = idle_HALT; // estado sig -> stop_BIP (stop en reset_out)
						
						/*else if(turn[1] && ~turn[0])
							state_next = idle_HALT; // estado sig -> idle_PC (espera PC y carga de ACC)
						*/
						
					end
					
					else begin
						if(~empty_uart)
							enable_next = 1'b1; // se habilita bit para cargar nuevo dato
							end
				end
         
			start_BIP:
			begin
				if(enable)
				begin
					if(uart_in == 13) // si entrada es un enter
					begin
						reset_out_next = 1'b0;
						turn_next = 2'b01; // se cambia turno para carga de B en proxima subida de empty_uart
						state_next = idle_HALT;// estado sig ->
						rd_uart = 1'b1; // aviso a uart de recepcion leida
						enable_next = 1'b1; // se deshabilita carga hasta que se vacie nuevamente fifo
						//cont = 0;
					end
					
					else begin
						state_next = idle;
						rd_uart = 1'b1; // aviso a uart de recepcion leida
					end
					/*else begin
						rd_uart = 1'b1; // aviso a uart de recepcion leida
						enable_next = 1'b1; // se deshabilita carga hasta que se vacie nuevamente fifo
						cont = 0;
					end*/
					//state_next = idle;// estado sig ->
            end
			end
			
			idle_HALT:
			begin
				if(instruction_in==0 && PC_in > 1)// instruction_in == 0
				begin
					//reg_uart_out = bip_ACC_in[7:0] + 48;
					turn_next = 2'b11; // se cambia turno para carga de A en proxima subida de empty_uart
					state_next = result_ACC;// estado sig -> resultado para enviar resultado por uart
				end
				
				else begin
					state_next = idle_HALT;
					ct_next = 1;
				end
				//rd_uart = 1'b1; // aviso a uart de recepcion leida
				//enable_next = 1'b0; // se deshabilita carga hasta que se vacie nuevamente fifo
			end
			
			result_ACC:
			begin
				/*if(cont == 0) begin
					cont_next = 1;
					turn_next = 2'b00; // se cambia turno para carga de A en proxima subida de empty_uart
					state_next = start_BIP;
					ct_next = 1;
				end*/
				
				//else begin
					if(~tx_full && ct == 1) begin
						reg_uart_out = bip_ACC_in[15:8] + 48; // primeros 8 bits del ACC (msb)
						wr_uart = 1'b1; // realizar transmision tx uart
						ct_next = 2;
						state_next = result_ACC;// estado sig -> se vuelve a idle
					end
					
					else if(~tx_full && ct == 2)
					begin
						reg_uart_out = bip_ACC_in[7:0] + 48; // ultimos 8 bits del ACC (lsb)
						wr_uart = 1'b1; // realizar transmision tx uart
						turn_next = 2'b00; // se cambia turno para carga de A en proxima subida de empty_uart
						enable_next = 1'b1; // se habilita bit para cargar nuevo dato
						ct_next = 1;
						state_next = idle;// estado sig -> se vuelve a idle
					end
					
					else
						state_next = result_ACC;// estado sig -> se vuelve a idle
					
				//end
			end
			
		endcase
   end
   
	// Logica de Salida
	assign uart_out = reg_uart_out; // Se suma 48 ya uart transmite en ASCII
	assign reset_outw = reset_out;

endmodule
