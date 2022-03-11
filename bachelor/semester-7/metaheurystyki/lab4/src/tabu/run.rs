use crate::types::*;
use crate::random::*;
use super::params::*;
use super::list::*;
use super::neighbours::*;
use crate::fitness::*;
use crate::print::*;

pub fn run_tabu(problem: &Problem, params_str: &String) -> Population {
  let mut params = TabuParams::parse(params_str);
  params.print();

  let mut curr_ind = gen_random_individual(problem, &mut params.rng);
  let mut tabu_list = TabuList::new(params.tabu_size);

  let mut best_fit = calc_fitness(&curr_ind, problem);
  let mut worst_fit = best_fit;

  for i in 0..params.iter {
    let (best_neighbour, neighbour_fit, worst_neighbour_fit, avg_neighbour_fit) = get_best_neighbour(
      &curr_ind,
      &tabu_list,
      problem,
      &mut params
    );

    tabu_list.add(&best_neighbour);
    curr_ind = best_neighbour;

    if neighbour_fit < best_fit {
      best_fit = neighbour_fit;
    } else if neighbour_fit > worst_fit {
      worst_fit = neighbour_fit;
    }

    print!("\n{}", i);
    // Best fit, current fit, worst, worst. neigh fit, avg neigh. fit
    print!("\n{},{},{},{},{}", best_fit, neighbour_fit, worst_fit, worst_neighbour_fit, avg_neighbour_fit);
  }

  print!("\nBest.fit:{}", best_fit);

  vec![]
}