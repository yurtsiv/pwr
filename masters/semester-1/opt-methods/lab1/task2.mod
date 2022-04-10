# Stepan Yurtsiv 246437
# Lista 1, zad. 2

set cities;
set campers;
set universal_campers;

param cost_multipliers{campers} >= 0;
param distances{cities, cities} >= 0;
param deficit{cities, campers} >= 0;
param excess{cities, campers} >= 0;

var x{cities, cities, campers} >= 0, integer;

minimize obj: sum{source_city in cities, target_city in cities, camper in campers}
  x[source_city, target_city, camper] * distances[source_city, target_city] * cost_multipliers[camper];

# move all excessive campers
subject to move_everything{source_city in cities, camper in campers}:
  sum{target_city in cities} x[source_city, target_city, camper] == excess[source_city, camper];

# allow substituting Standard campers with VIP
subject to universal_camper{target_city in cities, shared_camper in universal_campers}:
  sum{source_city in cities} x[source_city, target_city, shared_camper] >= deficit[target_city, shared_camper];

# satisfy all deficit
subject to overall_deficit{target_city in cities}:
  sum{source_city in cities, camper in campers} x[source_city, target_city, camper] == sum{camper in campers}deficit[target_city, camper];

solve;

printf "Overall cost: %f\n", sum{source_city in cities, target_city in cities, camper in campers}
  x[source_city, target_city, camper] * distances[source_city, target_city] * cost_multipliers[camper];

for {source_city in cities} {
  for {target_city in cities} {
    for {camper in campers} {
      printf if x[source_city, target_city, camper] == 0 then "" else "Move %d %s campers from %s to %s\n", x[source_city, target_city, camper], camper, source_city, target_city;
    }
  }
}

data;

set cities := Warszawa Gdansk Szczecin Wroclaw Krakow Berlin Rostok Lipsk Praga Brno Bratyslawa Koszyce Budapeszt;

set campers := Standard VIP;

# campers than can substitute any others
set universal_campers := VIP;

param cost_multipliers :=
  Standard 1.0
  VIP 1.15;

param distances: Warszawa Gdansk Szczecin Wroclaw Krakow Berlin Rostok Lipsk Praga Brno Bratyslawa Koszyce Budapeszt :=
  Warszawa   0   323  502 330 282 575 813  725 741 539 661 462  857 
  Gdansk     323 0    360 482 595 573 614  727 730 765 878 847  1084
  Szczecin   502 360  0   394 645 142 260  364 515 703 745 897  941
  Wroclaw    330 482  394 0   270 344 573  381 285 287 410 516  608
  Krakow     282 595  645 270 0   599 828  635 483 333 456 247  400
  Berlin     575 573  142 344 599 0   234  190 350 555 676 861  873
  Rostok     813 614  260 573 828 234 0    391 585 840 912 1144 1108
  Lipsk      725 727  364 381 635 190 391  0   246 454 576 884  772
  Praga      741 730  515 285 483 350 585  246 0   207 328 663  525
  Brno       539 765  703 287 333 555 840  454 207 0   130 461  326
  Bratyslawa 661 878  745 410 456 676 912  576 328 130 0   404  200
  Koszyce    462 847  897 516 247 861 1144 884 663 461 404 0    261
  Budapeszt  857 1084 941 608 400 873 1108 772 525 326 200 261  0;

param deficit: Standard VIP :=
  Warszawa   0  4
  Gdansk     20 0
  Szczecin   0  0
  Wroclaw    8  0
  Krakow     0  8
  Berlin     16 4
  Rostok     2  0
  Lipsk      3  0
  Praga      0  4
  Brno       9  0
  Bratyslawa 4  0
  Koszyce    4  0
  Budapeszt  8  0;

param excess: Standard VIP :=
  Warszawa   14 0
  Gdansk     0  2
  Szczecin   12 4
  Wroclaw    0  10
  Krakow     10 0 
  Berlin     0  0
  Rostok     0  4
  Lipsk      0  10
  Praga      10 0
  Brno       0  2
  Bratyslawa 0  8
  Koszyce    0  4
  Budapeszt  0  4;
