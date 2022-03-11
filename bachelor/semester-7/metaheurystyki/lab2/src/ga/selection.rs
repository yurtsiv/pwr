use rand;
use rand::Rng;
use rand::seq::IteratorRandom;
use crate::types::*;
use super::params::*;

fn tournament_selection(pop: &Vec<(Individual, f32)>, params: &mut GAParams, _overall_fit: f32) -> usize {
  let sample =
    pop
      .iter()
      .enumerate()
      .choose_multiple(&mut params.rng, params.tournament_selection_size as usize);

  sample
    .iter()
    .min_by(|(_, x), (_, y)| x.1.partial_cmp(&y.1).unwrap())
    .unwrap()
    .0
}

fn roulette_selection(pop: &Vec<(Individual, f32)>, params: &mut GAParams, overall_fit: f32) -> usize {
  let spot = params.rng.gen::<f32>();
  let mut count = 0f32;

  for i in 0..pop.len() {
    let chunk = (1f32 / pop[i].1) / overall_fit;
    count += chunk;
  
    if spot <= count {
      return i
    }
  }

  0
}

pub fn select_two_indexes(pop: &Vec<(Individual, f32)>, params: &mut GAParams, overall_fit: f32) -> (usize, usize) {
  let pop_len = pop.len();
  if pop_len <= 1 {
    panic!("Can't perform selection. Population is <= 1");
  }

  if pop_len == 2 {
    return (0usize, 1usize)
  }

  let selection_alg = match params.selection_type {
    SelectionType::Tournament => tournament_selection,
    SelectionType::Roulette => roulette_selection
  };

  let ind1_idx = selection_alg(pop, params, overall_fit);
  let mut ind2_idx = selection_alg(pop, params, overall_fit);

  while ind1_idx == ind2_idx {
    ind2_idx = selection_alg(pop, params, overall_fit);
  }

  (ind1_idx as usize, ind2_idx as usize)
}