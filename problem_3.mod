set PLANETAS;

param PROCURA_PLANETA{PLANETAS,PLANETAS};
param POSICAO_X{PLANETAS};
param POSICAO_Y{PLANETAS};

param MAX_CAPACIDADE;

param DISTANCIA{i in PLANETAS,j in PLANETAS} := sqrt((POSICAO_X[j]-POSICAO_X[i])*(POSICAO_X[j]-POSICAO_X[i])+(POSICAO_Y[j]-POSICAO_Y[i])*(POSICAO_Y[j]-POSICAO_Y[i]));

# VARIÁVEIS DE DECISÃO
var ENVIAR {i in PLANETAS,j in PLANETAS, o in PLANETAS, f in PLANETAS} >= 0;

# RESTRIÇÕES
subject to SELF {i in PLANETAS, o in PLANETAS, f in PLANETAS} : ENVIAR [i,i,o,f] <= 0;

subject to SELF2 {i in PLANETAS, j in PLANETAS, o in PLANETAS} : ENVIAR [i,j,o,o] <= 0;

subject to MAX_ENVIAR {i in PLANETAS, j in PLANETAS} : ENVIAR[i,j,i,j] >= (if PROCURA_PLANETA[i,j]<=MAX_CAPACIDADE then PROCURA_PLANETA[i,j] else MAX_CAPACIDADE);

subject to RECEBIDO {i in PLANETAS, j in PLANETAS} : sum {o in PLANETAS} ENVIAR[i,j,o,j]=PROCURA_PLANETA[i,j];

# subject to DESCOLAGEM {i in PLANETAS, j in PLANETAS} : (if CARGA_PLANETA[j] + ENVIAR [i,j,o,j] <= MAX_CAPACIDADE then ENVIADO[j,i] else MAX_CAPACIDADE)

subject to ENVIADO {i in PLANETAS, j in PLANETAS} : sum {o in PLANETAS} ENVIAR[i,j,i,o]=PROCURA_PLANETA[i,j];

minimize cost: sum {i in PLANETAS, j in PLANETAS} ENVIAR[i,j,i,j]*DISTANCIA[i,j];

solve;

printf {i in PLANETAS,j in PLANETAS} "P:%d->P:%d %d\n",i,j,sum{f in PLANETAS,o in PLANETAS} ENVIAR[f,o,i,j];

printf {i in PLANETAS,j in PLANETAS,o in PLANETAS,f in PLANETAS} if(i!=j) then "ENVIAR[%d][%d][%d][%d] %d >= %d\n",i,j,o,f, ENVIAR[i,j,o,f],PROCURA_PLANETA[i,j];


data;
set PLANETAS := 1 2 3 4;
param MAX_CAPACIDADE := 1000;

param POSICAO_X :=
3 14
4 29
23 58
24 34;

param POSICAO_Y :=
3 22
4 43
23 59
24 29;

param PROCURA_PLANETA : 1 2 3 4 :=
3 0       218     709     120   
4 428     0       633     507     
23 135     1223     0       432   
24 447     1153     269    0;



end;

