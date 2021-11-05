use crate::types::*;
use super::params::*;
use crate::helpers::*;
use std::collections::HashMap;

fn ordered(parent1: &mut Individual, parent2: &mut Individual, params: &mut GAParams) -> Vec<Individual> {
  let (start, end) = two_random_nums(0, parent1.len() as i32, &mut params.rng);

  let parent1_genome = &parent1[start..end];
  let parent2_genome = vec_diff(parent2, &parent1_genome.to_vec());

  let mut child: Individual = Vec::new();

  for i in 0..parent1.len() {
    if i < start {
      child.push(
        *parent2_genome.get(i).unwrap()
      );
    } else if i < end {
      child.push(
        *parent1_genome.get(i - start).unwrap()
      );
    } else {
      child.push(
        *parent2_genome.get(i - parent1_genome.len()).unwrap()
      );
    }
  }

  vec![child]
}

fn partially_mapped(parent1: &mut Individual, parent2: &mut Individual, params: &mut GAParams) -> Vec<Individual> {
  let (start, end) = two_random_nums(0, parent1.len() as i32, &mut params.rng);

  let mut child1 = parent1.clone();
  let mut child2 = parent2.clone();

  let mut parent1_mapping = HashMap::new();
  let mut parent2_mapping = HashMap::new();

  for i in start..end {
    parent1_mapping.insert(
      parent1[i],
      parent2[i]
    );

    parent2_mapping.insert(
      parent2[i],
      parent1[i]
    );
  }

  for i in 0..parent1.len() {
    if i >= start && i < end {
      continue;
    }

    child1[i] = match parent1_mapping.get(&parent2[i]) {
      Some(val) => *val,
      None => parent2[i]
    };

    while parent1_mapping.contains_key(&child1[i]) {
      child1[i] = *parent1_mapping.get(&child1[i]).unwrap();
    }

    child2[i] = match parent2_mapping.get(&parent1[i]) {
      Some(val) => *val,
      None => parent1[i]
    };

    while parent2_mapping.contains_key(&child2[i]) {
      child2[i] = *parent2_mapping.get(&child2[i]).unwrap();
    }
  }

  vec![child1, child2]
}

pub fn crossover(parent1: &mut Individual, parent2: &mut Individual, params: &mut GAParams) -> Vec<Individual> {
  let crossover_alg = match params.crossover_type {
    CrossoverType::Ordered => ordered,
    CrossoverType::PartiallyMapped => partially_mapped
  };

  crossover_alg(parent1, parent2, params)
}