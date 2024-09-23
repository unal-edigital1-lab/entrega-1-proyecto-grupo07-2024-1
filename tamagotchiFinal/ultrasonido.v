//Realiza una medicion (HC-SR04) cuando recibe una señal init
module ultrasonido(
input clk,
input init,
input echo,
output reg trigger,
output reg done,
output reg [15:0] dist
);

parameter START=0, TRIGGER =1, ECHO =2, END =4,
BIT_echo= 32; //Tomando los bits necesarios para los ciclos correspondientes a la distancia de 5m

reg [1:0]status = 0;
reg doneEcho;
reg [31:0]perEcho;
reg doneTrigger;
reg aux;

contador #(.BIT_periodo(BIT_echo))(.clk(clk), .enable(echo), .periodo(perEcho), .done(doneEcho));
temporizador #(.BIT_fin(9), .fin(9'd500))(.clk(clk), .init(aux), .out(trigger), .done(doneTrigger));

always @(posedge clk)begin

	case(status)
		//Estado de espera
		START: begin
		done <= 0;
			if(init)begin
				aux <= 1;
				status =TRIGGER;
			end
		end
		//Envia una señal de trigger en alto por 10ns 
		TRIGGER: begin
			if(doneTrigger)begin
				aux <= 0;
				status = ECHO;
			end
		end
		//Recibe una señal Echo cuyo ancho en alto es proporcional a la distancia medida
		ECHO: begin
		done <= 1;
		dist <= perEcho*17/5000;
		if(init)begin
				status = START;
			end
		end
		default:
			status = START;
	endcase
end

endmodule