use crate::types::*;
use crate::helpers::*;
use crate::fitness::*;
use crate::ga::params::*;
use std::cmp::Ordering;

fn greedy(first_city_num: i32, problem: &Problem) -> Individual {
  let mut individual = vec![first_city_num];
  let mut curr_load = problem.cities[(first_city_num - 1) as usize].demand;

  loop {
    let prev_city_num = *individual.last().unwrap();

    let next_city_cand = problem
      .cities
      .iter()
      .filter(|city| !individual.contains(&city.number))
      .min_by(|a, b|
        if distance_between(prev_city_num, a.number, problem) < distance_between(prev_city_num, b.number, problem) {
          Ordering::Less
        } else {
          Ordering::Greater
        }
      );
    
    if next_city_cand == None {
      break;
    }

    let next_city = next_city_cand.unwrap();

    if (curr_load + next_city.demand) > problem.capacity {
      curr_load = 0;
      individual.push(0);
    } else {
      curr_load += next_city.demand;
      individual.push(next_city.number);
    }
  }

  individual.into_iter().filter(|x| *x != 0).collect()
}

pub fn greedy_simulation(problem: &Problem) -> Population {
  // To comply with the format
  GAParams {
    epochs: 1,
    population_size: problem.cities.len() as i32,
    selection_type: SelectionType::Tournament,
    tournament_selection_size: 70,
    mutation_type: MutationType::Swap,
    mutation_chance: 0.8f32,
    crossover_type: CrossoverType::PartiallyMapped,
    crossover_chance: 0.9f32,
    rng: rand::thread_rng(),
  }.print();

  let mut best_fit = f32::MAX;
  let mut best_ind: Option<Individual> = None;
  let mut worst_fit = 0f32;
  let mut fit_sum = 0f32;

  for i in 1..(problem.cities.len() + 1) {
    let individual = greedy(i as i32, problem);
    let fitness = calc_fitness(&individual, problem);

    fit_sum += fitness;

    if fitness < best_fit {
      best_fit = fitness;
      best_ind = Some(individual);
    } else if fitness > worst_fit {
      worst_fit = fitness;
    }
  }

  // epoch
  print!("\n1");
  // avg fitness,best fitness, worst fitness
  print!("\n{},{},{}", fit_sum / problem.cities.len() as f32, best_fit, worst_fit);

  print!("\nBest.fit:{}", best_fit);

  vec![best_ind.unwrap()]
}