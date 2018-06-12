module identificador(clk,entrada,su,sd,led,comando);
input clk;
input entrada;
output reg [6:0] su;
output reg [6:0] sd;
output reg led;
output reg [0:7] comando;

reg a,b,a1,a11;
reg [2:0] aV;
reg [2:0] bV;
reg [2:0] op;
reg on,estado_a;
reg [32:0]delay;
reg [32:0]delay1;
reg [32:0]delay_on;
reg conta_on;
wire [0:7]fio;
reg [7:0] vetorA_1;
reg [7:0] vetorA_2;
reg [7:0]vetorA;
reg [2:0]operacao;
wire [6:0] su_1;
wire [6:0] sd_1;
parameter zera_A    = 3'b001;
parameter zera_B    = 3'b010;
parameter zera_tudo = 3'b011;
parameter soma      = 3'b100;
parameter sub       = 3'b101;
parameter muda_sinal= 3'b110;

bcdIn G1 (vetorA_1,vetorA_2,su_1,sd_1);
Remoto G2(clk,entrada,fio);

initial begin
	a=0;
	b=0;
	conta_on =0;
	delay_on=0;
	aV=0;
	led=0;
	bV=0;
	on=0;
	vetorA_1=0;
	vetorA_2=0;
	vetorA=0;
	operacao = 0;
end

always @(posedge clk) begin
	if(on)begin
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
always @(posedge clk) begin
	if (op==zera_A) begin
		a<=1;
	end
	else if(!a1)begin
		a<=0;
	end
end
always @(posedge clk) begin
	if (a) begin
		delay<=delay+1'b1;
	end
	else begin
		delay<=0;
	end
end
always @(posedge clk) begin
	if (a) begin
		if(comando < 9 && delay > 200000)begin
			vetorA <= comando;
			vetorA_1<=comando;
			a1<=1;
		end
		else if (a11) begin
			a1<=0;
		end
	end
end
always @(posedge clk) begin
	if (a1) begin
		delay1<=delay1+1'b1;
	end
	else begin
		delay1<=0;
	end
end
always @(posedge clk) begin
	if (a1) begin
		if(comando < 9 && delay1 > 200000)begin
			vetorA <= vetorA * 10;
			vetorA <= vetorA + comando;
			vetorA_2<=comando;
			a11<=1;
		end
		else begin
			a11<=1;
		end
	end
	else begin
		a11<=0;
	end
end
endmodule