module Remoto(clk,entrada,comando,su,sd,suB,sdB,saida_1,saida1_1,saida2_1,soma_result_1,sinal_A,sinal_B,sing);

parameter inicia            = 2'b00;   
parameter inicia_1          = 2'b01;    
parameter leitura           = 2'b10; 

parameter zera_B    = 3'b010;
parameter zera_tudo = 3'b011;
parameter soma      = 3'b100;
parameter sub       = 3'b101;
parameter muda_sinal= 3'b110;

parameter  DESLIGADO = 0;
parameter  ESPERA = 1;
parameter  RECEBE_A_DEZ = 2;
parameter  RECEBE_A_UNI = 3;
parameter  MUDA_SINAL_A = 4;
parameter  RECEBE_A_DEZ_B = 5;
parameter  RECEBE_A_UNI_B = 6;
parameter  MUDA_SINAL_B = 7;
parameter  ZERA_TUDO = 8;	

parameter inicia_HIGH_DUR      =  262143; 
parameter GUIDE_LOW_DUR      =  230000;  
parameter GUIDE_HIGH_DUR     =  210000;  
parameter DATA_HIGH_DUR      =  41500;
parameter BIT_AVAILABLE_DUR  =  20000;

input         clk;      
input         entrada;    
output reg [7:0] comando;
output reg[6:0] su;
output reg[6:0] sd;
output reg[6:0] suB;
output reg[6:0] sdB; 
wire [8:0] soma_result;
output reg [8:0] soma_result_1;
reg [4:0] estado;
reg [7:0] vetorA;
reg [7:0] vetorA_2;
reg [7:0] vetorA_1;
reg [7:0] vetorB;
reg [7:0] vetorB_1;
reg [7:0] vetorB_2;
reg marca;
reg [7:0] pega_comando;
reg [7:0] comando_2;
reg [31:0]delay_on;
reg conta_on,on,dev,zera_A;
output reg sinal_A;
output reg sinal_B;
reg    [31:0] oDATA;              
reg    [17:0] inicia_cont;            
reg           inicia_cont_flag;      
reg [32:0]delay;
reg [2:0]op;
reg [32:0]delay1;
wire [6:0] saida;
wire [6:0] saida1;
wire [6:0] saida2;

output [6:0] saida_1;
output [6:0] saida1_1;
output [6:0] saida2_1;
output sing;

reg    [17:0] contador_inicial;           
reg           contador_inicial_flag;    
reg    [17:0] data_count;           
reg           data_count_flag;     
reg     [5:0] bitcount;              
reg     [1:0] state;             
reg    [31:0] data;        
reg nova_mensagem,nova_uni,nova_dezen,menor_que_10,menor_que_10_dez;        
reg    [31:0] data_buf;       
reg           data_ready,a2; 
initial begin
	op = 1;
	on = 0;
	nova_mensagem = 0;
	marca = 0;
	dev<=0;
	estado = DESLIGADO;
	conta_on = 0;
	vetorA<=8'b11111111;
	vetorB<=8'b11111111;
end
assign sing = ~soma_result[8];
assign saida_1 = saida;
assign saida1_1 = saida1;
assign saida2_1 = saida2;
ula G1(.clock(clk),.a(vetorA),.b(vetorB),.r(soma_result),.op(op));
bcdout G2(.saida(saida),.saida1(saida1),.saida2(saida2),.in(soma_result_1),.enable(on));
always @(posedge clk )
if ((state == inicia) && !entrada)
			 inicia_cont <= inicia_cont + 1'b1;
		else                           
			 inicia_cont <= 0;	              		 	

always @(posedge clk)	
if ((state == inicia_1) && entrada)
			 contador_inicial <= contador_inicial + 1'b1;
		else  
			 contador_inicial <= 0;	            		 	

always @(posedge clk )
if ((state == leitura) && entrada)
			 data_count <= data_count + 1'b1;
		else
			 data_count <= 1'b0;        

always @(posedge clk)
if (state == leitura)
		begin
			if (data_count == 20000)
					bitcount <= bitcount + 1'b1; 
		end   
	  else
	     bitcount <= 6'b0;

always @(posedge clk) 
			case (state)
 			    inicia  : if (inicia_cont > GUIDE_LOW_DUR)  
			  	              state <= inicia_1; 
			    inicia_1: if (contador_inicial > GUIDE_HIGH_DUR)
			  	              state <= leitura;
			    leitura : if ((data_count >= inicia_HIGH_DUR) || (bitcount >= 33))
			  					      state <= inicia;
	        default  : state <= inicia; 
			 endcase

