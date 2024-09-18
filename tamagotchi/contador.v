module contador #(
	parameter BIT_periodo = 4
)(
	input clk,
	input enable,
	output reg [BIT_periodo-1:0] periodo,
	output reg done
);

parameter START=0, COUNT=1;
reg [BIT_periodo-1:0] con = 0;
reg status = 0;

always @(posedge clk) begin
	case(status)
		START: begin
			if(enable == 1)begin
				periodo <= 0;
				status = COUNT;
			end
		end
		COUNT: begin
			periodo <= periodo+1;
			done <= 0;
			if(enable == 0)begin
				done <=1;
				status = START;
			end
		end
		
		default:
			status = START;
	endcase
end

endmodule