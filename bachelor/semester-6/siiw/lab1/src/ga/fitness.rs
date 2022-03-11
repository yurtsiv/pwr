use crate::types::*;
use crate::geometry;
use super::params;

type SegmentPoints = (Point, Point);

fn get_second_segment_point(seg: &Segment, first_point: Point) -> Point {
  match seg.0 {
    Dir::UP => (first_point.0, first_point.1 - seg.1),
    Dir::DOWN => (first_point.0, first_point.1 + seg.1),
    Dir::RIGHT => (first_point.0 + seg.1, first_point.1),
    Dir::LEFT => (first_point.0 - seg.1, first_point.1)
  }
}

fn path_to_path_points(path: &Path, first_point: Point) -> Vec<SegmentPoints> {
  let mut result: Vec<SegmentPoints> = Vec::new();
  let mut prev_point = first_point;

  for seg in path.iter() {
    let next_point = get_second_segment_point(seg, prev_point);
    result.push((prev_point, next_point));
    prev_point = next_point;
  }

  result
}

fn calc_intersections_paths(path1: &Vec<SegmentPoints>, path2: &Vec<SegmentPoints>) -> i32 {
  let mut res = 0i32;

  for seg in path1.iter() {
    for other_seg in path2.iter() {
      if geometry::segments_intersect(
        seg.0,
        seg.1,
        other_seg.0,
        other_seg.1
      ) {
        res +=1;
      }
    }
  }

  res
}

fn calc_intersections(individual: &Individual, problem: &Problem) -> i32 {
  let paths_points: Vec<Vec<SegmentPoints>> = individual
    .iter()
    .enumerate()
    .map(|(i, path)| path_to_path_points(&path, problem.connected_points[i].0))
    .collect();

  let mut res = 0i32;

  for i in 0..(paths_points.len() - 1) {
    for j in (i + 1)..paths_points.len() {
      res += calc_intersections_paths(&paths_points[i], &paths_points[j]);
    }
  }

  res
}

fn path_len(path: &Path) -> i32 {
  let mut res = 0i32;

  for seg in path.iter() {
    res += seg.1;
  }

  res
}

fn total_len(individual: &Individual) -> i32 {
  individual
    .iter()
    .map(path_len)
    .sum()
}

fn total_segments(individual: &Individual) -> i32 {
  individual
    .iter()
    .map(|path| path.len() as i32)
    .sum()
}

fn outside_bounds_paths(individual: &Individual, problem: &Problem) -> i32 {
  let mut paths_outside_bounds = 0i32;

  for (i, path) in individual.iter().enumerate() {
    let mut xd = problem.connected_points[i].0.0;
    let mut yd = problem.connected_points[i].0.1;

    let mut outside_bounds = false;

    for seg in path.iter() {
      match seg.0 {
        Dir::UP => {
          yd -= seg.1;
        },
        Dir::DOWN => {
          yd += seg.1;
        },
        Dir::LEFT => {
          xd -= seg.1;
        },
        Dir::RIGHT => {
          xd += seg.1;
        }
      }

      if yd < 0 || yd > problem.height || xd < 0 || xd > problem.width {
        outside_bounds = true;
      }
    }

    if outside_bounds {
      paths_outside_bounds += 1;
    }
  }

  paths_outside_bounds
}


// like fitness but smaller values are better
pub fn maladaptation(individual: &Individual, problem: &Problem) -> f32 {
  let weights = params::get_fitness_weights();

  weights.intersections * (calc_intersections(individual, problem) as f32) +
  weights.total_len * (total_len(individual) as f32) +
  weights.total_segments * (total_segments(individual) as f32) +
  weights.paths_outside_bounds * (outside_bounds_paths(individual, problem) as f32)
}