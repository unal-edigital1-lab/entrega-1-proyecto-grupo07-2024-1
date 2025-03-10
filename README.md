# Entrega final Tamagotchi

### Integrantes:
- Jose Gabriel Peña Solorzano
- Cristian Camilo Barbosa Suarez
- Gabriel Felipe Ostos Iguavita

# Objetivo

Desarrollar un sistema de Tamagotchi en FPGA (Field-Programmable Gate Array) que simule el cuidado de una mascota virtual. El diseño incorporará una lógica de estados para reflejar las diversas necesidades y condiciones de la mascota, junto con mecanismos de interacción a través de sensores y botones que permitan al usuario cuidar adecuadamente de ella.

# 1. Requisitos del sistema

## 1.1 Botones

Planteamos el uso de los siguientes botones para interactuar con el sistema:

- **Reset:** Configura los valores de la mascota en un estado inicial "Feliz" que refleja condiciones optimas y define las variables de diversión, hambre y energia en un valor de 4. Esto se establece luego de pulsar el respectivo boton por 5 segundos.
- **Test:** Activa el modo de prueba al mantener pulsado por al menos 5 segundos, permitiendo al usuario navegar entre los diferentes estados del Tamagotchi con cada pulsación.
- **Jugar:** Simula jugar con la mascota virtual, por lo tanto con una pulsacion aumenta el valor de "Diversion" y disminuye el valor correspondiente a "Energia", simulando cansancio en la mascota.
- **Alimentar:** Simula suministrar alimento a la mascota, por lo que al pulsar el boton aumenta el valor correspondiente a "Hambre", lo que se explica más adelante. 
- **Curar:** Para simular esta acción en la mascota, proponemos pulsar los botones de "Jugar" y "Alimentar" de manera simultanea. La acción de curar solo debe ser posible en el estado "enfermo" y se asemeja al reset en que define las variables de "diversión", "hambre" y "energia" en un valor de 4.

## 1.2 Sistema de Sensado

Para la interacción de Tamagutchi con su entorno, se propone incorporar 3 sensores como lo son:

- **Sensor de Luz o Fotoresistencia:** Este sensor nos permite determinar los tiempos en que la mascota estara descansando, si es sometido a luz el Tamagutchi estara despierto, en caso contrario, si esta oscuro o bajo sombra estará dormido. 

- **Sensor Ultrasonido(HC-SR04):** Con este sensor queremos interactuar con el Tamagutchi para cambiar su nivel de "Diversión", si nos ubicamos cerca a la mascota el valor de este item debe conservarse, de lo contrario disminuirá progresivamente.

- **Sensor de Temperatura(DHT11)** Usando este sensor se pueden modificar los niveles de "Hambre" y de "Energia", si la temperatura es muy baja el Tamagutchi sufrirá disminución en su nivel de "Hambre", mientras que si se encuentra a altas temperaturas, la mascota tendra disminución en su valor de "Energia" reflejando cansancio.

## 1.3 Sistema de Visualizacion

Para la visualización del Tamagutchi, la representacion de sus emociones, de sus interacciones y los valores numéricos representativos de los estados se empleará el display "Nokia 5110", esto permite al usuario entender las necesidades de la mascota virtual y actuar para su bienestar. Ademas se implementa el display 7 segmentos dispuesto en la FPGA para visualizar el estado y el nivel de las emociones.

# 2. Especificaciones de Diseño

## 2.1 Estados

El Tamagutchi posee la siguiente lógica de estados que representan sus condiciones y necesidades. Los estados son los siguientes:

| **Estado** | **Binario** | **Decimal** |  
|:----------:|:-----------:|:-----------:|
|    Feliz   |     000     |      0      |
|  Aburrido  |     001     |      1      |
|   Cansado  |     010     |      2      |
| Descansando |     011     |      3      |
| Hambriento |     100     |      4      |
|   Enfermo  |     101     |      5      |
|   Muerto   |     110     |      6      |

## 2.2 Variables de transición de estados

Para controlar los cambios de estado definimos las siguientes variables:

