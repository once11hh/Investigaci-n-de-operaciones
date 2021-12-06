
OPTION LIMROW =100;
SETS
I ORIGENES
/
IBAGUE
SANTAM
CARTAGENA
BAQLLA
/

J DESTINOS
/
SANTAM
CARTAGENA
BAQLLA
PANAMA
HONDURAS
VENEZUELA
/;


PARAMETERS
A(I) CAPACIDAD DE FABRICACION
/
IBAGUE      750
SANTAM      1150
CARTAGENA   950
BAQLLA      900
/

B(J) DEMANDA
/
SANTAM      1150
CARTAGENA   950
BAQLLA      900
PANAMA      200
HONDURAS    300
VENEZUELA   250
/;


TABLE D(I,J) COSTE DE TRANSPORTE

            SANTAM      CARTAGENA   BAQLLA      PANAMA      HONDURAS    VENEZUELA
IBAGUE      50000        40000      30000       100000      100000      100000
SANTAM      0            100000     100000      25000       25000       20000
CARTAGENA       100000       0           100000      25000       20000       20000
BAQLLA      100000       100000     0           20000       15000       15000

;

VARIABLES X(I,J), Z;
POSITIVE VARIABLE X ;

EQUATIONS COSTE, OFERTA(I),DEMANDA(J);
COSTE.. Z =E= SUM((I,J), D(I,J)*X(I,J)) ;
OFERTA(I).. SUM(J, X(I,J)) =e= A(I) ;
DEMANDA(J).. SUM(I, X(I,J)) =E= B(J) ;

MODEL TRANBOR1 /ALL/ ;
SOLVE TRANBOR1 USING LP MINIMIZING Z ;
DISPLAY X.L, X.M, Z.L ;