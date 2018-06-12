module Remoto(clk, entrada,saida_leitura,comando);

parameter inicial_0         = 2'b00;
parameter inicial_1         = 2'b01;
parameter leitura           = 2'b10;

parameter tempo_maximo       =  262143;
parameter primeiro_0    	 =  230000;
parameter segundo_0    		 =  210000;
parameter tempo_bit_0     	 =  41500;
parameter tempo_bit  		 =  20000;

input         clk;        
input         entrada;
output        saida_leitura;
output reg [0:7]comando;
reg[31:0] saida;    
reg[17:0] inicial_0_count;
reg[17:0] estado_conta;
reg[17:0] cont; 
reg[5:0] bitcount;
reg[1:0] estado;         
reg[31:0] dados;                  
reg[31:0] dados_buf;            
reg dados_leitura;           

always @(posedge clk)begin
	if ((estado == inicial_0) && !entrada)
		inicial_0_count <= inicial_0_count + 1'b1;
	else                           
		inicial_0_count <= 0;	
end		     		 	
always @(posedge clk) begin
	if ((estado == inicial_1) && entrada)
		estado_conta <= estado_conta + 1'b1;
	else  
		estado_conta <= 0;   
end	 		 

always @(posedge clk)begin
	if ((estado == leitura) && entrada)
			 cont <= cont + 1'b1;
	else begin
		cont <= 1'b0;
	end 
end

always @(posedge clk)begin
	if (estado == leitura)
		begin
			if (cont == 20000)
					bitcount <= bitcount + 1'b1; 
		end   
	  else
	     bitcount <= 6'b0;
end
always @(posedge clk)begin
	case (estado)
 			    00: if (inicial_0_count > primeiro_0) 
			  	    estado <= 01; 
			    01: if (estado_conta > segundo_0)
			  	    estado <= 10;
			    10: if ((cont >= tempo_maximo) || (bitcount >= 33))
			  		estado <= 00;
	        default  : estado <= inicial_0; 
			 endcase
end
always @(posedge clk)begin
	if (estado == leitura)begin
		if (cont >= tempo_bit_0) 
			dados[bitcount-1'b1] <= 1'b1;
		end
		else
			 dados <= 0;
end

always @(posedge clk)begin
	if (bitcount == 32) 
		begin
			if (dados[31:24] == ~dados[23:16])
			begin
				comando[0:7] <= dados[23:16];
				dados_buf <= dados;
				dados_leitura <= 1'b1;  
			end	
			else
				 dados_leitura <= 1'b0 ; 
		end
		else
		   dados_leitura <= 1'b0 ;
end
always @(posedge clk)begin
	if (dados_leitura)
	    saida <= dados_buf;
end
					
endmodule