- **Diversion(d):** Representa el nivel de diversión de la mascota en una escala de 0 a 5 donde 5 es entretenida y 1 es aburrida. Esta variable aumenta jugando con el tamagutchi; disminuye tras pasar el tiempo sin interactuar con la mascota y se conserva si el usuario le da compañia a la mascota.
- **Hambre(h):** Representa el nivel de hambre de la mascota en una escala de 0 a 5 donde 5 es llena y 1 es hambrienta. Esta variable aumenta alimentando al tamagutchi y disminuye con el tiempo, aumentando la velocidad de disminución en un ambiente frio.
- **Energia(e):** Representa el nivel de energia de la mascota en una escala de 0 a 5 donde 5 es activa y 1 es cansada. Esta variable aumenta con el tiempo mientras el tamagutchi esta en estado "descansando" y disminuye con el tiempo. La velocidad de disminución de esta variable aumenta al jugar con el tamagutchi, en un ambiente caluroso o en un ambiente oscuro.
  
Para las 3 variables ya mencionadas, un nivel de 5, 4 o 3 se consideran optimos y mantienen a la mascota en estado "feliz"; un nivel de 2 o 1 implican una necesidad y fuerzan un cambio de estado según el caso; 0 representa un estado crítico y fuerza a la mascota a pasar a estado "enfermo".

- **Oscuridad(o):** Solo pudiendo tomar valores entre 0 y 1 según el nivel de luz del ambiente. En un estado de "cansado", la oscuridad permite al tamagotchi pasar a estado "descansar". Si la mascota aun tiene energia, aumenta la velocidad de disminución de "energía" para permitirle al tamagotchi descansar.

- **enMue:** Solo toma valores entre 0 y 1 segun el tiempo que haya pasado la mascota en enfermo. Esta variable se tiene en cuenta unicamente en el estado de "enfermo" y permite el paso a "muerto" si la mascota no es curada.

## 2.3 Acciones/Interacciones:

- **Jugar:** Permite aumentar Diversion pero disminuye Energia.
- **Alimentar:** Disminuye Hambre.
- **Curar:** Permite fijar Diversion, Hambre y Energia en un valor de 4.
- **Luz:** Permite entrar al estado Descansando y disminuye la Energia.
- **Proximidad:** Evita la disminucion de Diversion.
- **Temperatura:** Disminuye la Energia o Hambre segun sea el caso.

## 2.4 Descripcion de estados

A continuación se presentan todos los estados del tamagutchi, con sus respectivas descripciones, condiciones y limitaciones de interacción, es decir, que acciones no se pueden realizar/no se tienen en cuenta en cada estado.

- **Feliz:** Representa el bienestar de la mascota. Implica que las variables diversion, hambre y energia esten todas en un nivel de 3 o superior. En este estado se ignora la accion de Curar.
- **Aburrido:** Representa falta de diversion en la mascota. Implica que el hambre y la energia tengan un nivel de 3 o superior, pero que la diversión este en 2 o en 1. En este estado se ignora la accion de Curar.
- **Cansado:** Representa falta de descanso en la mascota. Implica hambre en un nivel igual o superior a 3, pero de energía en 2 o 1. En este estado se ignoran las acciones de Curar y Jugar.
- **Descansando:** Representa a la mascota dormida. Implica energia en un nivel de 2 o 1 y que el ambiente este oscuro. En este estado se ignoran las acciones de Jugar, Alimentar, Curar ,Proximidad y Temperatura.
- **Hambriento:** Representa falta de alimentación en la mascota. Implica un nivel de hambre de 1 o 2. Ignora las acciones de Curar, Jugar, Oscuridad.
- **Enfermo:** Representa carencia en cualquiera de las necesitades de la mascota. Implica Diversion, Hambre o Energia en un nivel de 0 0.En este estado se ignoran las acciones de Jugar y Alimentar.
- **Muerto:** Luego de cierto tiempo enfermo sin curar a la mascota, esta morirá. En este estado se ignoran todas las acciones, solo siendo posible resetear el tamagutchi.

Notese que existe una jerarquia de necesidades, siendo posible pasar a "hambriento" sin importar el nivel de energia y diversión, permitiendo simplificar la máquina de estados. Esto se ve con mayor claridad en el diagrama de la máquina de estados.

# 3. Arquitectura del sistema

## 3.1 Diagramas de bloques

### 3.1.1 Diagrama general de caja negra

<div>
<p style = 'text-align:center;'>
<img src="./media/Cajanegrageneral.jpg" alt="imagen" width="800px">
</p>
</div>

