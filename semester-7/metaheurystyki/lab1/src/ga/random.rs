use crate::types::*;
use crate::ga::params;
use crate::ga::fitness;
use crate::print::*;

use rand;
use rand::seq::SliceRandom;

pub fn gen_random_individual(problem: &Problem, params: &mut GAParams) -> Individual {
  let mut individual: Individual = (1..(problem.cities.len() as i32 + 1)).collect();
  individual.shuffle(&mut params.rng);

  individual
}

pub fn random_simulation(problem: &Problem) -> Population {
  let mut the_best_fit = f32::MAX;
  let mut the_best_ind: Option<Individual> = None;

  let mut params = params::get_ga_params();
  print_params(&params);

  for epoch in 0..params.epochs {
    let mut best_epoch_fit = f32::MAX;
    let mut worst_epoch_fit = 0f32;
    let mut fit_sum = 0f32;

    for _ in 0..params.population_size {
      let individual = gen_random_individual(problem, &mut params);
  
      let fit = fitness::calc_fitness(&individual, problem);

      fit_sum += fit;

      if fit < best_epoch_fit {
        best_epoch_fit = fit;
      }

      if fit > worst_epoch_fit {
        worst_epoch_fit = fit;
      }

      if fit < the_best_fit {
        the_best_fit = fit;
        the_best_ind = Some(individual.clone());
      }
    }

    // epoch
    print!("\nEpoch: {}", epoch);
    // avg fitness,best fitness, worst fitness
    print!("\n{},{},{}", fit_sum / params.population_size as f32, best_epoch_fit, worst_epoch_fit);
  }

  print!("\nBest.fit:{}", the_best_fit);

  vec![the_best_ind.unwrap()]
}