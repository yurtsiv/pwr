use super::types::*;

pub fn get_neighbouring_vars(
  constraints: &ConstraintsOptimized
) -> NeighbouringVars {
  let mut res: NeighbouringVars = Vec::new();
  for _ in 0..constraints.len() {
    res.push(Vec::new());
  }

  for (var_idx, var_constraints) in constraints.iter().enumerate() {
    for constraint in var_constraints.iter() {
      for idx in constraint.vars_indexes.iter() {
        if *idx != var_idx {
          res[var_idx].push(*idx)
        }
      }
    }
  }

  return res
}
