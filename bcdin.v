module bcdin(a,b,c,d,e,f,g,a1,b1,c1,d1,e1,f1,g1,n,sinal);
	output a,b,c,d,e,f,g;  //leds do display
	output a1,b1,c1,d1,e1,f1,g1; //leds do display
	input [7:0]n;
	reg [3:0]i; //unidade do numero
	reg [3:0]j; //dezena do numero
	reg[6:0] su;
	reg[6:0] sd;
	input sinal; //sinal do numero

	always 
		begin
		i <= n%10;
		j <= n/10;
	
		case(i)//unidade
				4'b0000: 
					su = 7'b0000001;
	            4'b0001: 
					su = 7'b1001111;
	            4'b0010: 
					su = 7'b0010010;
	            4'b0011: 
					su = 7'b0000110;
	            4'b0100: 
					su = 7'b1001100;
	            4'b0101: 
					su = 7'b0100100;
	            4'b0110: 
					su = 7'b0100000;
	            4'b0111: 
					su = 7'b0001111;
	            4'b1000: 
					su = 7'b0000000;
	            4'b1001: 
					su = 7'b0000100;
				default:
					su = 7'b0000001;
        endcase
        
        case(j)//dezena
	        	4'b0000: 
	        		sd = 7'b0000001;
		        4'b0001: 
		        	sd = 7'b1001111;
		        4'b0010: 
		        	sd = 7'b0010010;
		        4'b0011: 
		        	sd = 7'b0000110;
		        4'b0100: 
		        	sd = 7'b1001100;
		        4'b0101: 
		        	sd = 7'b0100100;
		       4'b0110: 
		        	sd = 7'b0100000;
		        4'b0111: 
		        	sd = 7'b0001111;
		        4'b1000: 
		        	sd = 7'b0000000;
		       4'b1001: 
		        	sd = 7'b0000100;
		        default:
					sd = 7'b0000001;

		endcase
	end

	assign {a, b, c, d, e, f, g} = su;
	assign {a1, b1, c1, d1, e1, f1, g1} = sd;

endmodule
