//Toma mediciones y recibe los estados de los pulsadores en base a sclk
//En varios sensores compara la medicion obtenida con valores limite y saca unicamente valores binarios
//En test y reset cuenta 5s antes de mandar las señales de ccontrol del tamagotchi
module measures(
	input clk,
	
	input echo,
	output trigger,
	
	inout wire dht11,
	
	input luz,
	
	input jugar,
	input alimentar,
	input test,
	input reset,
	
	output reg frio,
	output reg calor,
	output reg regluz,
	output reg cerca,
	output reg regjugar,
	output reg regalimentar,
	output reg regcurar,
	output reg enTest,
	output reg enReset
);

reg regtest;
reg regreset;
reg [15:0] temp;
reg [15:0] dist;
reg enable = 0;
reg [2:0]conTest = 0;
reg [2:0]conReset = 0;
DivFrec (.clk(clk), .sclk(clk1), .dclk(dclk));
ultrasonido(.clk(clk), .init(enable), .echo(echo), .trigger(trigger), .done(done), .dist(dist));
dht(.clk(clk), .rst(), .dht11(dht11), .temperature(temp));

always @(posedge clk) begin
	enable <= clk1;
end

always @(posedge clk1) begin
	regluz <= luz;
	regjugar <= !jugar;
	regalimentar <= !alimentar;
	regcurar <= !jugar && !alimentar;	//curar = jugar y alimentar a la vez
	regtest <= !test;
	regreset <= !reset;
	regluz <= luz;
	frio <= temp < 16'd15;					//frio por debajo de 15°c
	calor <= temp > 16'd20;					//calor por encima de 20°c
	cerca <= dist < 16'd100;				//El tamagotchi siente cercania a partir de los 10cm
	if(regtest) conTest <= conTest +1;
	else conTest <= 0;
	if(conTest == 4'd4) enTest <= 1;
	else enTest <= 0;
	if(regreset) conReset <= conReset +1;
	else conReset <= 0;
	if(conReset == 4'd4) enReset <= 1;
	else enReset <= 0;
end

endmodule
