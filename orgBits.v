module orgBits(ordem,b,out,in,clk,enable);
	input [7:0]ordem;
	input b;
	output reg [7:0] out;
	input [7:0]in;
	input clk; 
	input enable;
	reg cop; 
	always@(posedge clk)begin
	cop <= enable;
	if(cop)begin
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
	
	end
endmodule 