La imagen muestra el diagrama de una caja negra que representa el sistema del Tamagotchi. En el diagrama, se observan varios bloques conectados entre sí que conforman los diferentes módulos y sensores del dispositivo. La caja negra recibe entradas desde botones físicos, como "JUGAR", "ALIMENTAR", "RESET", y "TEST", así como de sensores como un sensor ultrasonido HC-SR04, un sensor de temperatura DHT11 y un sensor de luz. Dentro de la caja negra, se incluyen los módulos de procesamiento, como el módulo "Measures", que recibe señales de los sensores y botones, y el módulo "procesmeas", que realiza un procesamiento adicional de las medidas. También se encuentra un módulo "maqestados" encargado de la lógica de estados del sistema.

El sistema genera salidas hacia una pantalla Nokia 5110 mediante su respectivo controlador. Además, se cuenta con un controlador de display de 7 segmentos que permite ver el estado y el valor de las variables del sistema. Todos los módulos y dispositivos están sincronizados por una señal de reloj (CLK) y otros controladores como "DivFrec" que dividen la frecuencia de reloj para su correcto funcionamiento. Este diseño permite la interacción del usuario con el Tamagotchi a través de sensores y botones, mostrando el estado de la mascota en la pantalla y en los displays visuales.

### 3.1.2 Maquina de estados principal (maqestados)

<div>
<p style = 'text-align:center;'>
<img src="./media/maqestados2.png" alt="imagen" width="600px">
</p>
</div>

Recordando que:
- Diversión(d)
- Hambre(h)
- Energia(e)
- Oscuridad(o)

Se aclara además que los botones Test y Reset controlan indirectamente los estados variando unicamente los valores de d, h y e; en vez del estado en sí mismo.

**Diagrama de caja negra:**

<div>
<p style = 'text-align:center;'>
<img src="./media/maqestadoscajanegra.jpg" alt="imagen" width="400px">
</p>
</div>

La máquina de estados define los distintos estados del tamagotchi, representados por códigos binarios de 3 bits. El sistema toma entradas de 3 bits que indican el hambre (h), energía (e), diversión (d), entradas de 1 bit como la señal de luz u oscuridad (o), así como una señal de muerte (enMue). Dependiendo de estas entradas, el tamagotchi transiciona entre los diferentes estados según las condiciones lógicas predefinidas. El estado actual se genera como salida para ser usado en la visualizacion general del sistema.

### 3.1.3 Módulo divisor de frecuencia (DivFrec)

- **Input:** Clk.
- **Output:** Sclk, Dclk.

**Especificaciones:**

- Sclk debe ser una señal periodica de frecuencia ajustable que tenga una duración corta en alto y larga en bajo, para controlar y coordinar la toma de mediciones de los sensores.
- Dclk debe ser una señal de reloj con frecuencia inferior a 4MHz (especificaciones de la pantalla Nokia5110).

**Diagrama de caja negra:**
<div>
<p style = 'text-align:center;'>
<img src="./media/DivFreccajanegra.jpg" alt="imagen" width="600px">
</p>
</div>

Notas:
1. 33554431, cuya representación binaria consiste de 25 unos.
2. dclk corresponde unicamente al 5° bit menos significativo de la salida del comparador.

**Explicación de diseño:**

- El comparador se aplica para asegurar que solo durante un ciclo de clk la salida sclk este en alto, conservandose en 0 por el resto del conteo. Para duplicar o ralentizar a la mitad la frecuencia de sclk, solo es necesario disminuir o aumentar el valor de comparación para tener un uno extra (pudiendo ser necesario también ajustar el tamaño del registro de conteo).
- Para conservar la forma de una señal de reloj convencional, dclk consiste unicamente de un bit del contador. Para duplicar o ralentizar a la mitad la frecuencia de sclk, solo es necesario conectar esta salida al bit anterior o posterior del que se usa del registro contador.

### 3.1.4 Módulo de toma de mediciones (measure)

Este módulo esta controlado por sclk. Inicializa los sensores y registra sus valores para ser trabajados posteriormente, recibe entradas como los pulsadores para jugar, alimentar, test y reset. A partir de estas entradas, el sistema genera salidas binarias que representan condiciones de temperatura (frío o calor), cercanía de un objeto, control de luz, y estados de los botones.

**Diagrama de caja negra:**

<div>
<p style = 'text-align:center;'>
<img src="./media/measures.jpg" alt="imagen" width="600px">
</p>
</div>

**Explicación de diseño:**

- Las medidas tomadas por los sensores son comparadas con valores limites definidos a criterio propio, con el objetivo de trabajar netamente con valores binarios de manera interna en el tamagotchi. Para el caso del ultrasonido se toma su salida "dist" y se convierte en una señal digital definida como "cerca" si detecta un cuerpo en un rango de 10cm(100mm). Por otra parte, en el sensor de temperatura, la salida "temp" pasa a "frio" si la medicion es menor a 15°C o pasa a "calor" si registra una temperatura mayor a 20°C.

