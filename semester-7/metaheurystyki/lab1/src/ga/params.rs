use crate::types::*;
use rand;
// use rand::rngs::StdRng;
// use rand::SeedableRng;

pub fn get_ga_params() -> GAParams {
  GAParams {
    epochs: 1000,
    population_size: 100,

    selection_type: SelectionType::Tournament,
    tournament_selection_size: 70,
  
    mutation_type: MutationType::Swap,
    mutation_chance: 0.8f32,

    crossover_type: CrossoverType::PartiallyMapped,
    crossover_chance: 0.9f32,

    rng: rand::thread_rng(),
    // rng: StdRng::seed_from_u64(222) 
  }
}
