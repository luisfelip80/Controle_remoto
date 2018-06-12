module ula(a,b,r,op);
	input [7:0]a;
	input [7:0]b;
	input op;
	output [8:0]r;
	reg sinal;
	reg sa;
	reg sb;
	reg [6:0]aa;
	reg [6:0]bb;
	reg [7:0]rr;

	initial sa = a[7];
	initial sb = b[7];
	initial aa = a[6:0];
	initial bb = b[6:0];


	always 
		begin
		case(op)
			0: begin
				if(sa == 0 && sb == 0)begin
					rr <= aa + bb;
					sinal = 0; 
				end
				if(sa == 0 && sb == 1)begin
					rr <= aa - bb;
					if(sa == 1)begin
						sinal = sa;
					end
					else begin
						sinal = sb;
					end
				end
				if(sa == 1 && sb == 0)begin
					rr <= bb - aa;
					if(sa == 1)begin
						sinal = sa;
					end
					else begin
						sinal = sb;
					end
				end
				if(sa == 1 && sb == 1)begin
					rr <= aa - bb;
					sinal = 1;
				end
			end	
			1: begin
				if(sa == 0 && sb == 1)begin
					rr <= aa + bb;
					if(sa ==1)begin
						sinal = sa;
					end
					else begin
						sinal = sb;
					end
				end
				if(sa == 0 && sb == 0 )begin
					rr <= aa - bb;
					sinal = 0; 
				end
				if(sa == 1 && sb == 1)begin
					rr <= bb - aa;
					sinal = 1;
				end
				if(sa == 1 && sb == 0)begin
					rr <= aa - bb;
					if(sa > sb)begin
						sinal = sa;
					end
					else begin
						sinal = sb;
					end
				end
			end
				
		endcase

	end

	assign r[8] = sinal;
	assign r[7:0] = rr;


endmodule