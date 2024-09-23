//Dos divisores de frecuencia:
//sclk una señal periodica de 1.5Hz, alto unicamente durante un ciclo de clk y bajo el resto de tiempo. Coordina el tamagotchi.
//dclk una señal de reloj de 1.56MHz. Unicamente se usa para el display Nokia 5110
module DivFrec(
	input clk, 
	output reg sclk,
	output wire dclk);

reg [24:0]maincount=0;

//dclk
assign dclk = maincount[4];

always @(posedge clk) begin
	maincount <= maincount+1;
	//sclk en alto
	if(maincount==25'b1111111111111111111111111) begin
		sclk <= 1;
	//sclk en bajo
	end else begin
		sclk <= 0;
	end
end


endmodule