//Operacion del display Nokia 5110
//Manda periodicamente una cadena de 4064 bits con los valores a escribir en la pantalla
//Las instrucciones de que pintar se definen en base a las entradas del modulo variando unos registros especificos de la cadena de instrucciones
//La asignacion de la memoria se puede ver en Orden.txt
module Nokia5110 #(
	parameter bitNum = 4063, 		//numero bits a enviar por operacion (multiplo de 8) -1
	parameter bitNum_len = 12		//numero de bits necesario para guardar bitNum
	)(
	//input init,
	input clk,
	
	// Controladores
	input [2:0] stat,
	input [2:0] h,
	input [2:0] e,
	input [2:0] d,
	input calor,
	input frio,
	input cerca,
	input luz,
	input jugar,
	input alimentar,
	input test,
	input reset,
	
	// A la pantalla
	output reg rst,	// negado
	output reg ce,		// negado
	output reg dc,		// 0: command	1: data
	output reg din,
	output dclk
	);

// Para la maquina de estados
parameter RST = 0, IDLE = 1, SEND = 2, WAIT = 3;
reg [1:0] status;

// Cadenas de bits importantes
parameter setup = 24'h21c020;
parameter null =  48'h0000000000000;

parameter dot = 40'h1c7e7e7e1c;
parameter num0 = 32'h3C42423C;
parameter num1 = 32'h00427E40;
parameter num2 = 32'h7252525E;
parameter num3 = 32'h4252527E;
parameter num4 = 32'h1E10107E;
parameter num5 = 32'h4E4A4A7A;
parameter hparam = 32'h7E10107E;
parameter eparam = 32'h7E525242;
parameter dparam = 32'h7E42423C;
parameter luzparam = 8'h0d;
parameter calorparam = 48'h707472002412;
parameter frioparam  = 48'h446E44103810;
parameter cercaparam = 48'h18187E7E1818;
parameter jugarparam = 48'h302420202430;
parameter alimparam  = 48'h307878380604;
parameter testparam  = 48'h0020140C1C00;
parameter resetparam = 48'h7232524A4C4E;
parameter felizparam = 352'h7E1212020038545418007E007A0064544C440000000000000000000000000000000000000000000000000000;
parameter aburrparam = 352'h7E12127E007E48487000784078007808007808007A007048487E00304848300000000000000000000000000000;
parameter cansaparam = 352'h3C4242240030484878400078080870005C5474003048487840007048487E0030484830000000000000000000;
parameter descaparam = 352'h7E42427E0038545418005C5474003048480030484878400078080870005C5474003048483000000000000000;
parameter hambrparam = 352'h7E10107E003048487840007808700870007E484870007808007A00385454180078080870007E480030484830;
parameter enferparam = 352'h7E52524200780808700078140400385454180078080078087008700030484830000000000000000000000000;
parameter muertparam = 352'h7E0C180C7E007840780038545418007808007E48003048483000000000000000000000000000000000000000;
parameter topcomun = 304'h00000000F8FCFEFEFEFEFCF8E0E0E0F8FCFEFEFEFEFEFCF80000000000000000000000000000;
parameter topcansa = 304'h00000000F8FCFEFEFEFEFCF8E0E0E0F8FCFEFEFEFEFEFCF8007F415D5D414141414141417F1C;
parameter topdorm1 = 304'h00000000F8FCFEFEFEFEFCF8E0E0E0F8FCFEFEFEFEFEFCF800E8B8003A2E001D170000000000;
parameter topdorm2 = 304'hB8EB0E001F3F7F7F7F7F3F1F0707071F3F7F7F7F7F7F3F1F0000000000000000000000000000;
parameter uppercomun1 = 224'hC0300C06874727E727E7C70707070707874727E727E7C707060C30C0;
parameter uppercomun2 = 224'h030C3060E1E3E4E7E4E4E30E0E0E0E0EE1E3E4E7E4E4E3E060300C03;
parameter uppercansad = 224'hC0300C06874727E727E7C70707070707874727E727E7C707060C30C0;
parameter upperdormid = 224'hC0300C060787878787878787070707078787878787878707060C30C0;
parameter uppermuerto = 224'hC0300C060707478707874707070707074787078747070707060C30C0;
parameter lowerfel1 = 224'h0F30408081020407070713202020202021120407070703808040300F;
parameter lowerfel2 = 224'h030C3060E1C0E0E02020C8040404040484C8E0E02020C00101020CF0;
parameter lowerabu1 = 224'h0F30408081030707040443605050505061430707040403808040300F;
parameter lowerabu2 = 224'hF00C0201814020E0E0E0C2060A0A0A0A864220E0E0E0C00101020CF0;
parameter lowercans = 224'h0F30408081020407070743605050505061420407070703808040300F;
parameter lowerdorm = 224'h0F30408080000000000000101010101010000000000000808040300F;
parameter lowerham1 = 224'h0F30408081020407070713202020E0E0E1320407070703808040300F;
parameter lowerham2 = 224'h030C3060E1C0E0E02020C8070707040484CCE0E02020C00101020CF0;
parameter lowerenf1 = 224'h0F314284F97A7C7F7F7F7B7878787878797A7C7F7F7F7BF88442310F;
parameter lowerenf2 = 224'hF08C42219FDEFEFEFE3EDE1E1E1E1E1E9EDEFEFEFE3FDE1F21428CF0;
parameter lowermuer = 224'h0F30408080000402010204005020500004020102040000808040300F;
parameter bodycomun1 = 144'h192523394141212121216161818179232519;
parameter bodycomun2 = 144'h98A4C49E818186848484848482829CC4A498;
parameter bodymuerto = 144'h192523798181612121216161818179232519;
parameter tamagotchi = 360'h0202027E02324A4A7A42027A0A720A7202324A4A7A400C52523E0030484830007E4800304848007E1010600074;
parameter test2 = 48'hffffffffffff;
parameter dctest1 = 6'b000000;

