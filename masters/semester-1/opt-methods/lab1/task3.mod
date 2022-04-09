var material_1 >= 2000, <= 6000;
var material_2 >= 3000, <= 5000;
var material_3 >= 4000, <= 7000;

var A_final_product >= 0;
var A_total >= 0;
var A_material_1 >= 0;
var A_material_2 >= 0;
var A_material_3 >= 0;

var B_final_product >= 0;
var B_total >= 0;
var B_material_1 >= 0;
var B_material_2 >= 0;
var B_material_3 >= 0;

var C_produced >= 0;
var C_material_1 >= 0;
var C_leftover_1 >= 0;
var C_leftover_2 >= 0;
var C_leftover_3 >= 0;

var D_produced >= 0;
var D_material_2 >= 0;
var D_leftover_1 >= 0;
var D_leftover_2 >= 0;
var D_leftover_3 >= 0;

var A_leftover_1_destroy >= 0;
var A_leftover_2_destroy >= 0;
var A_leftover_3_destroy >= 0;

var B_leftover_1_destroy >= 0;
var B_leftover_2_destroy >= 0;
var B_leftover_3_destroy >= 0;

# param A_produced := A_material_1 * 0.9 + A_material_2 * 0.8 + A_material_3 * 0.6;
# param B_produced := B_material_1 * 0.8 + B_material_2 * 0.8 + B_material_3 * 0.5;
# param C_produced := C_material_1 + C_leftover_1 + C_leftover_2 + C_leftover_3;
# param D_produced := D_material_2 + D_leftover_1 + D_leftover_2 + D_leftover_3;

maximize obj:
  A_produced * 3 +
  B_produced * 2.5 +
  C_produced * 0.5 +
  D_produced * 0.6 +
  # Destroyed leftover cost
  A_leftover_1_destroy * 0.1 -
  A_leftover_2_destroy * 0.1 -
  A_leftover_3_destroy * 0.2 -
  B_leftover_1_destroy * 0.05 -
  B_leftover_2_destroy * 0.05 -
  B_leftover_3_destroy * 0.4 -
  # Material costs
  material_1 * 2.1 -
  material_2 * 1.6 -
  material_3 * 1;

# Spend = consume
subject to mat_1: A_material_1 + B_material_1 + C_material_1 <= material_1;
subject to mat_2: A_material_2 + B_material_2 + D_material_2 <= material_2;
subject to mat_3: A_material_3 + B_material_3 <= material_3;

# Constraints for A
subject to A_p: A_total == A_material_1 + A_material_2 + A_material_3;

subject to pAm1: A_material_1 >= 0.2 * A_produced;
subject to pAm2: A_material_2 >= 0.4 * A_produced;
subject to pAm3: A_material_3 <= 0.1 * A_produced;




subject to pBm1: B_material_1 >= 0.1 * (B_material_1 * 0.8 + B_material_2 * 0.8 + B_material_3 * 0.5);
subject to pBm3: B_material_3 <= 0.3 * (B_material_1 * 0.8 + B_material_2 * 0.8 + B_material_3 * 0.5);

subject to A_leftover_1: C_leftover_1 + A_leftover_1_destroy == 0.1 * A_material_1;
subject to A_leftover_2: C_leftover_2 + A_leftover_2_destroy == 0.2 * A_material_2;
subject to A_leftover_3: C_leftover_3 + A_leftover_3_destroy == 0.4 * A_material_3;

subject to B_leftover_1: D_leftover_1 + A_leftover_1_destroy == 0.1 * A_material_1;
subject to B_leftover_2: D_leftover_2 + A_leftover_2_destroy == 0.2 * A_material_2;
subject to B_leftover_3: D_leftover_3 + A_leftover_3_destroy == 0.4 * A_material_3;

solve;

display material_1;
display material_2;
display material_3;

display A_material_1;
display A_material_2;
display A_material_3;

display B_material_1;
display B_material_2;
display B_material_3;

display C_material_1;

display D_material_2;