module DivFrec(
	input clk, 
	output reg sclk,
	output wire dclk);

reg [24:0]maincount=0;

assign dclk = maincount[4];

always @(posedge clk) begin
	maincount <= maincount+1;
	if(maincount==25'b1111111111111111111111111) begin
		sclk <= 1;
	end else begin
		sclk <= 0;
	end
end


endmodule