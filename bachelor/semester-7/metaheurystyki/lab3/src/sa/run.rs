use rand;
use rand::Rng;
use crate::types::*;
use crate::random::*;
use crate::fitness::*;
use crate::print::*;
use super::neighbours::*;
use super::params::*;
use super::cooling::*;

pub fn run_sa(problem: &Problem) -> Population {
  let mut params = SAParams::new();
  params.print();

  let mut curr_ind = gen_random_individual(problem, &mut params.rng);
  let mut curr_fit = calc_fitness(&curr_ind, problem);
  let mut best_ind = None;

  let mut best_fit = curr_fit;
  let mut worst_fit = curr_fit;

  let mut temperature = params.start_temp;

  for i in 0..params.iter {
    let (best_neighbour, neighbour_fit) = get_best_neighbour(
      &curr_ind,
      problem,
      &mut params
    );

    if neighbour_fit <= curr_fit {
      curr_ind = best_neighbour;
      curr_fit = neighbour_fit;

      if neighbour_fit < best_fit {
        best_ind = Some(curr_ind.clone());
        best_fit = neighbour_fit;
      }
    } else if params.rng.gen::<f32>() < ((curr_fit - neighbour_fit) / temperature).exp() { 
      curr_ind = best_neighbour;
      curr_fit = neighbour_fit;
    }

    if neighbour_fit > worst_fit {
      worst_fit = neighbour_fit;
    }

    temperature = next_temperature(i as f32, &params);

    print!("\n{}", i);
    // Best fit, current fit, worst,
    print!("\n{},{},{}", best_fit, curr_fit, worst_fit);
  }

  print!("\nBest.fit:{}", best_fit);
  print_individual(&best_ind.unwrap(), problem);

  vec![]
}