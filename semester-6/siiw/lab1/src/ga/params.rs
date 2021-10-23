use crate::types::*;
use rand;
use rand::rngs::StdRng;
use rand::SeedableRng;

pub const RANDOM_MUTATIONS_ITER: i32 = 10000;

pub fn get_ga_params() -> GAParams {
  GAParams {
    epochs: 1000,
    population_size: 1000,
    selection_alg: SelectionType::TOURNAMENT,
    tournament_selection_size: 50,
    mutation_chance: 0.7f32,
    max_segment_move: 30,
    crossover_chance: 0.5f32,
    random_segments_max: 30,
    split_segment_chance: 0.4f32,

    rng: rand::thread_rng(),
    // rng: StdRng::seed_from_u64(222) 
  }
}

pub fn get_fitness_weights() -> FitnessWeights {
  FitnessWeights {
    intersections: 5.0,
    paths_outside_bounds: 40.0,
    total_len: 1.0,
    total_segments: 1.5,
  }
}