use rand;

// (x, y)
pub type Point = (i32, i32);

pub type ConnectedPair = (Point, Point);

#[derive(Debug)]
pub struct Problem {
  pub width: i32,
  pub height: i32,

  pub connected_points: Vec<ConnectedPair>
}

#[derive(Debug, PartialEq, Clone, Copy)]
pub enum Dir {
  UP,
  DOWN,
  RIGHT,
  LEFT
}

#[derive(Debug, PartialEq, Clone, Copy)]
pub enum SelectionType {
  TOURNAMENT,
  ROULETTE
}

pub type Segment = (Dir, i32);

pub type Path = Vec<Segment>;

pub type Individual = Vec<Path>;

pub type Population = Vec<Individual>;

pub struct GAParams {
  pub epochs: u32,
  pub population_size: i32,
  pub max_segment_move: u32,
  pub mutation_chance: f32,
  pub selection_alg: SelectionType,
  pub tournament_selection_size: u32,
  pub crossover_chance: f32,
  pub random_segments_max: u32,
  pub split_segment_chance: f32,

  pub rng: rand::rngs::ThreadRng,
  // pub rng: rand::rngs::StdRng
}

pub struct FitnessWeights {
  pub intersections: f32,
  pub total_len: f32,
  pub total_segments: f32,
  pub paths_outside_bounds: f32
}