- La activacion de la salida para la curacion del tamagotchi denominada "regcurar", se realiza unicamente si los pulsadores de jugar y alimentar son activados de manera simultanea, ademas de que solo puede estar en estado "enfermo" para realizar esta accion.

- Este modulo cuenta con una lógica para manejar los pulsadores de test y reset, con contadores que esperan 5 ciclos antes de activar estas señales de control, el tiempo de espera oscila entre 5 y 6 segundos.

### 3.1.5 Procesamiento de mediciones (procesmeas)

Este módulo actualiza valores internos de h, e y d (hreal, ereal y dreal) en base al estado actual y las entradas (sensores y pulsadores) del tamagotchi.

Es necesario hacer una distinción entre h, e y d como registros de 6 posibles valores que representan visualmente el nivel del tamagotchi con hreal, ereal y dreal, que son registros de 8 bits (256 valores) que varian cada ciclo de operación del tamagotchi según las condiciones que este experimente.

En cada ciclo estos registros pueden subir, bajar, forzarse en un valor de reset específico o conservarse en sus valores máximos o mínimos para evitar saturaciones en los registros, que pueden desembocar en que la mascota muera de hambre tras alimentarse demasiado.

**Explicación de diseño**

Se tomará como ejemplo el caso del nivel de hambre h en un estado cualquiera n (aunque el diagrama aplica para los demás niveles e y d):

<div>
<p style = 'text-align:center;'>
<img src="./media/Bloques_procesmeas.png" alt="imagen" width="700px">
</p>
</div>

En primer lugar, se puede ver como en cada ciclo de sclk se hace la conversión entre el valor hreal de 8 bits con h de solo 3. Esto se realiza con la siguiente función:

h = (hreal+nivelSize-1)/nivelSize

Donde nivelSize es el tamaño, o número de valores de hreal, asociados a un mismo nivel de h. Esto se puede entender mejor en la siguiente tabla:

|**hreal**|    **h**  |
|:-------:|:---------:|
|    0    |     0     |
|   1-51  |     1     |
|  52-102 |     2     |
| 103-153 |     3     |
| 154-204 |     4     |
| 205-255 |     5     |

A excepción del valor 0, hay 51 valores de hreal por cada nivel de h. Dado que la salida de un divisor en la fpga es por defecto un valor entero, la función mostrada previamente cumple con la relación mostrada en la tabla. Una forma de aumentar o reducir el tiempo que naturalmente le toma al tamagotchi en pasar de un estado a otro se puede hacer aumentando o reduciendo el tamaño de h, y en consecuencia ajustando el valor de nivelSize para conservar los 5 niveles qie se muestran al usuario de h.

La ventaja de trabajar internamente con registros de 255 niveles en lugar de solo 5 está en que permite complejizar el efecto que tiene cada entrada en el tamagotchi, esto se realiza en el bloque "hreal=ec.". En caso de que en dicho ciclo no se de una señal de test o reset que fuerze hreal a un valor especifico, este se actualizará en base a una ecuación que varía segun el estado del tamagotchi y las entradas que sienta en dicho ciclo. Un ejemplo de esto es la actualización de ereal en los estados aburrido y cansado:

En aburrido:
ereal = ereal - 1 - (fact2 * jugar) - (fact1 * calor) - (fact4 * regluz);

En cansado:
ereal = ereal - 1 - (fact1 * calor);

Se observa como, en aburrido, el valor de ereal depende de si el usuario juega con el tamagotchi o si este siente frio o falta de luz. Cada una de estas posibles entradas tiene un peso diferente, teniendo un mayor efecto en la ecuación el efecto de la oscuridad en el sistema. Si el tamagotchi no siente ninguna entrada, hreal simplemente disminuira en 1 valor.

En contraste, en estado cansado el peso del calor en la ecuación se conserva, pero el tamagotchi deja de considerar el efecto del calor y de la luz. Las entradas que se toman en cuenta para cada variable en cada estado estan definidas en base a las especificaciones de la sección "descripción de estados" y en base a lo que se viera conveniente en las pruebas. Por ejemplo, el hecho de que la oscuridad aumente la velocidad de disminución de ereal en estado aburrido pero no tenga efecto en cansado se justifica en que se habia especificado que la oscuridad aumente el cansancio de la mascota, pero que sea el factor que realice el cambio de estado de cansado a descansando.

