# Stepan Yurtsiv 246437
# Lista 1, zad. 3

var material_1 >= 2000, <= 6000;
var material_2 >= 3000, <= 5000;
var material_3 >= 4000, <= 7000;

var A_final_product >= 0;
var A_total_qty >= 0;
var A_material_1 >= 0;
var A_material_2 >= 0;
var A_material_3 >= 0;
var A_overall_leftover_1 >= 0;
var A_overall_leftover_2 >= 0;
var A_overall_leftover_3 >= 0;

var B_final_product >= 0;
var B_total_qty >= 0;
var B_material_1 >= 0;
var B_material_2 >= 0;
var B_material_3 >= 0;
var B_overall_leftover_1 >= 0;
var B_overall_leftover_2 >= 0;
var B_overall_leftover_3 >= 0;

var C_final_product >= 0;
var C_material_1 >= 0;
var A_C_leftover_1 >= 0;
var A_C_leftover_2 >= 0;
var A_C_leftover_3 >= 0;

var D_final_product >= 0;
var D_material_2 >= 0;
var B_D_leftover_1 >= 0;
var B_D_leftover_2 >= 0;
var B_D_leftover_3 >= 0;

var A_leftover_1_destroy >= 0;
var A_leftover_2_destroy >= 0;
var A_leftover_3_destroy >= 0;

var B_leftover_1_destroy >= 0;
var B_leftover_2_destroy >= 0;
var B_leftover_3_destroy >= 0;

maximize obj:
  A_final_product * 3 +
  B_final_product * 2.5 +
  C_final_product * 0.5 +
  D_final_product * 0.6 -
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

# Can't use more material than available
subject to mat_1: A_material_1 + B_material_1 + C_material_1 <= material_1;
subject to mat_2: A_material_2 + B_material_2 + D_material_2 <= material_2;
subject to mat_3: A_material_3 + B_material_3 <= material_3;

# Constraints for A
subject to A_material: A_total_qty == A_material_1 + A_material_2 + A_material_3;

subject to A_material_1_proportion: A_material_1 >= 0.2 * A_total_qty;
subject to A_material_2_proportion: A_material_2 >= 0.4 * A_total_qty;
subject to A_material_3_proportion: A_material_3 <= 0.1 * A_total_qty;

subject to A_leftover_1_proportion: A_overall_leftover_1 == 0.1 * A_material_1;
subject to A_leftover_2_proprotion: A_overall_leftover_2 == 0.2 * A_material_2;
subject to A_leftover_3_proportion: A_overall_leftover_3 == 0.4 * A_material_3;

subject to A_leftover_1: A_overall_leftover_1 == A_leftover_1_destroy + A_C_leftover_1;
subject to A_leftover_2: A_overall_leftover_2 == A_leftover_2_destroy + A_C_leftover_2;
subject to A_leftover_3: A_overall_leftover_3 == A_leftover_3_destroy + A_C_leftover_3;

subject to A_final: A_final_product = A_total_qty - A_overall_leftover_1 - A_overall_leftover_2 - A_overall_leftover_3;


# Constraints for B
subject to B_material: B_total_qty == B_material_1 + B_material_2 + B_material_3;

subject to B_material_1_proportion: B_material_1 >= 0.2 * B_total_qty;
subject to B_material_3_proportion: B_material_3 <= 0.3 * B_total_qty;

subject to B_leftover_1_proportion: B_overall_leftover_1 == 0.2 * B_material_1;
subject to B_leftover_2_proportion: B_overall_leftover_2 == 0.2 * B_material_2;
subject to B_leftover_3_proportion: B_overall_leftover_3 == 0.5 * B_material_3;

subject to B_leftover_1: B_overall_leftover_1 == B_leftover_1_destroy + B_D_leftover_1;
subject to B_leftover_2: B_overall_leftover_2 == B_leftover_2_destroy + B_D_leftover_2;
subject to B_leftover_3: B_overall_leftover_3 == B_leftover_2_destroy + B_D_leftover_3;

