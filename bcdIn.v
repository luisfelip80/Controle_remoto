module bcdIn(i,j,su,sd);
	output reg[6:0] su;
	output reg[6:0] sd;
	input [7:0]i;
	input [7:0]j;
	
	
	always 
		begin
	
		case(i)
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
					su = 7'b0000001;
        endcase
        
        case(j)
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
					sd = 7'b0000001;

		endcase
	end
endmodule