En algunos estados ciertos niveles no cambiaran para conservar la jerarquia de necesidades de la mascota. En hambriento, ereal no puede variar mas allá de test o reset porque el hambre tiene mayor jerarquia que cansancio. Con esta jerarquia se busca evitar, por ejemplo, que la mascota muera de cansancio mientras esta en estado hambriento, puesto que la mascota sería incapaz de mostrar ambas necesidades a la vez y el usuario no tendria forma de saber que debe atender a ambas. Con el sistema de jerarquia, si la mascota esta hambrienta y cansada a la vez, pasar a estado hambriento, el nivel de energia se pausara y solo seguira bajando, o aumentando, cuando se atienda primero el hambre de la mascota.

Finalmente, para evitar que el registro de hreal se sature, se agrego como MSB a hreal un bit que indique dicha saturación, pero que no hace parte del valor numerico del registro. De esta manera, si los 8 bits númericos de hreal pasan de su valor máximo de 255 a su valor mínimo de 0 por una suma que sature el registro, el MSB mostara la saturación como un carry de 1 que activara una corrección al registro. Lo mismo sucede en caso de desender por debajo de 0 y pasar a un valor máximo. Esto se explica en detalle a continuación.

```verilog
if (hreal[bitsValReal] == 1 && hreal[bitsValReal-1] == 1)
  hreal <= 0;
else if (hreal[bitsValReal] == 1 && hreal[bitsValReal-1] == 0)
  hreal <= maxValue;
if (dreal[bitsValReal] == 1 && dreal[bitsValReal-1] == 1)
  dreal <= 0;
else if (dreal[bitsValReal] == 1 && dreal[bitsValReal-1] == 0)
  dreal <= maxValue;
if (ereal[bitsValReal] == 1 && ereal[bitsValReal-1] == 1)
  ereal <= 0;
else if (ereal[bitsValReal] == 1 && ereal[bitsValReal-1] == 0)
  ereal <= maxValue;
```

Este fragmento del codigo destinado para este modulo tiene como objetivo evitar la saturación de los registros en valores mínimos o máximos. Se analizan los dos bits más significativos de los registros correspondientes a las variables de transicion (h,d,e), y dependiendo de su valor, se ajustan dichos registros para evitar que se desborden por debajo del mínimo (0) o por encima del valor máximo (5). Tenemos entonces dos casos:
- Por un lado, si los dos bits más significativos de la variable son ambos 1, entonces se fuerza a que el valor de esta sea 0, evitando así una saturación por debajo de su valor mínimo. Esto se explica a partir de la representación en complemento a 2, donde si los dos bits más significativos son 11, significa que el número es negativo, debido a que el bit más significativo, en este caso 1, actúa como el bit de signo. Por tanto, la secuencia 11 sugiere que estamos tratando con un número cercano al valor más negativo posible para esa cantidad de bits.
- El otro caso, si los dos bits mas significativos son 0 y 1, se define el valor de la variable como maxValue, en este caso 5, evitando la saturacion por exceso.  Se justifica debido a que en el complemento a 2, el bit más significativo (0) indica que el número es positivo, mientras que el siguiente bit (1) sugiere que el valor es relativamente alto dentro del rango de números positivos que contiene determinado numero de bits.
  

**Caso particular (enfermo):**

Con el objetivo de observar el diagrama de flujo en funcionamiento para un estado particular, se eligio trabajar el de "enfermo", de esta manera tambien se pueden ver los cambios de las 3 variables en solo este estado. Cabe resaltar que cada estado tendra un comportamiento diferente de las variables segun la logica establecida.

<div>
<p style = 'text-align:center;'>
<img src="./media/enfermobloque.png" alt="imagen" width="600px">
</p>
</div>

Como se puede ver, en enfermo los valores de hreal, ereal y dreal que se fuerzan en caso de activarse el test son los necesarios para pasar estado enfermo. Además, se fuerza el cambio de enMue a 1 para permiteir el cambio de estado de enfermo a muerto sin considerar el contador.

En caso de no recibir una señal de reset o test, los valores de ereal, hreal o dreal no cambian. Tampoco se consideran entradas diferentes a curar. Solo se actualiza un contador que mide el tiempo que dura la mascota enferma antes de morir por falta de atención.

## 3.2 Descripcion de componentes

