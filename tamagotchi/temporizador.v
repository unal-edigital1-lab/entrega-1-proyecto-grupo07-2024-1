module temporizador #(
parameter BIT_fin=26, fin = 26'd50000000 //1 seg
)(
input clk,
input init,
output reg out,
output reg done
);

reg [BIT_fin-1:0]con = 0;
reg status = 0;
parameter START=0, COUNT=1;

always @(posedge clk) begin

	case(status)
		START: begin
			if(init)begin
				out <= 0; 
				con <= 0;
				done <=0;
				status = COUNT;
			end
		end
		COUNT: begin
			out <= 1;
			con <= con+1;
			if(con >= fin)begin
				done <= 1;
				out <= 0; 
				status = START;
			end
		end
		default:
			status= START;
	endcase
end

endmodule