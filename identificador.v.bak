module identificador(botao,sinal,clk,entrada,seg_3_a,seg_4_a);
input botao;
input sinal;
input clk;
input entrada;
output reg [6:0] seg_3_a;
output reg [6:0] seg_4_a;
reg a,b;
reg [2:0] aV;
reg [2:0] bV;
reg [2:0] op;
reg on,estado_a;
wire [7:0]comando;
reg [7:0]vetorA;
reg [2:0]operacao;
parameter zera_A    = 3'b001;
parameter zera_B    = 3'b010;
parameter zera_tudo = 3'b011;
parameter soma      = 3'b100;
parameter sub       = 3'b101;
parameter muda_sinal= 3'b110;
wire [6:0] seg_1_a;
wire [6:0] seg_2_a;

bcdIn G1 (seg_1_a,seg_2_a,vetorA[3:0],vetorA[7:4],0);
Remoto G2(clk,entrada,sinal,comando);
initial begin
	a=0;
	b=0;
	aV=0;
	bV=0;
	on<=0;
	operacao <= 0;
end

always @(posedge clk) begin
	if (comando == 8'b01001000) begin
		on <= ~on;
	end
end
always @(posedge clk) begin
	if(on)begin
		if(comando < 10)begin
			operacao <= 3'b001;
		end
		else begin
			case(comando)
				00001111:op <= zera_A;// 0x0F Zera A
				00010011:op <= zera_B;// 0x13 Zera B
				00010000:op <= zera_tudo;// 0x10 Zera tudo
				00011010:op <= soma;// 0x1A Soma
				00011110:op <= sub;// 0x1E Sub
				00000110:op <= muda_sinal;// 0x0C muda sinal
				default: op<=0;
			endcase
		end
	end
	seg_3_a <= seg_1_a;
	seg_4_a <= seg_2_a;
end
always @(posedge clk) begin
	if (op==zera_A) begin
		estado_a <= 2'b01;
	end
	else if(estado_a == 2'b01) begin
		if(op!=zera_A && comando < 10)begin
			vetorA <= comando;
		end
		estado_a<=2'b10;
	end
	else if(estado_a==2'b10)begin
		if(comando > 9)begin
			estado_a <= 0;
		end
		else begin
			estado_a = estado_a * 10;
			estado_a = estado_a + comando;
			estado_a <= 0;
		end
	end
end
endmodule