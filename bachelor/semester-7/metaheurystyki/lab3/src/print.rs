use crate::types::*;

pub fn print_individual(individual: &Individual, problem: &Problem) {
  let mut curr_load = 0i32;
  let mut route_num = 1i32;

  print!("\nRoute #1:");

  for i in 0..individual.len() {
    let curr_city_number = individual[i];
    let curr_city = &problem.cities[(curr_city_number - 1) as usize];

    if (curr_load + curr_city.demand) > problem.capacity {
      curr_load = curr_city.demand;
      route_num += 1;
      print!("\nRoute #{}: {}", route_num, curr_city_number);
    } else {
      curr_load += curr_city.demand;
      print!(" {}", curr_city_number);
    }
  }
}
