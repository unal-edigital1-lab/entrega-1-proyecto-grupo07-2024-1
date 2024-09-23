//Maquina de estados principal del tamagotchi
//Solo transiciona entre estados segun las entradas, saca el estado actual como salida para la pantalla y los procesos logicos del sistema
module maqestados (
    input clk,
    input [2:0] h,
    input [2:0] e,  
    input [2:0] d,  
    input o,  
    input enMue,
	 
	 output reg [2:0]status
);

	 parameter FELIZ = 3'b000,
		  ABURRIDO = 3'b001,
		  CANSADO = 3'b010,
		  DESCANSO = 3'b011,
        HAMBRIENTO = 3'b100,
        ENFERMO = 3'b101,
        MUERTO = 3'b110;

    // Lógica de la máquina de estados
    always @(posedge clk) begin

        case (status)
            FELIZ: begin
                if (h < 3) status = HAMBRIENTO;
                else if (h > 2 && e < 3) status = CANSADO;
                else if (h > 2 && e > 2 && d < 3) status = ABURRIDO;
            end

            ABURRIDO: begin
                if (h > 2 && e < 3) status = CANSADO;
					 else if (d == 0) status = ENFERMO;
                else if (d > 2) status = FELIZ;
					 else if (h < 3) status = HAMBRIENTO;
            end

				CANSADO: begin
                if (o == 1) status = DESCANSO;
                else if (e == 0) status = ENFERMO;
					 else if (h < 3) status = HAMBRIENTO;
            end
				
				DESCANSO: begin
                if (o == 0 && e <3) status = CANSADO;
					 else if (o == 0 && e > 2) status = FELIZ;
            end
				
            HAMBRIENTO: begin
                if (h == 0) status = ENFERMO;
                else if (h > 2) status = FELIZ;
            end

            ENFERMO: begin
                if (enMue) status = MUERTO;
                else if (h > 2 && e > 2 && d > 2) status = FELIZ;
            end

            MUERTO: begin
					 if (h > 2 && e > 2 && d > 2) status = FELIZ;
            end
				default:
					status = 0;
        endcase
    end
endmodule