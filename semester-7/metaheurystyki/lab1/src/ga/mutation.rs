use rand;
use rand::Rng;
use crate::helpers::*;
use crate::types::*;

fn swap(individual: &mut Individual, params: &mut GAParams) {
  let len = individual.len();
  let i1 = params.rng.gen_range(0, len);
  let i2 = params.rng.gen_range(0, len);

  individual.swap(i1, i2);
}

fn inverse(individual: &mut Individual, params: &mut GAParams) {
  let (start, end) = two_random_nums(0, individual.len() as i32, params);

  for i in 0..(((end - start) / 2) + 1) {
    individual.swap(start + i, end - i);
  }
}

pub fn mutate(individual: &mut Individual, params: &mut GAParams) {
  if params.rng.gen::<f32>() > params.mutation_chance {
    return
  }

  let mutation_alg = match params.mutation_type {
    MutationType::Swap => swap,
    MutationType::Inverse => inverse
  };

  mutation_alg(individual, params)
} 
