use crate::types::*;
use rand;
// use rand::rngs::StdRng;
// use rand::SeedableRng;

use crate::types::*;

#[derive(Debug, PartialEq, Clone, Copy)]
pub enum SelectionType {
  Tournament,
  Roulette
}

#[derive(Debug, PartialEq, Clone, Copy)]
pub enum CrossoverType {
  Ordered,
  PartiallyMapped
}

pub struct GAParams {
  pub epochs: u32,
  pub population_size: i32,

  pub mutation_type: MutationType,
  pub mutation_chance: f32,

  pub selection_type: SelectionType,
  pub tournament_selection_size: u32,

  pub crossover_type: CrossoverType,
  pub crossover_chance: f32,

  pub rng: rand::rngs::ThreadRng,
  // pub rng: rand::rngs::StdRng
}

impl GAParams {
  pub fn new() -> GAParams {
    GAParams{
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

  pub fn print(&self) {
    print!("Epochs:{}", self.epochs);
    print!("\nPopulation:{}", self.population_size);
    print!("\nSelection type:{:?}", self.selection_type);
    print!("\nTournament size:{}", self.tournament_selection_size);
    print!("\nMutation type:{:?}", self.mutation_type);
    print!("\nMutation chance:{}", self.mutation_chance);
    print!("\nCrossover type:{:?}", self.crossover_type);
    print!("\nCrossover chance:{}", self.crossover_chance);
  }
}