use rand;
// use rand::rngs::StdRng;
// use rand::SeedableRng;

use crate::types::*;
use crate::parse::*;

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
      tournament_selection_size: 5,

      mutation_type: MutationType::Swap,
      mutation_chance: 0.01f32,

      crossover_type: CrossoverType::Ordered,
      crossover_chance: 0.7f32,

      rng: rand::thread_rng(),
      // rng: StdRng::seed_from_u64(222) 
    }
  }

  pub fn parse(content: &String) -> GAParams {
    let mut lines = content.lines();

    GAParams {
      epochs: parse_uint_param(lines.next()),
      population_size: parse_int_param(lines.next()),
      selection_type: match parse_str_param(lines.next()).as_str() {
        "Tournament" => SelectionType::Tournament,
        _ => SelectionType::Roulette
      },
      tournament_selection_size: parse_uint_param(lines.next()),
      crossover_type: match parse_str_param(lines.next()).as_str() {
        "Ordered" => CrossoverType::Ordered,
        "PartiallyMapped" => CrossoverType::PartiallyMapped,
        _ => panic!("Invalid crossover type")
      },
      crossover_chance: parse_float_param(lines.next()),
      mutation_type: match parse_str_param(lines.next()).as_str() {
        "Swap" => MutationType::Swap,
        "Inverse" => MutationType::Inverse,
        _ => panic!("Invalid mutation")
      },
      mutation_chance: parse_float_param(lines.next()),

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