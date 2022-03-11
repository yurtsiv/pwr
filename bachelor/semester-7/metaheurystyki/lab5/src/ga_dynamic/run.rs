use rand::Rng;
use crate::init;
use crate::ga::selection;
use crate::mutation::*;
use crate::fitness::*;
use crate::ga::crossover::*;
use crate::types::*;
use crate::ga::params::*;
use super::params::*;
use super::dynamic_func::*;

pub fn run_ga_dynamic(problem: &Problem, params_str: &String, ga_params_str: &String) -> Population {
  let mut the_best_fit = f32::MAX;
  let mut the_best_ind: Option<Individual> = None;

  let mut params = GADynamicParams::parse(ga_params_str, params_str);

  params.ga.print();

  let mut curr_pop: Vec<(Individual, f32)> =
    init::gen_init_population(problem, params.ga.population_size, &mut params.ga.rng)
      .iter()
      .map(|ind| (ind.clone(), calc_fitness(ind, problem)))
      .collect();

  let mut fit_sum: f32 = curr_pop.iter().map(|x| x.1).sum();

  let mut overall_fit = 0f32;

  for epoch in 0..params.ga.epochs {
    params.ga.mutation_chance = next_value(epoch as f32, &params);

    let mut best_epoch_fit = f32::MAX;
    let mut worst_epoch_fit = 0f32;

    let mut next_pop: Vec<(Individual, f32)> = Vec::new();

    while next_pop.len() != (params.ga.population_size as usize) {
      let (ind1_idx, ind2_idx)  = selection::select_two_indexes(&curr_pop, &mut params.ga, overall_fit);

      let mut ind1 = &mut curr_pop[ind1_idx].0.clone();

      let mut children = if params.ga.rng.gen::<f32>() <= params.ga.crossover_chance {
        let mut ind2 = &mut curr_pop[ind2_idx].0.clone();
        crossover(&mut ind1, &mut ind2, &mut params.ga)
      } else {
        vec![ind1.clone()]
      };

      for child in children.iter_mut() {
        if params.ga.rng.gen::<f32>() > params.ga.mutation_chance {
          mutate(child, params.ga.mutation_type, &mut params.ga.rng);
        }

        if next_pop.len() == (params.ga.population_size as usize) {
          break;
        }

        let fit = calc_fitness(&child, problem);

        if fit < best_epoch_fit {
          best_epoch_fit = fit;
        }

        if fit > worst_epoch_fit {
          worst_epoch_fit = fit;
        }

        if fit < the_best_fit {
          the_best_fit = fit;
          the_best_ind = Some(child.clone());
        }

        next_pop.push((child.to_vec(), fit));
      }
    }

    // epoch
    print!("\n{}", epoch);
    // avg fitness,best fitness, worst fitness
    print!("\n{},{},{}", fit_sum / params.ga.population_size as f32, the_best_fit, worst_epoch_fit);

    curr_pop = next_pop;
    fit_sum = curr_pop.iter().map(|x| x.1).sum();
  }
  print!("\nBest.fit:{}", the_best_fit);

  vec![the_best_ind.unwrap()]
}