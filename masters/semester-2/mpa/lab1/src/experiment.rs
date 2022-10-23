use rand::seq::SliceRandom;
use rand::thread_rng;

use crate::merge_sort::*;
use crate::quick_sort::*;

#[derive(Debug, PartialEq, Clone, Copy)]
pub enum SortAlg {
  QuickSort,
  MergeSort,
}

pub fn run(sort_alg: SortAlg, n: u32, repeat: u32) {
  let sorter = match sort_alg {
    SortAlg::QuickSort => quick_sort,
    SortAlg::MergeSort => merge_sort,
  };

  let mut sort_target: Vec<u32> = (0..n).collect();
  let mut rng = thread_rng();

  let mut results: Vec<u32> = Vec::new();

  for _ in 1..repeat {
    sort_target.shuffle(&mut rng);
    let mut comparisons = 0u32;
    sorter(&mut sort_target, &mut comparisons);
    results.push(comparisons)
  }

  print!("\n{}|{:?}", n, results)
}
