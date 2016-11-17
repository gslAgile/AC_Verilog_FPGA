`timescale 1ns / 1ps
//////////////////////////////////////////////////////////////////////////////////
// Company: 
// Engineer: 
// 
// Create Date:    01:20:19 10/22/2016 
// Design Name: 
// Module Name:    intf_v2 
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
module intf_v2
#(parameter N = 8) // N: numero de bits de datos
(clk, reset, dato_A, dato_B, dato_Op, empty_uart, uart_in, alu_in,
 uart_out, rd_uart, wr_uart);
	// Entradas intf
	//input wire [3:0] buff_in; // buffer de entrada vinculado a la FPGA y asociado a cada estado de carga de valores en manejador_ALU
	input wire empty_uart; // bandera empty de uart como entrada
	input wire [N-1:0] uart_in;
	input wire [N-1:0] alu_in;
	input wire clk, reset; // clk: clock de FPGA - reset: señal para resetear FSM
	//input wire s_tick_clk; // s_tick_clk: clock de baud rate gen.
	
	// Salidas intf
	output reg [N-1:0] dato_A, dato_B;
	output reg [5:0] dato_Op;
	output wire [N-1:0] uart_out;
	//output reg [N-1:0] alu_out;
	//output reg [2:0] pulsador; // pulsador que controlara p_abc de manejador_ALU segun estado de intf
	output reg rd_uart=0, wr_uart=0;
	 
	// Declaracion de estados
   localparam [4:0]
      idle = 5'b00001, // estado de espera para cambio de estado
		operando_a = 5'b00010,// estado para almacenar recepcion de UART en dato_A de manejador_ALU
      operando_b = 5'b00100,// estado para almacenar recepcion de UART en dato_B de manejador_ALU
      operacion  = 5'b01000,// estado para almacenar recepcion de UART en operacion de manejador_ALU
      resultado  = 5'b10000;// estado para avisar resultado a transmitir por UART

   // Declaracion de señales con inicializacion en cada una
   reg [4:0] state, state_next=idle;// estados de 4 bits
	reg [3:0] s_reg, s_next=0; //s_reg: Tick counter -> cuenta los ticks desde el inicio, maxima cuenta 15(4 bits)
	//reg [2:0] p_next = 0; // siguiente pulsador
	reg [N-1:0] dato_A_next=0, dato_B_next=0;
	reg [5:0] dato_Op_next = 6'b10000;
	reg enable, enable_next = 1'b1; // bit de habilitacion para cargar dato
	reg [1:0] turn, turn_next = 0; 	// turno de carga de estados
												// si turn = 00 -> se carga A
												// si turn = 01 -> se carga B
												// si turn = 10 -> se carga Op
	reg [N-1:0] reg_uart_out = 52;
	reg [N-1:0] entrada_op = 1;
	
	reg detector, detector_next = 0;
	reg [N-1:0] aux;
	reg [7:0] i, j;
	reg flag = 0;

   // Estados de la FSM
   always @(posedge clk, posedge reset)
      if (reset)
         begin
            state <= idle;
				s_reg <= 1'b0;
				turn  <= 2'b00;
				dato_A <= 0;
				dato_B <= 0;
				dato_Op <= 6'b10000;
				enable <= 1'b1;
				detector <= 1'b0;
				//wr_uart <= 0;
				//rd_uart <= 0;
         end
      else
         begin
            state <= state_next;
				s_reg <= s_next;
				turn <= turn_next;
				dato_A <= dato_A_next;
				dato_B <= dato_B_next;
				dato_Op <= dato_Op_next;
				enable <= enable_next;
				detector <= detector_next;
         end

   // Logica de siguiente estado
   always @*
   begin
		// default: por defecto se mantienen los valores anteriores
      state_next = state;
      s_next = s_reg;
		dato_A_next = dato_A;
		dato_B_next = dato_B;
		dato_Op_next = dato_Op;
		enable_next = enable;
		turn_next = turn;
		rd_uart = 1'b0; // recepcion no leida
		wr_uart = 1'b0; // no realizar transmision
		detector_next= detector;
      case (state)
         idle:
				begin
				s_next = 0; // tick counter inicia en cero
            if(enable && ~empty_uart)
					begin
						if(turn[0]==0 && turn[1]==0)
							state_next = operando_a; // estado sig -> carga de operando_a
					
						else if(turn[0] && turn[1]==0)
							state_next = operando_b; // estado sig -> carga de operando_b
						
						else if(turn[1] && ~turn[0])
							state_next = operacion; // estado sig -> carga de operacion
						
						
					end
					
					else begin
						if(~empty_uart)
							enable_next = 1'b1; // se habilita bit para cargar nuevo dato
							end
				end
         
			operando_a:
			begin
				if(enable)
				begin
					if(uart_in == 13) // si entrada es un enter
					begin
						detector_next = 1'b0;
						turn_next = 2'b01; // se cambia turno para carga de B en proxima subida de empty_uart
					end
					else begin
						if(detector) begin
							dato_A_next = (10* dato_A) + (uart_in -48);
							detector_next = 1'b0;
						end
						
						else begin
							dato_A_next = uart_in - 48;// -48
							detector_next = 1'b1;
						end
					end
					rd_uart = 1'b1; // aviso a uart de recepcion leida
					enable_next = 1'b0; // se deshabilita carga hasta que se vacie nuevamente fifo
					state_next = idle;// estado sig -> se vuelve a idle
            end
			end
				
         
			operando_b:
			begin
				if(enable)
				begin
					if(uart_in == 13) // si entrada es un enter
					begin
						detector_next = 1'b0;
						turn_next = 2'b10; // se cambia turno para carga de Op en proxima subida de empty_uart
					end
					else begin
						if(detector) begin
							dato_B_next = (10* dato_B) + (uart_in -48);
							detector_next = 1'b0;
						end
						
						else begin
							dato_B_next = uart_in - 48;// -48
							detector_next = 1'b1;
						end
					end
					rd_uart = 1'b1; // aviso a uart de recepcion leida
					enable_next = 1'b0; // se deshabilita carga hasta que se vacie nuevamente fifo
					state_next = idle;// estado sig -> se vuelve a idle
            end
			end
			
			operacion:
			begin
				if(enable)
				begin
					//dato_Op_next = uart_in[5:0] - 48; // -cte para obtener Op
					entrada_op = uart_in - 48; // -48
					case (entrada_op)
						1: dato_Op_next = 6'b100000; // op suma
						2: dato_Op_next = 6'b100010; // op resta
						3: dato_Op_next = 6'b100100; // op AND
						4: dato_Op_next = 6'b100101; // op OR
						5: dato_Op_next = 6'b100110; // op XOR
						6: dato_Op_next = 6'b000011; // op SRA
						7: dato_Op_next = 6'b000010; // op SRL
						8: dato_Op_next = 6'b100111; // op NOR
						default: dato_Op_next = 6'b100000; // op suma
					endcase
					
				detector_next = 1'b0; // se reinicia detector de decenas a unidades (0)
				turn_next = 2'b11; // se cambia turno para carga de A en proxima subida de empty_uart
				rd_uart = 1'b1; // aviso a uart de recepcion leida
				enable_next = 1'b0; // se deshabilita carga hasta que se vacie nuevamente fifo
				i = 0;
				j = 0;
				aux = alu_in;
				state_next = resultado;// estado sig -> resultado para enviar resultado por uart
				end
			end
			
			resultado:
			begin
					/*if(aux >= 100)
					begin
						aux = aux - 100;
						i = i + 1;
					end
					
					if(aux >= 10)
					begin
						aux = aux - 10;
						j = j + 1;
					end
					
					if(aux < 10)
						flag = 1'b1;
					
				if(flag)
					begin*/
						/*if(i > 0) begin
							reg_uart_out = i + 48;
							wr_uart = 1'b1; // realizar transmision tx uart
							i = 0;
						end
					
						else if(j > 0)
						begin
							reg_uart_out = j + 48;
							wr_uart = 1'b1; // realizar transmision tx uart
							j = 0;
						end

						else begin*/
							//reg_uart_out = aux + 48;
							reg_uart_out = alu_in + 48;
							wr_uart = 1'b1; // realizar transmision tx uart
							//rd_uart = 1'b1; // aviso a uart de recepcion leida
							turn_next = 2'b00; // se cambia turno para carga de A en proxima subida de empty_uart
							state_next = idle;// estado sig -> se vuelve a idle
						//end
					
					//end
			end
			
		endcase
   end
   
	// Logica de Salida
   //assign uart_out = alu_in + 48; // Se suma 48 ya uart transmite en ASCII
	assign uart_out = reg_uart_out; // Se suma 48 ya uart transmite en ASCII
	//assign alu_out = uart_in - 48; // Se resta 48 ya uart recibe todo es en ASCII


endmodule
