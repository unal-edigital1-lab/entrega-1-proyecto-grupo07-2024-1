module tamagotchi(
	input clk,
	input inx,
	input echo,
	output trigger,
	inout wire dht11,
	input luz,
	input jugar,
	input alimentar,
	input test,
	input reset,
	output [0:6] sseg,
   output [7:0] an,
	output reg testx,
	output reg led1,
	
	output rst,	//Negado
	output ce,	//Negado
	output dc,	// 0: command	1: data
	output din,
	output dclk
);

reg [31:0] num;
reg [2:0] status;

reg [2:0] h;  
reg [2:0] e;
reg [2:0] d;
DivFrec(.clk(clk), .sclk(sclk), .dclk());
fulldisplay(.num(num), .clk(clk), .sseg(sseg), .an(an), .rst(1), .led(led));
Nokia5110V2(.clk(clk), .stat(status), .h(h), .d(d), .e(e), .calor(calor), .frio(frio), .cerca(cerca), .luz(luz), .jugar(jugar), .alimentar(alimentar), .test(test), .reset(reset), .rst(rst), .ce(ce), .dc(dc), .din(din), .dclk(dclk));

    measures measures (
        .clk(clk),
		  .sseg(),
		  .an(),
		  .echo(echo),
		  .trigger(trigger),
		  .dht11(dht11),
		  .luz(luz),
		  .jugar(jugar),
        .alimentar(alimentar),
		  .test(test),
		  .reset(reset),
		  .frio(frio),
        .calor(calor),
		  .regluz(regluz),
        .cerca(cerca),
		  .regjugar(regjugar),
        .regalimentar(regalimentar),
        .regcurar(regcurar),
        .regtest(regtest),
        .regreset(regreset)
    );

    procesmeas process_measures (
        .clk(clk),
        .sclk(sclk),
        .frio(frio),
        .calor(calor),
        .cerca(cerca),
        .regluz(regluz),
        .jugar(regjugar),
        .alimentar(regalimentar),
        .regcurar(regcurar),
        .regtest(regtest),
        .regrst(regreset),
        .status(status),
        .h(h),
        .d(d),
        .e(e),
        .o(o),
        .enMue(enMue)
    );

    maqestados state_machine (
        .clk(sclk),
        .h(h),
        .e(e),
        .d(d),
        .o(o),
        .enMue(enMue),
        .status(status)
    );

always @(posedge clk)begin
	testx <= inx;
	led1 <= cerca;
	num[31:28] <= 4'he;
	num[23:20] <= 4'hd; 
	num[15:12] <= 4'hc;
	num[7:4] <= 4'hf;
	num[26:24] <= status;
	num[18:16] <= d;
	num[10:8] <= h;
	num[2:0] <= e;
end

endmodule