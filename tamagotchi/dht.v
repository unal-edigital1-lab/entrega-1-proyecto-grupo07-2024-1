module dht (
    input wire clk,       // Reloj del sistema (50 MHz)
    input wire rst,       // Reset del sistema
    inout wire dht11,     // Línea de datos del sensor DHT11
	 //--------------------------- 7 segmentos----------------------
	 output reg [15:0] temperature,
	 output wire [6:0] seg,   // Conectar a los pines del display de 7 segmentos
	 output [7:0] an
);

    reg [31:0] timer;              // Temporizador para generar pulsos de tiempo
    reg [3:0] state;               // Estado del FSM
    reg [39:0] data;               // Datos leídos del sensor
    reg dht11_out;                 // Señal de salida para el pin bidireccional
    reg dht11_dir;                 // Dirección del pin (0: entrada, 1: salida)
    reg [5:0] bit_index;           // Índice del bit a leer
	 reg [15:0] humidity;     // Humedad leída
    //reg [15:0] temperature;  // Temperatura leída
	 reg [7:0] aju_h;     // Ajuste humedad
    reg [7:0] aju_t;  // Ajuste temperatura

    // Asignación bidireccional
    assign dht11 = dht11_dir ? dht11_out : 1'bz; //Multiplexor

    // Definición de estados
    localparam ENABLE = 4'd0,
               START_SIGNAL = 4'd1,
               WAIT_RESPONSE_HIGH = 4'd2,
               WAIT_RESPONSE_LOW = 4'd3,
               READ_DATA = 4'd4,
					WAIT = 4'd5,
               PROCESS_DATA = 4'd6;

    // Temporización para generar la señal de inicio
	 localparam T_MEDIDA = 25000000;
	 // Cantidad de ciclos por reloj que debe esperar para que pase ese tiempo
    localparam T_START = 900000; // 18 ms con reloj de 50 MHz
    localparam T_WAIT = 2000;    // 40 µs con reloj de 50 MHz
    localparam T_RESPONSE = 8000; // 80 µs con reloj de 50 MHz (160us)
	 
    // Vista en 7 segmentos
	 // Inicialización de señales
    initial begin
        state = ENABLE;
		  timer = 0;
		  humidity[3:0] = 4'b1011; // 1 
	     humidity[7:4] = 4'b1010; // 2
	     //humidity[11:8] = 5'b11111; // 3
	     //humidity[15:12] = 5'b11111; // 4
		  temperature[3:0] = 4'b1011; // 1 
	     temperature[7:4] = 4'b1011; // 2
	     //temperature[11:8] = 5'b11111; // 3
	     //temperature[15:12] = 5'b11111; // 4
    end
	 

    always @(posedge clk or posedge rst) begin
        if (rst) begin
            state <= ENABLE;
            timer <= 0;
            dht11_out <= 1;
            dht11_dir <= 0;
            bit_index <= 0;
        end else begin
            case (state)
                ENABLE: begin
		              if (timer < T_MEDIDA) begin
                        timer <= timer + 1;
                    end else begin
                        timer <= 0;
								dht11_dir <= 0; // Pin en modo entrada
								state <= START_SIGNAL;
                    end
                end
                START_SIGNAL: begin
                    if (timer < T_START) begin //Contador de los primeros 18ms
                        timer <= timer + 1;
                        dht11_dir <= 1; // Pin en modo salida
                        dht11_out <= 0; // Mantener la línea baja
                    end else begin
                        timer <= 0;
                        state <= WAIT_RESPONSE_LOW;
                        dht11_out <= 1; // Mantener la línea baja
                    end
                end
                WAIT_RESPONSE_HIGH: begin
                    if (timer < T_WAIT) begin
                        timer <= timer + 1;
								dht11_dir <= 1; // Pin en modo salida para enviar durante 40 us
                    end else if (!dht11) begin
                        timer <= 0;
                        state <= WAIT_RESPONSE_HIGH;
                    end
                end
                WAIT_RESPONSE_LOW: begin
                    if (timer < T_RESPONSE) begin
                        timer <= timer + 1;
								dht11_out <= 1;
								dht11_dir <= 0;
                    end else if (dht11) begin
                        timer <= 0;
                        state <= READ_DATA;
                    end
                end
                READ_DATA: begin
                    if (bit_index < 40) begin
                        if (timer < 3900) begin
                            timer <= timer + 1;
                        end else begin
									data = data << 1;
									if (dht11) begin
										data[0] = 1;
										state <= WAIT;
									end else begin
										data[0] = 0;
									end
									bit_index <= bit_index + 1;
									timer <= 0;
                        end
                    end else begin
								bit_index <= 0;
                        state <= PROCESS_DATA;
                    end
                end
					 WAIT: begin
                    if (timer < 2100) begin
                        timer <= timer + 1;
                    end else begin
                        timer <= 0;
                        state <= READ_DATA;
                    end
                end
                PROCESS_DATA: begin
						  aju_h = data[39:32] - 8'b00101000;
						  aju_t = data[23:16] - 8'b00000111;
						  humidity[15:12] = (aju_h / 10) % 10; // 1
						  humidity[11:8] =  aju_h % 10; // 2
						  humidity[7:4] = 4'b1010; // 3
						  humidity[3:0] = 4'b1011; // 4 
						  //temperature[15:12] = (aju_t / 10) % 10; // 1
						  //temperature[11:8] =  aju_t % 10; // 2
						  //temperature[7:4] = 4'b1100; // 3
						  //temperature[3:0] = 4'b1101; // 4
						  temperature [15:0] <= aju_t;
						  timer <= 0;
                    state <= ENABLE;
                end
            endcase
        end
    end
endmodule

