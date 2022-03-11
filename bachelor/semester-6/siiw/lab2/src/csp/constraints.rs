use super::types::*;
use itertools::Itertools;

pub fn get_optimized_constraints<'a>(
  vars: Vec<CSPVar>,
  constraints: &'a Vec<Constraint>
) -> ConstraintsOptimized<'a> {
  let mut res: ConstraintsOptimized = Vec::new();
  for _ in 0..vars.len() {
    res.push(Vec::new())
  }

  for constraint in constraints.iter() {
    for var_idx in constraint.vars_indexes.iter() {
      res[*var_idx].push(&constraint)
    }
  }

  res
}


pub fn check_constraint(
  constraint: &Constraint,
  values: &Values,
  target_var_idx: usize,
  target_val: i32
) -> bool {
  // can't check all constraints so return true
  if (&constraint.vars_indexes).into_iter().any(
      |var_idx| *var_idx != target_var_idx && values[*var_idx] == None
  ) {
    return true
  }

  let constraint_values = (&constraint
    .vars_indexes)
    .into_iter()
    .map(|var_idx| if *var_idx == target_var_idx {
      target_val
    } else {
      values[*var_idx].unwrap()
    });

  match constraint.kind {
    ConstraintKind::Eq => {
      constraint_values.unique().collect::<Vec<i32>>().len() == 1
    },
    ConstraintKind::NotEq => {
      constraint_values
        .unique()
        .collect::<Vec<i32>>().len() == constraint.vars_indexes.len()
    },
    ConstraintKind::Custom => {
      let check = constraint.custom_fn.as_ref().unwrap();
      check(&constraint_values.collect())
    }
  }
}

pub fn check_constraints(
  values: &Values,
  constraints: &ConstraintsOptimized,
  target_var_idx: usize,
  target_val: i32
) -> bool {
  for constraint in constraints[target_var_idx].iter() {
    if !check_constraint(constraint, values, target_var_idx, target_val) {
      return false
    }
  }

  true
}
