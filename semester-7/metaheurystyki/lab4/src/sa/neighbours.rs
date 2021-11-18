use crate::types::*;
use super::params::*;
use crate::mutation::*;
use crate::fitness::*;

pub fn get_best_neighbour(ind: &Individual, problem: &Problem, params: &mut SAParams) -> (Individual, f32) {
  let mut res = None;
  let mut best_fit = f32::MAX;

  for _ in 0..params.n_size {
    let mut candidate = ind.clone();
    mutate(&mut candidate, params.mutation_type, &mut params.rng);
    let fit = calc_fitness(&candidate, problem);

    if fit < best_fit {
      res = Some(candidate);
      best_fit = fit;
    }
  }

  (res.unwrap(), best_fit)
}