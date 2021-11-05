use rand;
use rand::Rng;
use crate::helpers::*;
use crate::types::*;

fn swap(individual: &mut Individual, rng: &mut rand::rngs::ThreadRng) {
  let len = individual.len();
  let i1 = rng.gen_range(0, len);
  let i2 = rng.gen_range(0, len);

  individual.swap(i1, i2);
}

fn inverse(individual: &mut Individual, rng: &mut rand::rngs::ThreadRng) {
  let (start, end) = two_random_nums(0, individual.len() as i32, rng);

  for i in 0..(((end - start) / 2) + 1) {
    individual.swap(start + i, end - i);
  }
}

pub fn mutate(individual: &mut Individual, m_type: MutationType, rng: &mut rand::rngs::ThreadRng) {

  let mutation_alg = match m_type {
    MutationType::Swap => swap,
    MutationType::Inverse => inverse
  };

  mutation_alg(individual, rng)
} 
