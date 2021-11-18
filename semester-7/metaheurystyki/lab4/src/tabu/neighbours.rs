use crate::types::*;
use super::list::*;
use super::params::*;
use crate::mutation::*;
use crate::fitness::*;

pub fn get_best_neighbour(ind: &Individual, tabu_list: &TabuList, problem: &Problem, params: &mut TabuParams) -> (Individual, f32, f32, f32) {
  let mut res = None;
  let mut best_fit = f32::MAX;
  let mut worst_fit = 0f32;
  let mut fit_sum = 0f32;

  for _ in 0..params.n_size {
    let mut candidate = ind.clone();
    mutate(&mut candidate, params.mutation_type, &mut params.rng);
    let fit = calc_fitness(&candidate, problem);

    if fit < best_fit && !tabu_list.contains(&candidate) {
      res = Some(candidate);
      best_fit = fit;
    }

    if fit > worst_fit {
      worst_fit = fit;
    }

    fit_sum += fit;
  }

  (res.unwrap(), best_fit, worst_fit, fit_sum / params.n_size as f32)
}