// Registros internos
reg [2:0] cont; 		//contador de un bit
reg [bitNum_len-1:0] conb;	//cuenta por cada bit enviado
reg [2:0] con_aux; //contador auxiliar hasta 7
reg [bitNum:0] write; //secuencia a transmitir
reg [((bitNum-7)/8):0] writedc; //secuencia a transmitir
reg [1:0] tempe;

DivFrec(.clk(clk), .sclk(init), .dclk(dclk)); 

always @(negedge dclk)begin

	case(status)
		// Inicializacion de la pantalla
		RST: begin
			cont <= cont + 1; conb <= 0;
			rst <= 0; ce <= 0;
			write[4063:4040] <= setup;			// Aqui va la cadena de seteo e impresion de constantes para din
			writedc [((bitNum-7)/8):0] <= dctest1;			// Aqui va la cadena de seteo e impresion de constantes para dc	//descomentar solo si hay problemas
			if(cont==7) status = SEND;
		end
		// Asignacion de valores a enviar y espera d señal de envio
		IDLE: begin
			cont <= 0;
			tempe[1] <= calor;
			tempe[0] <= frio;
			
			// Bytes estaticos (Siempre se escriben a la pantalla independientemente de las entradas)
			writedc[504:1]<=504'hffffffffffffffffffffffffffffffffffffffffffffffffffffffffffffffffffffffffffffffffffffffffffffffffffffffffffffffffffffffffffffff; //Bytes de "pintado"
			
			write[4063:4040] <= 24'h0c4080;	//Modo normal, poner cursor en el byte (0,0)
			write[527:168] <= tamagotchi;		//Pintar "tamagotchi" en la pantalla
			write[3223:3216] <= 8'h24; write[2551:2544] <= 8'h24; write[1879:1872] <= 8'h24;		//Pintar ":"
			write[3263:3232] <= hparam; write[2591:2560] <= eparam; write[1919:1888] <= dparam;	//Pintar letras "h", "e", "d"
			// Bytes dinamicos (Se pintan o no segun el estado y las entradas del tamagotchi)
			case(h)	//Nivel de hambre
				0: write [3207:3176] <= num0;
				1: write [3207:3176] <= num1;
				2: write [3207:3176] <= num2;
				3: write [3207:3176] <= num3;
				4: write [3207:3176] <= num4;
				5: write [3207:3176] <= num5;
			endcase
			case(e)	//Nivel de energia
				0: write [2535:2504] <= num0;
				1: write [2535:2504] <= num1;
				2: write [2535:2504] <= num2;
				3: write [2535:2504] <= num3;
				4: write [2535:2504] <= num4;
				5: write [2535:2504] <= num5;
			endcase
			case(d)	//Nivel de diversion
				0: write [1863:1832] <= num0;
				1: write [1863:1832] <= num1;
				2: write [1863:1832] <= num2;
				3: write [1863:1832] <= num3;
				4: write [1863:1832] <= num4;
				5: write [1863:1832] <= num5;
			endcase
			case(stat)	//Cuerpo del tamagotchi segun el estado
				0: begin
					write[3879:3528] <= felizparam;
					write[3143:2840] <= topcomun;
					write[2471:2248] <= uppercomun1;
					write[1799:1576] <= lowerfel1;
					write[1087:944] <= bodycomun1;
				end
				1: begin
					write[3879:3528] <= aburrparam;
					write[3143:2840] <= topcomun;
					write[2471:2248] <= uppercomun1;
					write[1799:1576] <= lowerabu1;
					write[1087:944] <= bodycomun1;
				end
				2: begin
					write[3879:3528] <= cansaparam;
					write[3143:2840] <= topcansa;
					write[2471:2248] <= uppercansad;
					write[1799:1576] <= lowercans;
					write[1087:944] <= bodycomun1;
				end
				3: begin
					write[3879:3528] <= descaparam;
					write[2471:2248] <= upperdormid;
					write[1799:1576] <= lowerdorm;
					write[1087:944] <= bodymuerto;
					write[3143:2840] <= topdorm1;
				end
				4: begin
					write[3879:3528] <= hambrparam;
					write[3143:2840] <= topcomun; 
					write[2471:2248] <= uppercomun1;
						write[1799:1576] <= lowerham1;
						write[1087:944] <= bodycomun1;
				end
				5: begin
					write[3879:3528] <= enferparam;
					write[3143:2840] <= topcomun; 
					write[2471:2248] <= uppercomun1;
					write[1799:1576] <= lowerenf1;
					write[1087:944] <= bodycomun1;
				end
				6: begin
					write[3879:3528] <= muertparam;
					write[3143:2840] <= topcomun;
					write[2471:2248] <= uppermuerto;
					write[1799:1576] <= lowermuer;
					write[1087:944] <= bodymuerto;
				end
				endcase
			case(tempe)	//Testigo de temperatura
			3: write[1199:1152]<=null;
			2: write[1199:1152]<= calorparam;
			1: write[1199:1152]<= frioparam;
			0: write[1199:1152]<=null;
			endcase
			case(cerca) //Testigo del sensor de distancia
			1: write[1255:1208] <= cercaparam;
			0: write[1255:1208] <=null;
			endcase
			case(luz) //Testigo de luz (comando que invierte todos los pixeles de la pantalla al final del envio a la pantalla)
			1: write[7:0] <=luzparam;
			0: write[7:0] <= null;
			endcase
			case(jugar) //Testigo de pulsador para jugar
			0: write[831:784] <= jugarparam;
			1: write[831:784] <= null;
			endcase
			case(alimentar) //Testigo de pulsador para alimentar
			0: write[887:840] <= alimparam;
			1: write[887:840] <=null;
			endcase
			case(test) //Testigo de pulsador para test
			0: write[2175:2128] <= testparam;
			1: write[2175:2128] <=null;
			endcase
			case(reset) //Testigo de pulsador para reset
			0: write[1503:1456] <= resetparam;
			1: write[1503:1456] <=null;
			endcase
			// cambio de estado
			if(init) status = SEND;
		end
		//Manda serialmente los valores de write y writedc a la pantalla
		SEND: begin
			cont <= 0; conb <= conb + 1; con_aux <= con_aux + 1;
			rst <= 1; ce <= 0; 
			din <= write[bitNum];	write <= write << 1; 			// Envio del bit y actualizacion para din
			dc <= writedc[(bitNum-7)/8]; 									// Envio del bit para dc
			if(con_aux == 7) writedc <= writedc << 1; 
			if(conb == bitNum) status = WAIT;
		end
		//Estado intermedio, deberia sobrar
		WAIT: begin
			cont <= cont + 1; conb <= 0;
			ce <= 1;
			if(cont==7) status = IDLE;
		end
		default: status = RST;
	endcase
end

endmodule
