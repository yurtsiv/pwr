use crate::types::*;
use rand::Rng;

pub fn single_point(parent1: &Individual, parent2: &Individual, params: &mut GAParams) -> Vec<Individual> {
  let separation_idx = params.rng.gen_range(1, parent1.len());
  let mut result: Vec<Individual> = Vec::new();

  let mut child1 = parent1[0..separation_idx]
    .to_vec()
    .clone();
  
  child1.append(
    &mut parent2[separation_idx..].to_vec().clone()
  );

  let mut child2 = parent2[0..separation_idx]
    .to_vec()
    .clone();
  
  child2.append(
    &mut parent1[separation_idx..].to_vec().clone()
  );

  result.push(child1);
  result.push(child2);

  result
}