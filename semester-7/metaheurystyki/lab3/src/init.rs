use rand;
use crate::types::*;
use crate::random::*;

pub fn gen_init_population(problem: &Problem, size: i32, rng: &mut rand::rngs::ThreadRng) -> Population {
  let mut population: Population = Vec::new();

  for _ in 0..size {
    population.push(gen_random_individual(problem, rng));
  }

  population
}