use crate::types::*;
use crate::geometry::*;
use crate::ga::params;
use crate::ga::fitness;

use rand;
use rand::Rng;
use rand::seq::SliceRandom;

fn gen_simplest_path(point1: Point, point2: Point) -> Path {
  let mut path: Path = Vec::new();

  let x_dist = point1.0 - point2.0;
  if x_dist != 0 {
    let dir = if x_dist > 0 { Dir::LEFT } else { Dir::RIGHT };

    path.push(
      (dir, x_dist.abs())
    );
  }

  let y_dist = point1.1 - point2.1;
  if y_dist != 0 {
    let dir = if y_dist > 0 { Dir::UP } else { Dir::DOWN };

    path.push(
      (dir, y_dist.abs())
    )
  }

  path
}

fn some_dir_eq(dir: Option<Dir>, eq_to: Dir) -> bool {
  dir.is_some() && dir == Some(eq_to)
}

fn get_random_dir(origin: Point, prev_dir: Option<Dir>, problem: &Problem, params: &mut GAParams) -> Dir {
  let mut choose_from: Vec<Dir> = vec![
    Dir::UP,
    Dir::DOWN,
    Dir::RIGHT,
    Dir::LEFT
  ];

  choose_from = choose_from
    .iter()
    .filter(|dir| match dir {
      Dir::UP =>
        !(origin.1 == 0 || some_dir_eq(prev_dir, Dir::DOWN)),
      Dir::DOWN =>
        !(origin.1 == (problem.height - 1) || some_dir_eq(prev_dir, Dir::UP)),
      Dir::RIGHT =>
        !(origin.0 == (problem.width - 1) || some_dir_eq(prev_dir, Dir::LEFT)),
      Dir::LEFT =>
        !(origin.0 == 0 || some_dir_eq(prev_dir, Dir::RIGHT)),
    })
    .map(|dir| *dir)
    .collect();

  *choose_from.choose(&mut params.rng).unwrap()
}

fn get_random_segment_len(origin: Point, dir: Dir, problem: &Problem, params: &mut GAParams) -> i32 {
  let max_len = match dir {
    Dir::RIGHT => problem.width - origin.0,
    Dir::LEFT => origin.0,
    Dir::UP => origin.1,
    Dir::DOWN => problem.height - origin.1
  };

  if max_len <= 1 {
    1
  } else {
    params.rng.gen_range(1, max_len)
  }
}

// may happen at the end, when we connect to final point
fn fix_path(path: &mut Path) {
  for i in 0..(path.len() - 1) {
    if path[i].0 == get_opposite_dir(path[i+1].0) {
      let new_len = path[i].1 - path[i+1].1;

      if new_len == 0 {
        path.remove(i);
        path.remove(i);
      } else if new_len < 0 {
        path[i+1].1 = -new_len;
        path.remove(i);
      } else {
        path[i].1 = new_len;
        path.remove(i+1);
      }

      break;
    }
  }
}

fn gen_random_path(connected_pair: &ConnectedPair, problem: &Problem, params: &mut GAParams) -> Path {
  let mut path: Path = Vec::new();
  let num_of_random_segs = params.rng.gen_range(1, params.random_segments_max);

  let mut next_origin = connected_pair.0;
  let mut prev_dir: Option<Dir> = None;

  for _ in 0..num_of_random_segs {
    let dir = get_random_dir(next_origin, prev_dir, problem, params);
    let len = get_random_segment_len(next_origin, dir, problem, params);

    prev_dir = Some(dir);
    path.push(
      (dir, len)
    );
    
    match dir {
      Dir::RIGHT => next_origin.0 += len,
      Dir::LEFT => next_origin.0 -= len,
      Dir::UP => next_origin.1 -= len,
      Dir::DOWN => next_origin.1 += len
    };
  }

  path.append(&mut gen_simplest_path(next_origin, connected_pair.1));

  fix_path(&mut path);

  path
}

pub fn gen_random_individual(problem: &Problem, params: &mut GAParams) -> Individual {
  problem.connected_points
    .iter()
    .map(|points_pair| gen_random_path(points_pair, problem, params))
    .collect()
}

pub fn random_simulation(problem: &Problem) -> Population {
  let mut the_best_fit = f32::MAX;
  let mut the_best_ind: Option<Individual> = None;

  let mut params = params::get_ga_params();

  print!("Epochs:{}", params.epochs);
  print!("\nPopulation:{}", params.population_size);
  print!("\nTournament:{:?}", params.selection_alg);
  print!("\nTournament size:{}", params.tournament_selection_size);
  print!("\nMutation chance:{}", params.mutation_chance);
  print!("\nMax seg move:{}", params.max_segment_move);
  print!("\nCrossover chance:{}", params.crossover_chance);
  print!("\nSplit seg chance:{}", params.split_segment_chance);

  for epoch in 0..params.epochs {
    let mut best_epoch_fit = f32::MAX;
    let mut worst_epoch_fit = 0f32;
    let mut fit_sum = 0f32;

    for _ in 0..params.population_size {
      let mut individual = gen_random_individual(problem, &mut params);

      let fit = fitness::maladaptation(&individual, problem);

      fit_sum += fit;

      if fit < best_epoch_fit {
        best_epoch_fit = fit;
      }

      if fit > worst_epoch_fit {
        worst_epoch_fit = fit;
      }

      if fit < the_best_fit {
        the_best_fit = fit;
        the_best_ind = Some(individual.clone());
      }
    }

    // epoch
    print!("\n{}", epoch);
    // avg fitness,best fitness, worst fitness
    print!("\n{},{},{}", fit_sum / params.population_size as f32, best_epoch_fit, worst_epoch_fit);
  }

  print!("\nBest.fit:{}", the_best_fit);

  vec![the_best_ind.unwrap()]
}