module bcdout(saida,saida1,saida2,in,enable);
	input [8:0] in;
	output reg [6:0]saida;
	output reg [6:0]saida1;
	output reg [6:0]saida2;
	input enable;
	reg sinal;
	reg [7:0]uni;
	reg [7:0]dez;
	reg [7:0]dezz;
	reg [7:0]cen;
	reg [6:0] su, sd, sc;
	reg [7:0] aux;

	
	always begin
		if (enable) begin
			sinal = in[8];
			aux[7:0] = in[7:0];
			uni = aux%10;
			dezz = aux%100;
			dez = dezz/10;
			cen = aux/100;
				
			case(uni)
				8'b00000000: 
					saida = 7'b0000001;
	            8'b00000001: 
					saida = 7'b1001111;
	            8'b00000010: 
					saida = 7'b0010010;
	            8'b00000011: 
					saida = 7'b0000110;
	            8'b00000100: 
					saida = 7'b1001100;
	            8'b00000101: 
					saida = 7'b0100100;
	            8'b00000110: 
					saida = 7'b0100000;
	            8'b00000111: 
					saida = 7'b0001111;
	            8'b00001000: 
					saida = 7'b0000000;
	            8'b00001001: 
					saida = 7'b0000100;
				default:
					saida = 7'b11111110;
        endcase

        		case(dez)
				8'b00000000: 
					saida1 = 7'b0000001;
	            8'b00000001: 
					saida1 = 7'b1001111;
	            8'b00000010: 
					saida1 = 7'b0010010;
	            8'b00000011: 
					saida1 = 7'b0000110;
	            8'b00000100: 
					saida1 = 7'b1001100;
	            8'b00000101: 
					saida1 = 7'b0100100;
	            8'b00000110: 
					saida1 = 7'b0100000;
	            8'b00000111: 
					saida1 = 7'b0001111;
	            8'b00001000: 
					saida1 = 7'b0000000;
	            8'b00001001: 
					saida1 = 7'b0000100;
				default:
					saida1 = 7'b11111110;
        endcase

        case(cen)
				8'b00000000: 
					saida2 = 7'b0000001;
	            8'b00000001: 
					saida2 = 7'b1001111;
				8'b00000010: 
					saida2 = 7'b0010010;
				default:
					saida2 = 7'b11111110;
        endcase

		end
		else begin
				saida = 7'b11111111;
				saida1 = 7'b11111111;
				saida2 = 7'b11111111;
			end	

	end

endmodule