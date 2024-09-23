module BCDtoSSeg (BCD, SSeg, an);

  input [3:0] BCD;
  output reg [0:6] SSeg;
  output [7:0] an;

assign an=8'b11111110;

always @ ( * ) begin // Se activa cada vez que hay un cambio en alguna de las entradas del modulo
  case (BCD) // Selecciona la salida del display de 7 segmentos basandose en el valor del puerto de entrada BCD
   4'b0000: SSeg = 7'b0000001; // "0"  
	4'b0001: SSeg = 7'b1001111; // "1"   
	4'b0010: SSeg = 7'b0010010; // "2"   
	4'b0011: SSeg = 7'b0000110; // "3"  
	4'b0100: SSeg = 7'b1001100; // "4"  
	4'b0101: SSeg = 7'b0100100; // "5"  
	4'b0110: SSeg = 7'b0100000; // "6"  
	4'b0111: SSeg = 7'b0001111; // "7"   
	4'b1000: SSeg = 7'b0000000; // "8"   
	4'b1001: SSeg = 7'b0000100; // "9"  
   4'ha: SSeg = 7'b0001000;  // Letra a 
   4'hb: SSeg = 7'b1100000;  // Letra b 
   4'hc: SSeg = 7'b1001000;  // Letra c
   4'hd: SSeg = 7'b1000010;  // Letra d
   4'he: SSeg = 7'b0110000;  // Letra e
   4'hf: SSeg = 7'b0010000;  // Letra f
    default:
    SSeg = 0;
  endcase
end
endmodule