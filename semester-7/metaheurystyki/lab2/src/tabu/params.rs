use crate::types::*;
use rand;
// use rand::rngs::StdRng;
// use rand::SeedableRng;

#[derive(Debug, PartialEq, Clone, Copy)]
pub enum AspirationType {
  None,
  BetterGlobalFit // TODO: implement
}

pub struct TabuParams {
  pub iter: i32,
  pub n_size: i32,
  pub tabu_size: i32,
  pub aspiration_type: AspirationType,
  pub mutation_type: MutationType,

  pub rng: rand::rngs::ThreadRng,
  // pub rng: rand::rngs::StdRng
}

impl TabuParams {
  pub fn new() -> TabuParams {
    TabuParams {
      iter: 5000,
      n_size: 20,
      tabu_size: 500,
      mutation_type: MutationType::Inverse,

      aspiration_type: AspirationType::None,
      rng: rand::thread_rng()
    }
  }

  pub fn print(&self) {
    print!("Iterations:{}", self.iter);
    print!("\nNeigh. size:{}", self.n_size);
    print!("\nTabu size:{:?}", self.tabu_size);
    print!("\nMutation type:{:?}", self.mutation_type);
    print!("\nAspiration type:{:?}", self.aspiration_type);
  }
}