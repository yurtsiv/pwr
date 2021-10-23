use rand;

// (x, y)
pub type Point = (i32, i32);

#[derive(Debug, Clone, PartialEq)]
pub struct City {
  pub number: i32,
  pub coords: Point,
  pub demand: i32
}

#[derive(Debug, Clone)]
pub struct Problem {
  pub depot: Point,
  pub capacity: i32,
  pub cities: Vec<City>,
  pub distances: Vec<Vec<f32>>
}

#[derive(Debug, PartialEq, Clone, Copy)]
pub enum SelectionType {
  Tournament,
  Roulette
}

#[derive(Debug, PartialEq, Clone, Copy)]
pub enum MutationType {
  Swap,
  Inverse
}

#[derive(Debug, PartialEq, Clone, Copy)]
pub enum CrossoverType {
  Ordered,
  PartiallyMapped
}

pub type Individual = Vec<i32>;

pub type Population = Vec<Individual>;

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
