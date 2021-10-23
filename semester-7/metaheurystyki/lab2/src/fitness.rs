use crate::types::*;
use crate::helpers::*;

pub fn calc_fitness(individual: &Individual, problem: &Problem) -> f32 {
  let mut total_distance = 0f32;

  let mut curr_load = 0i32;

  for i in 0..individual.len() {
    let curr_city_number = individual[i];
    let curr_city = &problem.cities[(curr_city_number - 1) as usize];

    let prev_city_number = if i == 0 {
      0
    } else {
      individual[i - 1]
    };

    if (curr_load + curr_city.demand) > problem.capacity {
      curr_load = curr_city.demand;

      total_distance += 
        distance_between(prev_city_number, 0, problem) +
        distance_between(0, curr_city_number, problem);
    } else {
      curr_load += curr_city.demand;

      total_distance += distance_between(prev_city_number, curr_city_number, problem);
    }
  }

  // Distance from the last city to depot
  total_distance += distance_between(0, *individual.last().unwrap(), problem);

  total_distance
}