OPTION LIMROW =100;
$title A Transportation Problem (TRNSPORT,SEQ=1)

$onText
This problem finds a least cost shipping schedule that meets
requirements at markets and supplies at factories.


Dantzig, G B, Chapter 3.3. In Linear Programming and Extensions.
Princeton University Press, Princeton, New Jersey, 1963.

This formulation is described in detail in:
Rosenthal, R E, Chapter 2: A GAMS Tutorial. In GAMS: A User's Guide.
The Scientific Press, Redwood City, California, 1988.

The line numbers will not match those in the book because of these
comments.

Keywords: linear programming, transportation problem, scheduling
$offText

Set
   i 'Almacenes' / A,B,C /
   j 'Clientes' / C1*C4 /;

Parameter
   a(i) 'oferta'
        / A    15
          B    25
          C     5/

   b(j) 'demanda'
        / C1   5
          C2   15
          C3   15
          C4   10/;

Table C(i,j) 'costos'
                 C1	 C2	 C3	 C4
            A    10	  0	 20	 11
            B	 12	  7	  9	 20
            C	 0	 14	 16	 18    
;

Variable
   x(i,j) 'cantidad a transportar'
   z      'Costo total de la red';

Positive Variable x;

Equation
   cost      'define objective function'
   supply(i) 'observe supply limit at plant i'
   demand(j) 'satisfy demand at market j';

cost..      z =e= sum((i,j), c(i,j)*x(i,j));

supply(i).. sum(j, x(i,j)) =e= a(i);

demand(j).. sum(i, x(i,j)) =e= b(j);

Model transport / all /;

solve transport using lp minimizing z;

display x.l, x.m;
