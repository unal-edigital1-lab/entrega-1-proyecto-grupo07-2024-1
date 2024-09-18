module measures(
	input clk,
	
	//output [0:6] sseg,   Para pruebas
   //output reg [4:0] an, Para pruebas
	
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
	output reg regtest,
	output reg regreset
);

//reg [15:0] num; Para pruebas
reg [15:0] temp;
reg [15:0] dist;
reg enable = 0;
DivFrec (.clk(clk), .sclk(clk1));
//display (.num(temp), .clk(clk), .sseg(sseg), .an(an), .rst(), .led()); Para pruebas
ultrasonido(.clk(clk), .init(enable), .echo(echo), .trigger(trigger), .done(done), .dist(dist));
dht(.clk(clk), .rst(), .dht11(dht11), .temperature(temp));

always @(posedge clk) begin
	enable <= clk1;
end

always @(posedge clk1) begin
	regluz <= luz;
	regjugar <= !jugar;
	regalimentar <= !alimentar;
	regcurar <= !jugar && !alimentar;
	regtest <= !test;
	regreset <= !reset;
	regluz <= luz;
	frio <= temp < 16'd15;
	calor <= temp > 16'd20;
	cerca <= dist < 16'd100;
end

endmodule