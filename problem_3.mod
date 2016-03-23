set PLANETAS;

param PROCURA_PLANETA{PLANETAS,PLANETAS};
param POSICAO_X{PLANETAS};
param POSICAO_Y{PLANETAS};

param MAX_CAPACIDADE;

param DISTANCIA{i in PLANETAS,j in PLANETAS} := sqrt((POSICAO_X[j]-POSICAO_X[i])*(POSICAO_X[j]-POSICAO_X[i])+(POSICAO_Y[j]-POSICAO_Y[i])*(POSICAO_Y[j]-POSICAO_Y[i]));

# VARIÁVEIS DE DECISÃO
var ENVIAR {i in PLANETAS,j in PLANETAS, k in PLANETAS, l in PLANETAS} >= 0;

# RESTRIÇÕES
subject to SELF {i in PLANETAS, k in PLANETAS, l in PLANETAS} : ENVIAR [i,i,k,l] <= 0;

subject to SELF2 {i in PLANETAS, j in PLANETAS, k in PLANETAS} : ENVIAR [i,j,k,k] <= 0;

subject to MAX_ENVIAR {i in PLANETAS, j in PLANETAS} : ENVIAR[i,j,i,j] >= (if PROCURA_PLANETA[i,j]<=MAX_CAPACIDADE then PROCURA_PLANETA[i,j] else MAX_CAPACIDADE);

subject to RECEBIDO {i in PLANETAS, j in PLANETAS} : sum {k in PLANETAS} ENVIAR[i,j,k,j]=PROCURA_PLANETA[i,j];

subject to ENVIADO {i in PLANETAS, j in PLANETAS} : sum {k in PLANETAS} ENVIAR[i,j,i,k]=PROCURA_PLANETA[i,j];

minimize cost: sum {i in PLANETAS, j in PLANETAS} ENVIAR[i,j,i,j]*DISTANCIA[i,j];

solve;

printf {i in PLANETAS,j in PLANETAS} "P:%d->P:%d %d\n",i,j,sum{l in PLANETAS,k in PLANETAS} ENVIAR[l,k,i,j];

printf {i in PLANETAS,j in PLANETAS,k in PLANETAS,l in PLANETAS} if(i!=j) then "ENVIAR[%d][%d][%d][%d] %d >= %d\n",i,j,k,l, ENVIAR[i,j,k,l],PROCURA_PLANETA[i,j];


data;
set PLANETAS := 1 2 3 4;
param MAX_CAPACIDADE := 300;

param POSICAO_X :=
1 69
2 18
3 14
4 29;

param POSICAO_Y :=
1 85
2 23
3 22
4 43;

param PROCURA_PLANETA : 1 2 3 4 :=
1 0       83      112     358   
2 102     0       193     243     
3 24      178     0       218   
4 37      352     428     0;

end;

