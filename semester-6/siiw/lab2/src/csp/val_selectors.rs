use super::types::*;
use super::constraints::*;

pub fn next_val(
  vars: &Vars,
  _values: &mut Values,
  _constraints: &ConstraintsOptimized,
  _neighbouring_vars: &NeighbouringVars,
  var_idx: usize
) -> Option<(usize, i32)> {
  vars[var_idx].domain().next()
}

pub fn least_constraining_val(
  vars: &Vars,
  values: &mut Values,
  constraints: &ConstraintsOptimized,
  neighbouring_vars: &NeighbouringVars,
  var_idx: usize
) -> Option<(usize, i32)> {
  let original_val = values[var_idx];

  if *(&neighbouring_vars[var_idx].len()) == 0usize {
    return next_val(vars, values, constraints, neighbouring_vars, var_idx);
  }

  let mut least_constraining = None;
  let mut min_removals = i32::MAX;

  for (val_idx, val) in vars[var_idx].domain() {
    values[var_idx] = Some(val);

    let mut removals = 0;
    for neighbour_idx in &neighbouring_vars[var_idx] {
      for (_, neigh_val) in vars[*neighbour_idx].domain() {
        if !check_constraints(
          values,
          constraints,
          *neighbour_idx,
          neigh_val
        ) {
          removals += 1;
        }
      }
    }

    if removals < min_removals {
      min_removals = removals;
      least_constraining = Some((val_idx, val));
    }
  }

  values[var_idx] = original_val;

  return least_constraining;
}
