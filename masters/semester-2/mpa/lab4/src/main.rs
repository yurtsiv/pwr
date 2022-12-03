use std::collections::HashSet;
use rand::seq::SliceRandom;
use rand::thread_rng;

fn gen_permutation(n: u32, rng: &mut rand::rngs::ThreadRng) -> Vec<u32> {
  let mut arr: Vec<u32> = (0..n).collect();
  arr.shuffle(rng);
  arr
}

fn fixed_points(permutation: &Vec<u32>) -> u32 {
  let mut points: u32 = 0;

  for i in 0..permutation.len() {
    if permutation[i] == i as u32 {
      points += 1;
    }
  }

  points
}

fn cycles(permutation: &Vec<u32>) -> u32 {
  let mut cycles: u32 = 0;
  let mut visited_idx: HashSet<u32> = HashSet::new();

  for i in 0..permutation.len() {
    if !visited_idx.contains(&(i as u32)) {
      let mut next_elem: u32 = permutation[i] as u32;
      loop {
        visited_idx.insert(next_elem);

        if next_elem == i as u32 {
          cycles += 1;
          break;
        } else {
          next_elem = permutation[next_elem as usize];
        }
      }
    }
  }

  cycles
}

fn records(permutation: &Vec<u32>) -> u32 {
  let mut records: u32 = 1;

  let mut current_max = permutation[0];

  for i in 1..permutation.len() {
    if permutation[i] > current_max {
      current_max = permutation[i];
      records += 1;
    }
  }

  records
}

fn main() {
  let max_n: u32 = 1000;

  let mut rng = thread_rng();

  for n in 2..max_n {
    println!("n={}", n);

    for _ in 1..(n * 20) {
      let permutation = gen_permutation(n, &mut rng);
      println!("{},{},{}", fixed_points(&permutation), cycles(&permutation), records(&permutation));
    }
  }
}
