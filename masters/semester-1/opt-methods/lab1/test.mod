# Jakub Gogola, 236412
# Lista 1, zadanie 3

# raw materials
var mat_1 >= 2000, <= 6000;
var mat_2 >= 3000, <= 5000;
var mat_3 >= 4000, <= 7000;

# products
var prod_A, >= 0;
var total_qty_for_A, >= 0;
var qty_A1, >=0;
var qty_A2, >= 0;
var qty_A3, >=0;
var waste_A1, >=0;
var waste_A2, >= 0;
var waste_A3, >= 0;
var waste_A1_to_destroy, >= 0;
var waste_A2_to_destroy, >= 0;
var waste_A3_to_destroy, >= 0;

var prod_B, >= 0;
var total_qty_for_B, >= 0;
var qty_B1, >=0;
var qty_B2, >= 0;
var qty_B3, >=0;
var waste_B1, >=0;
var waste_B2, >= 0;
var waste_B3, >= 0;
var waste_B1_to_destroy, >= 0;
var waste_B2_to_destroy, >= 0;
var waste_B3_to_destroy, >= 0;

var prod_C, >= 0;
var qty_C1, >= 0;
var waste_1_from_A, >= 0;
var waste_2_from_A, >= 0;
var waste_3_from_A, >= 0;

var prod_D, >= 0;
var qty_D2, >= 0;
var waste_1_from_B, >= 0;
var waste_2_from_B, >= 0;
var waste_3_from_B, >= 0;


maximize cost_func: 3.0 * prod_A + 2.5 * prod_B + 0.6 * prod_C + 0.5 * prod_D
    - (2.1 * mat_1 + 1.6 * mat_2 + 1.0 * mat_3)
    - (0.1 * waste_A1_to_destroy + 0.1 * waste_A2_to_destroy + 0.2 * waste_A3_to_destroy)
    - (0.05 * waste_B1_to_destroy + 0.05 * waste_B2_to_destroy + 0.4 * waste_B3_to_destroy);

# qunatity of used materials
subject to mat_1_quantity: mat_1 >= qty_A1 + qty_B1 + qty_C1;
subject to mat_2_quantity: mat_2 >= qty_A2 + qty_B2 + qty_D2;
subject to mat_3_quantity: mat_3 >= qty_A3 + qty_B3;

# prod A constraints
subject to prod_A_ingredients: total_qty_for_A == qty_A1 + qty_A2 + qty_A3;
subject to mat_1_in_prod_A: qty_A1 >= 0.2 * prod_A;
subject to mat_2_in_prod_A: qty_A2 >= 0.4 * prod_A;
subject to mat_3_in_prod_A: qty_A3 <= 0.1 * prod_A;

subject to waste_of_1_from_A: waste_A1 = 0.1 * qty_A1;
subject to waste_of_2_from_A: waste_A2 = 0.2 * qty_A2;
subject to waste_of_3_from_A: waste_A3 = 0.4 * qty_A3;

subject to final_qty_of_A: prod_A = total_qty_for_A - waste_A1 - waste_A2 - waste_A3;

# prod B constraints
subject to prod_B_ingredients: total_qty_for_B = qty_B1 + qty_B2 + qty_B3;

subject to mat_1_in_prod_B: qty_B1 >= 0.1 * prod_B;
subject to mat_3_in_prod_V: qty_B3 <= 0.3 * prod_B;

subject to waste_of_1_from_B: waste_B1 = 0.2 * qty_B1;
subject to waste_of_2_from_B: waste_B2 = 0.2 * qty_B2;
subject to waste_of_3_from_B: waste_B3 = 0.5 * qty_B3;

subject to final_qty_of_B: prod_B = total_qty_for_B - waste_B1 - waste_B2 - waste_B3;

# prod C constraints
subject to prod_C_ingredients: prod_C = qty_C1 + waste_1_from_A + waste_2_from_A + waste_3_from_A;
subject to mat_1_in_prod_C: qty_C1 = 0.2 * prod_C;

subject to waste_1_from_A_relation: waste_1_from_A <= waste_A1;
subject to waste_2_from_A_relation: waste_2_from_A <= waste_A2;
subject to waste_3_from_A_relation: waste_3_from_A <= waste_A3;

subject to waste_1_from_A_to_destroy: waste_A1_to_destroy = waste_A1 - waste_1_from_A;
subject to waste_2_from_A_to_destroy: waste_A2_to_destroy = waste_A2 - waste_2_from_A;
subject to waste_3_from_A_to_destroy: waste_A3_to_destroy = waste_A3 - waste_3_from_A;


# prod D constraints
subject to prod_D_ingredients: prod_D == qty_D2 + waste_1_from_B + waste_2_from_B + waste_3_from_B;
subject to mat_2_in_prod_D: qty_D2 = 0.3 * prod_D;

subject to waste_1_from_B_relation: waste_1_from_B <= waste_B1;
subject to waste_2_from_B_relation: waste_2_from_B <= waste_B2;
subject to waste_3_from_B_relation: waste_3_from_B <= waste_B3;

subject to waste_1_from_B_to_destroy: waste_B1_to_destroy = waste_B1 - waste_1_from_B;
subject to waste_2_from_B_to_destroy: waste_B2_to_destroy = waste_B2 - waste_2_from_B;
subject to waste_3_from_B_to_destroy: waste_B3_to_destroy = waste_B3 - waste_3_from_B;

solve;

display qty_A1;
display qty_B1;
display qty_C1;