## Subsistemas

### Contador

- **Input:** Clk, enable.
- **Output:** Done, ciclo.

**Especificaciones:**

- Cuenta los ciclos de reloj durante los cuales enable = 1.
- Conserva el dato durante enable = 0.
- Parametro con n cantidad de bits para la salida.

**Maquina de estados:**

<div>
<p style = 'text-align:center;'>
<img src="./media/contador.jpeg" alt="imagen" width="300px">
</p>
</div>

### Temporizador

- **Input:** Clk, Init.
- **Output:** Out, Done.
- **Param:** Ciclos.

**Especificaciones:**

- Out es 1 por la cantidad de ciclos especificados al instanciar cada vez que Init = 1.

**Maquina de estados:**

<div>
<p style = 'text-align:center;'>
<img src="./media/temporizador.jpeg" alt="imagen" width="300px">
</p>
</div>

## Ultrasonido(HC-SR04)

- **Input:** Trigger.
- **Output:** Echo.
- **Rango:** 20mm

**Trabajo:**

1. Recibe una senal de trigger en alto por 10us.
2. Realiza la medicion.
3. Envia una senal en alto por echo cuya duracion es proporcional a la distancia medida.

**Especificaciones del driver:**

- Debe tener senales de init y done para facilitar la implementacion.
- Cuando init = 1, realiza una medicion.
- Done = 1 cuando haya terminado de enviar la distancia.
- Como salida entrega el valor de distancia medido en mm y lo guarda hasta que init vuelva a ser 1.

**Maquina de estados:**

<div>
<p style = 'text-align:center;'>
<img src="./media/maqestadoultrason.jpeg" alt="imagen" width="350px">
</p>
</div>

**Diagrama de flujo:**

<div>
<p style = 'text-align:center;'>
<img src="./media/Diagrama_bloques.png" alt="imagen" width="400px">
</p>
</div>

**Diagrama de caja negra:**

<div>
<p style = 'text-align:center;'>
<img src="./media/Diagrama_cajanegra.png" alt="imagen" width="700px">
</p>
</div>

**Implementacion:**

1. Distancia critica: 10cm

## Temperatura(DHT11)

- **Inout:** Data
- **Rango:** 0°-50°C

**Trabajo:**

1. Inicializacion

* Master manda un bajo por 18us
* Pull up por 20-40uS
* Slave manda un bajo por 80us 
* Pull up por 80uS

2. Medición

3. Transmisión de datos

* Antes de cada bit, slave manda un bajo por 5Ous 
* 0: un pull up por 26-28us
* 1: un pull up pur 70us

4. Slave manda un bajo por 50us al acabar la transmisión de datos

**Especificaciones del driver:**

* Debe tener init y done para facilitar la implementacion.
* Temperatura como salida con el valor de la temperatura en °C y lo guarda hasta init = 1.

**Implementacion:**

1.Temperatura critica superior: 20°C \
2.Temperatura critica inferior: 15°C
</div>

## Sensor de luz (módulo sensor de luz)
- **In:** Data

**Trabajo:**

Este sensor no requiere un driver debido a que el módulo físico ya transmite una señal de un bit según lo que reciba el sensor. La sensibilidad del sensor se puede ajustar con un potenciometro que hace perte del módulo.

## Pantalla(NOKIA 5110)

- **Output:** SDIN = Data, SCLK, D/C = Data/Command, SCE = Chip Enable, RST = Reset,  VLCD = 5Vdc.

**Trabajo:**

* El control de la pantalla consiste, de forma muy general, en el uso conjunto de tres pines: Din: con el que la pantalla recibe información de forma serial, DC: que define si esta información corresponde a un comando (DC=0) o a un dato de "pintura" de pixeles (DC=1) y CE: que habilita, al ponerse en bajo, la recepción de datos. 

* El protocolo de comunicación es SPI. Es necesario enviarle a la pantalla serialmente "paquetes" de 8 bits (bytes) a través de DIN, esto implica que la pintura de la pantalla no se hace bit a bit sino byte a byte. Así pues, cambiar un pixel de la pantalla requiere considerar los demás 7 bits que componen el byte.

* Si bien se puede mandar uno o múltiples bytes cada vez que se pone CE en bajo, la pantalla espera recibir serialmente un número de bits que sea múltiplo de 8. Si se interrumpe el envío del byte, la pantalla asumirá que los primeros bits al retomar el proximo envio corresponden a los bytes faltantes del envio interrumpido.

