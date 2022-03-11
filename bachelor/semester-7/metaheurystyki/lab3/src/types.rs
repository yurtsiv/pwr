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
pub enum MutationType {
  Swap,
  Inverse
}

pub type Individual = Vec<i32>;
pub type Population = Vec<Individual>;