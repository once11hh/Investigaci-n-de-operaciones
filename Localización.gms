$Title Location - Simple Warehouse Location Model

$ontext
There are two supply locations, two markets and three possible warehouse
locations. Only one warehouse may be built. The aim is to find the optimal
location for the warehouse given the building cost, capacity and projected
life for each warehouse and the transportation costs between the supply
locations, the warehouses and the markets. The total cost of building
the warehouse and transportation is minimized.
This model was adapted from Bruce McCarl's model called "model".
$offtext

Sets
  sl                      'supply locations'               /s1, s2/
  wh                      'warehouse locations'            /a, b, c/
  m                       'demand markets'                 /d1, d2/
  cat                     'categories for warehouse data'  /cost, capacity, life/;

Parameters
  supply(sl)              'quantity available at each supply location (units)'
    /s1 50, s2 75/
  demand(m)               'quantity required at demand market (units)'
    /d1 75, d2 50/ ;

Table
  cost_sm(sl,m)           'transportation cost for supply location to market (dollars per unit)'
             d1      d2
     s1      4       8
     s2      7       6   ;

Table
  cost_sw(sl,wh)          'transportation cost for supply location to warehouse (dollars per unit)'
             a       b      c
     s1      1       2      8
     s2      6       3      1    ;

Table
  cost_wm(wh,m)           'transportation cost for warehouse to market (dollars per unit)'
             d1      d2
     a       4       6
     b       3       4
     c       5       3     ;

Table
  data(wh,cat)            'data for warehouses, cost in dollars, capacity in units, life in years'
              cost   capacity   life
     a        500     999        10
     b        720      60        12
     c        680      70        10    ;

Variables
  tcost                   'total cost of shipping over all routes (dollars)';
Binary Variables
  build(wh)               'warehouse construction yes or no';
Positive Variables
  ship_sw(sl,wh)          'amount shipped to warehouse (units)'
    /s1.a.l 5/
  ship_wm(wh,m)           'amount shipped from warehouse (units)';
Nonnegative Variables
  ship_sm(sl,m)           'amount shipped directly to market (units)';

Equations
  tcost_eq                'total cost accounting equation (dollars)'
  supply_eq(sl)           'limit on available supply at supply location'
  demand_eq(m)            'minimum requirement at demand market'
  balance_eq(wh)          'warehouse supply demand balance'
  capacity_eq(wh)         'warehouse capacity'
    /a.scale 50, a.l 10, b.m 20/
  configure_eq            'only one warehouse';

ship_sw.up(sl,wh)= 1000;
ship_wm.scale(wh,m)= 50;
ship_sm.lo(sl,m)$(ord(sl) eq 1 and ord(m) eq 1) = 1;


tcost_eq..
  tcost =e=
    sum(wh, data(wh,"cost")/data(wh,"life")*build(wh))
    + sum((sl,m), ship_sm(sl,m)*cost_sm(sl,m))
    + sum((sl,wh), ship_sw(sl,wh)*cost_sw(sl,wh))
    + sum((wh,m), ship_wm(wh,m)*cost_wm(wh,m));

supply_eq(sl)..
  sum(m, ship_sm(sl,m)) + sum(wh, ship_sw(sl,wh)) =l= supply(sl);

demand_eq(m)..
  sum(sl, ship_sm(sl,m)) + sum(wh,ship_wm(wh,m)) =g= demand(m);

balance_eq(wh)..
  sum(m, ship_wm(wh,m)) - sum(sl, ship_sw(sl,wh)) =l= 0;

capacity_eq(wh)..
  sum(m, ship_wm(wh,m))  =l= build(wh)*data(wh,"capacity") ;

configure_eq..  sum(wh, build(wh)) =l= 1;

Model warehouse 'warehouse location model'  /all/;

solve warehouse using mip min tcost;

display build.l;

display supply_eq.l;
