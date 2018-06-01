module up_counter(out,enable,clk,reset);
  output [7:0] out;
  input enable, clk, reset;
  reg [7:0] out;
  
  //-------------Code Starts Here-------
  always @(posedge clk)begin
	if (reset) begin
		out <= 8'b0 ;
	end 
	else if (enable) begin
		out <= out + 1;
	end
  end
endmodule
module orgBits(ordem,b,out,clk);
	input [7:0] ordem;
	input b;
	output reg [7:0] out;
	input clk;
	always@(posedge clk)begin
		case(ordem)
			0:begin
				out[7] <=b; 	
			end
			1:begin
				out[6] <= b;
			end
			2:begin
				out[5] <= b;
			end
			3:begin
				out[4] <= b;
			end
			4:begin
				out[3] <= b;
			end
			5:begin
				out[2] <= b;
			end
			6:begin
				out[1] <= b;
			end
			7:begin
				out[0] <= b;
			end
		endcase
	end
endmodule 

module controle_Decoder (comando,comparador,clk,entrada);
	output [7:0] comando;
	output [7:0]comparador;
	input clk,entrada;
	reg [7:0]comando;
	reg [7:0]cont;
	reg [7:0]etapa;
	reg enable,reset,b;
	reg [7:0]bitSgnal;
	wire [7:0]tempo;
	wire [7:0]copia;
	initial begin
		etapa = 0;
		enable = 0;
		comando =0;
		cont = 0;
		reset = 0;
		b=0;
		bitSgnal = 0;
	end
	up_counter(.out(tempo),.enable(enable),.clk(clk),.reset(reset));

	always@(posedge clk)begin
		
		if(entrada==0 && etapa==0)begin
			etapa <= 1;
		end
		if(entrada==1 && etapa == 1)begin
			etapa <=2;
		end
		if(entrada==0 && etapa == 2 )begin
			etapa <= 3;
			if(cont == 16)begin
				cont <= 0;
				etapa <= 4;
			end
		end
		if(entrada == 1 && etapa == 3)begin
			etapa <= 2;
			cont <= cont + 1;
		end
		if(entrada ==1 && etapa == 4)begin
			enable<= 1;
			etapa <= 5;
			reset <=0;
			cont <= cont + 1;
		end 
		else if(entrada == 0 && etapa == 5)begin
			enable <=0;
			reset <=1;
			if(cont == 8) begin
				cont <= 0;
				etapa <=6;
				bitSgnal <= 0;
				comando = copia;
				reset <= 0;
			end
			else begin 
				etapa <=4;
			end
			if(tempo > 18)begin // bit = 1 
				tempo <= 0;
				b<= 1;
				orgBits(.ordem(bitSgnal),.b(b),.out(copia),.clk(clk));
				bitSgnal <= bitSgnal + 1;
				if(bitSgnal==8)begin
					bitSgnal <= 0;
				end
			end 
			else if (tempo <= 18)begin// bit = 0
				b<= 0;
				tempo <= 0;
				orgBits(.ordem(bitSgnal),.b(b),.out(copia),.clk(clk));
				bitSgnal <= bitSgnal + 1;
				if(bitSgnal==8)begin
					bitSgnal <= 0;
				end
			end
		end
		
		if(entrada ==1 && etapa == 6)begin
			enable<= 1;
			etapa <= 7;
			reset <=0;
			cont <= cont + 1;
		end 
		else if(entrada == 0 && etapa == 7)begin
			enable <=0;
			reset <=1;
			if(cont == 8) begin
				cont <= 0;
				etapa <=8;
				bitSgnal <= 0;
				compadador <= copia;
				reset <= 0;
			end
			else begin 
				etapa <=6;
			end
			if(tempo > 18)begin // bit = 1 
				tempo <= 0;
				b<= 1;
				orgBits(.ordem(bitSgnal),.b(b),.out(copia),.clk(clk));
				bitSgnal <= bitSgnal + 1;
				if(bitSgnal==8)begin
					bitSgnal <= 0;
				end
			end 
			else if (tempo <= 18)begin// bit = 0
				tempo <= 0;
				b<= 0;
				orgBits(.ordem(bitSgnal),.b(b),.out(copia),.clk(clk));
				bitSgnal <= bitSgnal + 1;
				if(bitSgnal==8)begin
					bitSgnal <= 0;
				end
			end
		end
		if(etapa==8) begin
			cont <= 0;
			etapa <=0;
			bitSgnal <= 0;
			reset <= 0;
			tempo <= 0;
		end
	end
endmodule
	
	