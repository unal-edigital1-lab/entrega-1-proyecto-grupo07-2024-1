//Controla los niveles de h, e y d en base al estado y las entradas del tamagotchi
//Desde aqui se controla el peso de cada interaccion en los valores del tamagotchi, asi como la velocidad a la que este naturalmente reduce sus niveles internos
module procesmeas (
	input clk,
	input sclk,
	input frio,
	input calor,
	input cerca,
	input regluz,
	input jugar,
	input alimentar,
	input regcurar,
	input regtest,
	input regrst,
	input [2:0] status,
	
	output reg [2:0] h,
	output reg [2:0] d,
	output reg [2:0] e,
	output reg o,
	output reg enMue
);

parameter bitsValReal = 8, rstValue = 8'd255, lowValue = 8'd80 , maxValue = 8'd255, nivelSize = 51; //Valores por defecto
parameter fact1 = 1, fact2 = 2, fact3 = 4, fact4 = 8; //Factores de ajuste de peso de cada interaccion
reg [bitsValReal:0] hreal = rstValue;	
reg [bitsValReal:0] dreal = rstValue;
reg [bitsValReal:0] ereal = rstValue;
reg [bitsValReal-1:0] count = rstValue;

	
always @(posedge sclk) begin
		  //Ecuacion para pasar de niveles de 255 valores a solo 5 para h, d y e
		  h <= (hreal+nivelSize-1)/nivelSize;
		  d <= (dreal+nivelSize-1)/nivelSize;
		  e <= (ereal+nivelSize-1)/nivelSize;
        case (status)
            3'b000: begin //FELIZ
				enMue <= 0;
					 if (regrst) begin
						ereal = rstValue;
						hreal = rstValue;
						dreal = rstValue;
						enMue <=0;
					 end else if (regtest) begin
						 ereal = rstValue;
						 hreal = rstValue;
						 dreal = lowValue;
					 end else begin
						 o <= regluz;
						 hreal = hreal - 1 + (fact4 * alimentar) - (fact1 * frio);
						 dreal = dreal - 1 + (fact4 * jugar) + (fact3 * cerca);
						 ereal = ereal - 1 - (fact2 * jugar) - (fact1 * calor) - (fact4 * regluz);
						 
						 if (hreal[bitsValReal] == 1 && hreal[bitsValReal-1] == 1) 				hreal <= 0;
						 else if (hreal[bitsValReal] == 1 && hreal[bitsValReal-1] == 0) 		hreal <= maxValue;
						 if (dreal[bitsValReal] == 1 && dreal[bitsValReal-1] == 1)				dreal <= 0;
						 else if (dreal[bitsValReal] == 1 && dreal[bitsValReal-1] == 0)		dreal <= maxValue;
						 if (ereal[bitsValReal] == 1 && ereal[bitsValReal-1] == 1)				ereal <= 0;
						 else if (ereal[bitsValReal] == 1 && ereal[bitsValReal-1] == 0)		ereal <= maxValue;
					 end
					 
            end
            3'b001: begin //ABURRIDO
					 if (regrst) begin
						ereal = rstValue;
						hreal = rstValue;
						dreal = rstValue;
						enMue <=0;
					 end else if (regtest) begin
						 ereal = lowValue;
						 hreal = rstValue;
						 dreal = rstValue;
					 end else begin
						 o <= regluz;
						 hreal = hreal - 1 + (fact4 * alimentar) - (fact1 * frio);
						 dreal = dreal - 1 + (fact4 * jugar) + (fact3 * cerca);
						 ereal = ereal - 1 - (fact2 * jugar) - (fact1 * calor) - (fact4 * regluz);
						 
						 if (hreal[bitsValReal] == 1 && hreal[bitsValReal-1] == 1) 				hreal <= 0;
						 else if (hreal[bitsValReal] == 1 && hreal[bitsValReal-1] == 0) 		hreal <= maxValue;
						 if (dreal[bitsValReal] == 1 && dreal[bitsValReal-1] == 1)				dreal <= 0;
						 else if (dreal[bitsValReal] == 1 && dreal[bitsValReal-1] == 0)		dreal <= maxValue;
						 if (ereal[bitsValReal] == 1 && ereal[bitsValReal-1] == 1)				ereal <= 0;
						 else if (ereal[bitsValReal] == 1 && ereal[bitsValReal-1] == 0)		ereal <= maxValue;
					 end

            end
            3'b010: begin //CANSADO
					 if (regrst) begin
						ereal = rstValue;
						hreal = rstValue;
						dreal = rstValue;
						enMue <=0;
					 end else if (regtest) begin
						 ereal = rstValue;
						 hreal = lowValue;
						 dreal = rstValue;
					 end else begin
						 o <= regluz;
						 hreal = hreal - 1 + (fact4 * alimentar) - (fact1 * frio);
						 ereal = ereal - 1 - (fact1 * calor);
						 if (hreal[bitsValReal] == 1 && hreal[bitsValReal-1] == 1) 				hreal <= 0;
						 else if (hreal[bitsValReal] == 1 && hreal[bitsValReal-1] == 0) 		hreal <= maxValue;
						 if (ereal[bitsValReal] == 1 && ereal[bitsValReal-1] == 1)				ereal <= 0;
						 else if (ereal[bitsValReal] == 1 && ereal[bitsValReal-1] == 0)		ereal <= maxValue;
						 
					 end
            end
            3'b011: begin //DESCANSO
					 if (regrst) begin
						ereal = rstValue;
						hreal = rstValue;
						dreal = rstValue;
						enMue <=0;
					 end else if (regtest) begin
						 ereal = rstValue;
						 hreal = lowValue;
						 dreal = rstValue;
					 end else begin
						 o <= regluz;
						 ereal = ereal + fact4;
						 if (ereal[bitsValReal] == 1 && ereal[bitsValReal-1] == 1)				ereal <= 0;
						 else if (ereal[bitsValReal] == 1 && ereal[bitsValReal-1] == 0)		ereal <= maxValue;
					end
            end
            3'b100: begin //HAMBRIENTO
					 if (regrst) begin
						ereal = rstValue;
						hreal = rstValue;
						dreal = rstValue;
						enMue <=0;
					 end else if (regtest) begin
						 ereal = 8'd000;
						 hreal = 8'd000;
						 dreal = 8'd000;
					 end else begin
						hreal = hreal - 1 + (fact4 * alimentar) - (fact1 * frio);
						if (hreal[bitsValReal] == 1 && hreal[bitsValReal-1] == 1) 				hreal <= 0;
						else if (hreal[bitsValReal] == 1 && hreal[bitsValReal-1] == 0) 		hreal <= maxValue;
					 end
            end
            3'b101: begin //ENFERMO
					 if (regrst) begin
						ereal = rstValue;
						hreal = rstValue;
						dreal = rstValue;
						enMue <=0;
					 end else if (regtest) begin
						 ereal = 8'd000;
						 hreal = 8'd000;
						 dreal = 8'd000;
						 enMue <= 1;
					 end else begin
						 count <= count + 1;
						 if (regcurar) begin
								ereal = rstValue;
								hreal = rstValue;
								dreal = rstValue;
						 end
						 if (count == nivelSize) begin
								enMue <= 1;
								count <= 0;
						 end
					 end
            end
            3'b110: begin //MUERTO
					 if (regrst) begin
						ereal = rstValue;
						hreal = rstValue;
						dreal = rstValue;
						o <= 0; enMue <=0;
					 end else if (regtest) begin
						 ereal = rstValue;
						 hreal = rstValue;
						 dreal = rstValue;
					 end
            end
        endcase
    end	

endmodule