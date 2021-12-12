use std::collections::HashSet;
use rand;
use rand::Rng;
use crate::types::*;
use std::cmp;

// first <= second
pub fn two_random_nums(min: i32, max: i32, rng: &mut rand::rngs::ThreadRng) -> (usize, usize) {
  let r1 = rng.gen_range(min, max);
  let r2 = rng.gen_range(min, max);

  (cmp::min(r1, r2) as usize, cmp::max(r1, r2) as usize)
}

pub fn vec_diff(v1: &Vec<i32>, v2: &Vec<i32>) -> Vec<i32> {
  let v2_set: HashSet<i32> = v2.iter().copied().collect();
  v1.into_iter().filter(|item| !v2_set.contains(item)).copied().collect()
}

pub fn distance_between(city_1_number: i32, city_2_number: i32, problem: &Problem) -> f32 {
  unsafe {
    *problem
      .distances
      .get_unchecked(city_1_number as usize)
      .get_unchecked(city_2_number as usize)
  }
}
