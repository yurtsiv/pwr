use super::types::*;
use super::constraints::*;

pub fn forward_check(
  vars: &mut Vec<CSPVar>,
  values: &Values,
  constraints: &ConstraintsOptimized,
  neighbouring_vars: &NeighbouringVars,
  var_idx: usize
) -> bool {
  for neighbour_idx in neighbouring_vars[var_idx].iter() {
    let assigned = values[*neighbour_idx] != None;
    if assigned {
      continue;
    }

    let neighbour = &mut vars[*neighbour_idx];

    let mut val_idx_to_exclude: Vec<usize> = Vec::new();
    for (val_idx, val) in neighbour.domain() {
      if !check_constraints(values, constraints, *neighbour_idx, val) {
        val_idx_to_exclude.push(val_idx)
      }
    }

    if val_idx_to_exclude.len() == neighbour.domain().collect::<Vec<(usize, i32)>>().len() {
      return true;
    }

    for val_idx in val_idx_to_exclude.iter() {
      neighbour.exclude_val(*val_idx);
    }
  }

  return false;
}