* Para la inicialización del periferico es necesario enviar una señal en bajo por RST a la vez que se envia una señal en bajo por CE. Tras esta operación, el pin RST sirve para cancelar el envio del byte en caso de errores.

* Adicionalmente, la señal de clk con la que se trabaja en la pantalla no debe superar los 4MHz. La pantalla toma en los flancos positivos de clk el valor de DIN, por lo que se recomienda realizar los cambios en este pin durante los flancos negativos de clk.

* Finalmente, cabe aclarar que existen versiones de este periferico que solo funcionan con un 1 lógico de 5V, por lo que para acoplarlo a la fpga puede ser necesario el uso de conversores de nivel lógico.

**Especificaciones del driver:**

* La pantalla debe mostrar el nivel de energia, hambre y diversion del tamagotchi con el formato: Letra que represente la variable, dos puntos, nivel de la variable, dos puntos, nivel de la variable en forma de número. Por ejemplo: E : 3, correspondiente al nivel de energia igual a 3.

* Debe mostrar explicitamente el estado del tamagotchi en la zona superior.

* La mascota debe tener caracteristicas visuales únicas para reflejar el estado en el que este.

**Maquina de estados:**

<div>
<p style = 'text-align:center;'>
<img src="./media/maqestadosnokia.png" alt="imagen" width="350px">
</p>
</div>

**Explicación de diseño**

Para trabajar la pantalla se utiliza un registro de 4064 bits llamado "write" donde se asignarán los valores a enviar según las entradas del driver, asi como un registro de 508 (4064/8) bits "writedc" con la secuencia correspondiente a la naturaleza de cada byte enviado, es decir, cuales bytes en write corresponden a un comando y cuales a valores de pintura.

Adicionalmente, se pueden ver parametros con los valores escritos en hexadecimal que representan las secuencias para el pintado de algunos símbolos importantes como numeros, testigos para los sensores y pulsadores del sistema, los nombres de los estados posibles del tamagotchi o el propio cuerpo de la mascota y sus posibles variaciones para expresar las necesidades que sienta.

```verilog
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
```

En el estado de RST se realiza la inicialización de la pantalla y se asignan unos valores iniciales a write para la configuración general de la pantalla. Gracias a la propiedad de que tanto write como writedc empizan con todos sus valores en 0 y el hecho de que el comando "h00" se define en el datasheet de la pantalla como un comando que no tiene efecto sobre esta, solo hay necesidad de asignar unos pocos bytes a write para efectuar correctamente la configuración de la pantalla.

```verilog
RST: begin
    cont <= cont + 1; conb <= 0;
    rst <= 0; ce <= 0;
    write[4063:4040] <= setup;			// Aqui va la cadena de seteo e impresion de constantes para din
    writedc [((bitNum-7)/8):0] <= dctest1;			// Aqui va la cadena de seteo e impresion de constantes para dc	//descomentar solo si hay problemas
    if(cont==7) status = SEND;
  end
```

El estado SEND envia bit por bit, iniciando por el MSB, los valores en write y en writedc, utilizando contadores para coordinar el envio, realizando corrimientos a write cada ciclo de reloj, a writedc cada ocho ciclos y asignando los MSB de ambos registros a su respectivo puerto de salida.

```verilog
SEND: begin
    cont <= 0; conb <= conb + 1; con_aux <= con_aux + 1;
    rst <= 1; ce <= 0; 
    din <= write[bitNum];	write <= write << 1; 			// Envio del bit y actualizacion para din
    dc <= writedc[(bitNum-7)/8]; 									// Envio del bit para dc
    if(con_aux == 7) writedc <= writedc << 1; 
    if(conb == bitNum) status = WAIT;
  end
```

Se agrega ademas un estado WAIT que se encarga de esperar unos pocos ciclos entre los estados de SEND y IDLE. Este estado es un vestigio de una primera versión del módulo que trataba el envio de cada byte dentro de su propio submodulo, en esta versión era necesario un estado de espera entre el envio de bytes puesto que tocaba actulizar el byte a enviar y deshabilitar el envio de datos para conservar la coordinación del sistema. Es necesario reconocer que este es potencialmente un estado redundante en el diseño implementado finalmente, sin embargo nunca realizamos pruebas omitiendolo y optamos por dejarlo.

Finalmente, en el estado de IDLE se asignan los valores de write y writedc mientras se espera al siguiente envío.

