use rand::Rng;
use super::init;
use super::params;
use super::selection;
use super::mutation;
use super::fitness;
use super::crossover;
use crate::types::*;

pub fn run_ga(problem: &Problem) -> Population {
  let mut the_best_fit = f32::MAX;
  let mut the_best_ind: Option<Individual> = None;

  let mut params = params::get_ga_params();

  print!("Epochs:{}", params.epochs);
  print!("\nPopulation:{}", params.population_size);
  print!("\nTournament:{:?}", params.selection_alg);
  print!("\nTournament size:{}", params.tournament_selection_size);
  print!("\nMutation chance:{}", params.mutation_chance);
  print!("\nMax seg move:{}", params.max_segment_move);
  print!("\nCrossover chance:{}", params.crossover_chance);
  print!("\nSplit seg chance:{}", params.split_segment_chance);

  let mut curr_pop: Vec<(Individual, f32)> =
    init::gen_init_population(problem, &mut params)
      .iter()
      .map(|ind| (ind.clone(), fitness::maladaptation(ind, problem)))
      .collect();

  let mut fit_sum: f32 = curr_pop.iter().map(|x| x.1).sum();

  let mut overall_fit = 0f32;
  if params.selection_alg == SelectionType::ROULETTE {
    overall_fit = curr_pop.iter().map(|x| 1f32 / x.1).sum();
  }

  for epoch in 0..params.epochs {
    let mut best_epoch_fit = f32::MAX;
    let mut worst_epoch_fit = 0f32;

    let mut next_pop: Vec<(Individual, f32)> = Vec::new();

    while next_pop.len() != (params.population_size as usize) {
      let (ind1_idx, ind2_idx)  = selection::select_two_indexes(&curr_pop, &mut params, overall_fit);

      let ind1 = &curr_pop[ind1_idx].0;

      let mut children = if params.rng.gen::<f32>() <= params.crossover_chance {
        let ind2 = &curr_pop[ind2_idx].0;
        crossover::single_point(&ind1, &ind2, &mut params)
      } else {
        vec![ind1.clone()]
      };

      for child in children.iter_mut() {
        for path in child.iter_mut() {
          mutation::mutate_random(path, &mut params);
        }

        if next_pop.len() == (params.population_size as usize) {
          break;
        }

        let fit = fitness::maladaptation(&child, problem);

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
    print!("\n{},{},{}", fit_sum / params.population_size as f32, best_epoch_fit, worst_epoch_fit);

    curr_pop = next_pop;
    fit_sum = curr_pop.iter().map(|x| x.1).sum();

    if params.selection_alg == SelectionType::ROULETTE {
      overall_fit = curr_pop.iter().map(|x| 1f32 / x.1).sum();
    }
  }

  print!("\nBest.fit:{}", the_best_fit);

  vec![the_best_ind.unwrap()]
}