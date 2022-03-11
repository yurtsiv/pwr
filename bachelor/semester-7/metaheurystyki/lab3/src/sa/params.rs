use crate::types::*;
use rand;
// use rand::rngs::StdRng;
// use rand::SeedableRng;

#[derive(Debug, PartialEq, Clone, Copy)]
pub enum CoolingType {
  Linear,
  Exponential,
  InverseExponential
}

pub struct SAParams {
  pub iter: i32,
  pub n_size: i32,
  pub start_temp: f32,
  pub mutation_type: MutationType,
  pub cooling_type: CoolingType,

  pub rng: rand::rngs::ThreadRng
  // pub rng: rand::rngs::StdRng
}

impl SAParams {
  pub fn new() -> SAParams {
    SAParams {
      iter: 20000,
      n_size: 20,
      start_temp: 20.0,
      mutation_type: MutationType::Inverse,
      cooling_type: CoolingType::Linear,

      rng: rand::thread_rng()
    }
  }

  pub fn print(&self) {
    print!("Iterations:{}", self.iter);
    print!("\nNeigh. size:{}", self.n_size);
    print!("\nStart temp.:{:?}", self.start_temp);
    print!("\nMutation type:{:?}", self.mutation_type);
    print!("\nCooloing type:{:?}", self.cooling_type);
  }
}