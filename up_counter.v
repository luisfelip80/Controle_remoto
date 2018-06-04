module up_counter(out,enable,clk,reset);
  output [7:0] out;
  input enable;
  input clk;
  input reset;
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