subject to B_final: B_final_product = B_total_qty - B_overall_leftover_1 - B_overall_leftover_2 - B_overall_leftover_3;

# Constraints for C
subject to C_material: C_final_product == C_material_1 + A_C_leftover_1 + A_C_leftover_2 + A_C_leftover_3;

subject to C_material_1_proportion: C_material_1 == 0.2 * C_final_product;

# Constraints for D
subject to D_material: D_final_product == D_material_2 + B_D_leftover_1 + B_D_leftover_2 + B_D_leftover_3;

subject to D_material_1_proportion: D_material_2 == 0.3 * D_final_product;

solve;

printf "\n--- Total earnings ---\n\n%d",
  A_final_product * 3 +
  B_final_product * 2.5 +
  C_final_product * 0.5 +
  D_final_product * 0.6 -
  # Destroyed leftover cost
  (A_leftover_1_destroy * 0.1 +
  A_leftover_2_destroy * 0.1 +
  A_leftover_3_destroy * 0.2 +
  B_leftover_1_destroy * 0.05 +
  B_leftover_2_destroy * 0.05 +
  B_leftover_3_destroy * 0.4 +
  # Material costs
  material_1 * 2.1 +
  material_2 * 1.6 +
  material_3 * 1);

printf "\n\n--- Products proudced ---\n\n";
printf "Product A: %f\n", A_final_product;
printf "Product B: %f\n", B_final_product;
printf "Product C: %f\n", C_final_product;
printf "Product D: %f\n", D_final_product;


printf "\n\n--- Materials to buy ---\n\n";
printf "Material 1: %f\n", material_1;
printf "Material 2: %f\n", material_2;
printf "Material 3: %f\n", material_3;

printf "\n\n--- Materials distribution ---\n\n";
printf "For product A:\n";
printf "  Material 1: %f\n", A_material_1;
printf "  Material 2: %f\n", A_material_2;
printf "  Material 3: %f\n", A_material_3;
printf "\n\nFor product B:\n";
printf "  Material 1: %f\n", B_material_1;
printf "  Material 2: %f\n", B_material_2;
printf "  Material 3: %f\n", B_material_3;
printf "\n\nFor product C:\n";
printf "  Material 1: %f\n", C_material_1;
printf "\n\nFor product D:\n";
printf "  Material 2: %f\n", D_material_2;


printf "\n\n--- Leftovers distribution ---\n\n";
printf "From A:\n";
printf "  1:\n";
printf "     overall:       %f\n", A_overall_leftover_1;
printf "     for product C: %f\n", A_C_leftover_1;
printf "     to destroy:    %f\n", A_leftover_1_destroy;
printf "  2:\n";
printf "     overall:       %f\n", A_overall_leftover_2;
printf "     for product C: %f\n", A_C_leftover_2;
printf "     to destroy:    %f\n", A_leftover_2_destroy;
printf "  3:\n";
printf "     overall:       %f\n", A_overall_leftover_3;
printf "     for product C: %f\n", A_C_leftover_3;
printf "     to destroy:    %f\n", A_leftover_3_destroy;
printf "\n\nFrom B:\n";
printf "  1:\n";
printf "     overall:       %f\n", B_overall_leftover_1;
printf "     for product D: %f\n", B_D_leftover_1;
printf "     to destroy:    %f\n", B_leftover_1_destroy;
printf "   2:\n";
printf "     overall:       %f\n", B_overall_leftover_2;
printf "     for product D: %f\n", B_D_leftover_2;
printf "     to destroy:    %f\n", B_leftover_2_destroy;
printf "   3:\n";
printf "     overall:       %f\n", B_overall_leftover_3;
printf "     for product D: %f\n", B_D_leftover_3;
printf "     to destroy:    %f\n", B_leftover_3_destroy;