always @(posedge clk)
	  if (state == leitura)
		begin
			 if (data_count >= DATA_HIGH_DUR) 
			    data[bitcount-1'b1] <= 1'b1;  
		end
		else
			 data <= 0;
always @(posedge clk)
	  if (data_ready)
	     oDATA <= data_buf;

always @(posedge clk)
	  if (bitcount == 32) begin
			 if (data[31:24] == ~data[23:16])
			 begin		
					comando[7:0] <= data[23:16]; 
					data_buf <= data;
				 	data_ready <= 1'b1;
			 end
			 else
				  data_ready <= 1'b0 ;
		end
		else begin
			data_ready <= 1'b0 ;
		end

always @(posedge clk) begin
	case(estado)
		DESLIGADO: begin
				if(comando == 8'b00010010)begin
					estado <= ESPERA;
					on <= 1;
					vetorA<=0;
					vetorB<=0;
					op<=0;
					soma_result_1 = soma_result;
				end
			end
		ESPERA:begin
				if(comando == 8'b00001111)begin
					estado <=  RECEBE_A_DEZ;
					vetorA<=0;
				end
				else if(comando == 8'b00010000)begin
					estado <=  ZERA_TUDO;
					vetorA<=0;
					vetorB<=0;
				end
				else if(comando == 8'b00010011)begin//zera b
					estado <= RECEBE_A_DEZ_B;
					vetorB<=0;
				end
				else if(comando == 8'b00011010)begin//soma
					op<=0;
					soma_result_1 = soma_result;
				end
				else if(comando == 8'b00011110)begin//sub
					op<=1;
					soma_result_1 = soma_result;
				end
				else if(comando == 8'b00010010)begin
					on<=0;
					vetorA<=8'b11111111;
					vetorB<=8'b11111111;
					estado <= DESLIGADO;
				end
			end
		ZERA_TUDO:begin
				estado <= RECEBE_A_DEZ;
				soma_result_1 <=0;
				//op<=0;
		end
		RECEBE_A_DEZ_B:begin
				if(comando >= 0 && comando < 10)begin
					vetorB <=comando;
					sinal_B <=0;
					estado <= RECEBE_A_UNI_B;
					delay <= 0;
				end
			end	
		RECEBE_A_DEZ:begin
				if(comando >= 0 && comando < 10)begin
					vetorA <= comando;
					sinal_A <=0;
					estado <= RECEBE_A_UNI;
					delay <= 0;
				end
			end	
		RECEBE_A_UNI:begin
			delay = delay + 1'b1;
				if(delay > 50000000 && (comando >= 0 && comando < 10))begin
					vetorA<=vetorA * 10 + comando;
					estado <= MUDA_SINAL_A;
					delay<=0;
				end
			end
		RECEBE_A_UNI_B:begin
			delay = delay + 1'b1;
				if(delay > 50000000 && (comando >= 0 && comando < 10))begin
					vetorB<=vetorB * 10 + comando;
					vetorB[7] <= sinal_B;
					estado <= MUDA_SINAL_B;
					delay<=0;
				end
			end
		MUDA_SINAL_A:begin
			if(comando == 00001101 )begin
				sinal_A=~sinal_A;
				vetorA[7] <= sinal_A;
				estado <=ESPERA;
			end
			else if(comando > 9)begin
				estado <=ESPERA;
			end
		end
		MUDA_SINAL_B:begin
			if(comando == 00001101 )begin
				sinal_B=~sinal_B;
				vetorB[7] <= sinal_B;
				estado <=ESPERA;
			end
			else if(comando > 9)begin
				estado <=ESPERA;
			end
		end			
	endcase	

end

always @(*) begin
		if(vetorA==8'b11111111)begin
			sd <= 7'b1111111;
			su <= 7'b1111111;

		end
		else begin
			vetorA_1 = vetorA%10;
			vetorA_2 = vetorA/10;
			case(vetorA_1)
				0: 
					su = 7'b0000001;
	            1: 
					su = 7'b1001111;
	            2: 
					su = 7'b0010010;
	            3: 
					su = 7'b0000110;
	            4: 
					su = 7'b1001100;
	            5: 
					su = 7'b0100100;
	            6: 
					su = 7'b0100000;
	            7: 
					su = 7'b0001111;
	            8: 
					su = 7'b0000000;
	            9: 
					su = 7'b0000100;
					default:
						su = 7'b1111111;
        endcase
        
	        case(vetorA_2)
		        	0: 
		        		sd = 7'b0000001;
			        1: 
			        	sd = 7'b1001111;
			        2: 
			        	sd = 7'b0010010;
			        3: 
			        	sd = 7'b0000110;
			        4: 
			        	sd = 7'b1001100;
			        5: 
			        	sd = 7'b0100100;
			        6: 
			        	sd = 7'b0100000;
			        7: 
			        	sd = 7'b0001111;
			        8: 
			        	sd = 7'b0000000;
			        9: 
			        	sd = 7'b0000100;
			        	default:
						sd = 7'b1111111;
			endcase	
		end
	end
	always @(*) begin
	if(vetorB==8'b11111111)begin
		sdB <= 7'b1111111;
		suB <= 7'b1111111;
	end
	else begin
		vetorB_1 = vetorB%10;
		vetorB_2 = vetorB/10;
		case(vetorB_1)
				0: 
					suB = 7'b0000001;
	            1: 
					suB = 7'b1001111;
	            2: 
					suB = 7'b0010010;
	            3: 
					suB = 7'b0000110;
	            4: 
					suB = 7'b1001100;
	            5: 
					suB = 7'b0100100;
	            6: 
					suB = 7'b0100000;
	            7: 
					suB = 7'b0001111;
	            8: 
					suB = 7'b0000000;
	            9: 
					suB = 7'b0000100;
				default:
					suB = 7'b1111111;
        endcase
        
        case(vetorB_2)
	        	0: 
	        		sdB = 7'b0000001;
		        1: 
		        	sdB = 7'b1001111;
		        2: 
		        	sdB = 7'b0010010;
		        3: 
		        	sdB = 7'b0000110;
		        4: 
		        	sdB = 7'b1001100;
		        5: 
		        	sdB = 7'b0100100;
		        6: 
		        	sdB = 7'b0100000;
		        7: 
		        	sdB = 7'b0001111;
		        8: 
		        	sdB = 7'b0000000;
		        9: 
		        	sdB = 7'b0000100;
		        default:
					sdB = 7'b1111111;

		endcase
	end
	end	
endmodule