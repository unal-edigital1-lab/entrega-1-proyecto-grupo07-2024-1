`timescale 1ns / 1ps
module fulldisplay(
    input [31:0] num,
    input clk,
    output [0:6] sseg,
    output reg [7:0] an,
	 input rst,
	 output led
    );

reg [3:0]bcd=0;
 
BCDtoSSeg bcdtosseg(.BCD(bcd), .SSeg(sseg));

reg [26:0] cfreq=0;
wire enable;

// Divisor de frecuecia

assign enable = cfreq[16];
assign led =enable;
always @(posedge clk) begin
  if(rst==0) begin
		cfreq <= 0;
	end else begin
		cfreq <=cfreq+1;
	end
end

reg [2:0] count = 0;
always @(posedge enable) begin
		if(rst==0) begin
			count<= 0;
			an<=8'b11111111; 
		end else begin 
			count<= count+1;
			case (count) 
				3'h0: begin bcd <= num[31:28];an<=8'b11111110; end 
				3'h1: begin bcd <= num[27:24];an<=8'b11111101; end 
				3'h2: begin bcd <= num[23:20];an<=8'b11111011; end 
				3'h3: begin bcd <= num[19:16];an<=8'b11110111; end 
				3'h4: begin bcd <= num[15:12];an<=8'b11101111; end 
				3'h5: begin bcd <= num[11:8]; an<=8'b11011111; end 
				3'h6: begin bcd <= num[7:4];  an<=8'b10111111; end 
				3'h7: begin bcd <= num[3:0];  an<=8'b01111111; end 
			endcase
		end
end
endmodule