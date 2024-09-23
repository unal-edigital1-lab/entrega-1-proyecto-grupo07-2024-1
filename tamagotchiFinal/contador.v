// Cuenta los ciclos de reloj que la entrada enable esta en alto.
module contador #(
	parameter BIT_periodo = 4					//Tamaño en bits de los ciclos esperados por instancia
)(
	input clk,
	input enable,
	output reg [BIT_periodo-1:0] periodo,
	output reg done
);

// Parametros y registros
parameter START=0, COUNT=1;		//Estados
reg status = 0;
reg [BIT_periodo-1:0] con = 0;	//Contador


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