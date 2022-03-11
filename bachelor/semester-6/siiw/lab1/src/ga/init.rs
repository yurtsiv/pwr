use crate::types::*;
use super::random::*;

pub fn gen_init_population(problem: &Problem, params: &mut GAParams) -> Population {
  let mut population: Population = Vec::new();

  for _ in 0..params.population_size {
    population.push(gen_random_individual(problem, params));
  }

  population
}