Cabe destacar que existen bits en write que llamamos "estaticos", es decir, bits de comando o pintura que se conservan en todos los estados del tamagotchi. Un ejemplo de bits estaticos serían los asociados a la pintura de la palabra "tamagotchi", puesto que este mensaje siempre se muestra en la pantalla. writedc es en sí mismo un estatico, ya que la secuencia de comandos y pintura no cambia.

```verilog
// Bytes estaticos (Siempre se escriben a la pantalla independientemente de las entradas)
    writedc[504:1]<=504'hffffffffffffffffffffffffffffffffffffffffffffffffffffffffffffffffffffffffffffffffffffffffffffffffffffffffffffffffffffffffffffff; //Bytes de "pintado"
    
    write[4063:4040] <= 24'h0c4080;	//Modo normal, poner cursor en el byte (0,0)
    write[527:168] <= tamagotchi;		//Pintar "tamagotchi" en la pantalla
    write[3223:3216] <= 8'h24; write[2551:2544] <= 8'h24; write[1879:1872] <= 8'h24;		//Pintar ":"
    write[3263:3232] <= hparam; write[2591:2560] <= eparam; write[1919:1888] <= dparam;	//Pintar letras "h", "e", "d"
```

Los bits dinamicos de write son espacios que dependen de las entradas del driver. Un ejemplo de bits dinamicos serían los que corresponden a los pixeles de la pantalla que imprimen el valor númerico de h, ya que este puede tener 5 posibles valores. Se puede ver entonces que se reescriben los mismos bits del registro write entre los diferentes parametros asociados a cada número según la entrada h, la dirección de estos bits reescritos corresponden a cuales bits de la totalidad del envío corresponden al valor numerico de h.

```verilog
// Bytes dinamicos (Se pintan o no segun el estado y las entradas del tamagotchi)
    case(h)	//Nivel de hambre
      0: write [3207:3176] <= num0;
      1: write [3207:3176] <= num1;
      2: write [3207:3176] <= num2;
      3: write [3207:3176] <= num3;
      4: write [3207:3176] <= num4;
      5: write [3207:3176] <= num5;
    endcase
```

Dada la forma en la que se implementó el driver de la pantalla se puede intuir el siguiente problema: asignar las direcciones en la memoria de write según el orden en que cada comando/simbolo tiene lugar en la totalidad del envío. Para esto, se consideró que la pantalla naturalmente va pintando bytes verticales de izquierda a derecha y de arriba a abajo y se asignaron a mano las direcciones en base al documento Orden que se puede encontrar en la carpeta tamagotchi del repositorio. Este orden nace a su vez del diseño realizado en pixilart.com que se puede visualizar abriendo el documento tamagotchiDiseño.pixil en dicha pagina web.

Por último, cabe aclarar que el ultimo byte del envio es un dinamico que depende de si el sistema percibe oscuridad y consiste de un comando que niega todos los pixeles de la pantalla. Asimismo, los primeros tres bytes del envio corresponden a los comandos: poner la pantalla en modo normal (por si estaba negada) y asignar el cursor de pintura en el byte (0,0) de la pantalla. Los demas bytes son de pintura; dado que la pantalla no tiene un comando para limpiar su memoria interna, es necesario limpiarla pintando activamente espacios en blanco.

# 4. Implementacion final

El codigo verilog implementado para el desarrollo del prototipo final de la mascota se encuentra en la carpeta **tamagotchiFinal**, ademas se tiene el archivo .txt que define el orden en la serie de datos que se envia periodicamente a la pantalla y el archivo .pixil donde esta el diseño del tamagotchi y los testigos en la pantalla de las interacciones.

# 5. Funcionamiento fisico

**Componentes del proyecto:**

[![Alt text](https://img.youtube.com/vi/biFUtQbGLT0/0.jpg)](https://www.youtube.com/watch?v=biFUtQbGLT0)

**Funcionamiento con interacciones externas:**

[![Alt text](https://img.youtube.com/vi/bF8Sdmfmh7Y/0.jpg)](https://www.youtube.com/watch?v=bF8Sdmfmh7Y)

**Funcionamiento TEST y RESET:**

[![Alt text](https://img.youtube.com/vi/9FcqDuONuYg/0.jpg)](https://www.youtube.com/watch?v=9FcqDuONuYg)

**Funcionamiento general del Tamagotchi:**

[![Alt text](https://img.youtube.com/vi/z3MY4BITmAo/0.jpg)](https://www.youtube.com/watch?v=z3MY4BITmAo)


