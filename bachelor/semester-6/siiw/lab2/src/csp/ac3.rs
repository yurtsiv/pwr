use super::types::*;
use super::constraints::*;

fn ac3_check_unary_constraints(
  vars: &mut Vec<CSPVar>,
  values: &Values,
  constraints: &ConstraintsOptimized
) { 
  // Vec<(var idx, val idx)>
  let mut exclude_vals: Vec<(usize, usize)> = Vec::new();

  for var in vars.iter() {
    for constraint in constraints[var.index].iter() {
      if constraint.vars_indexes.len() != 1 {
        continue;
      }

      for (val_idx, val) in var.domain() {
        if !check_constraint(constraint, values, var.index, val) {
          exclude_vals.push((var.index, val_idx));
        }
      }
    }
  }

  for (var_index, val_index) in exclude_vals.iter() {
    vars[*var_index].exclude_val(*val_index);
  }
}

fn arc_reduce(
  vars: &mut Vec<CSPVar>,
  values: &mut Values,
  optimized_constraints: &ConstraintsOptimized,
  x_idx: usize,
  y_idx: usize
) -> bool {
  let mut changed = false;
  let original_var1_val = values[x_idx];
  let mut x_val_idx_to_exclude: Vec<usize> = Vec::new();

  for (x_val_idx, x_val) in vars[x_idx].domain() {
    // simulate value assignment
    values[x_idx] = Some(x_val);

    let mut y_vals_to_check: Vec<i32> = if values[y_idx] == None {
      vars[y_idx]
        .domain()
        .map(|(_, y_val)| y_val)
        .collect()
    } else {
      vec![values[y_idx].unwrap()]
    };
    
    if values[y_idx] != None {
      y_vals_to_check.push(values[y_idx].unwrap());
    }

    let constraints_to_check: Vec<&Constraint> = optimized_constraints[x_idx]
      .iter()
      .filter(|c|
          c.vars_indexes.len() == 2 &&
          (c.vars_indexes[0] == y_idx ||
            c.vars_indexes[1] == y_idx)
      )
      .map(|c| *c)
      .collect();

    let valid_y_val = y_vals_to_check
      .into_iter()
      .find(|y_val|
        constraints_to_check.iter().all(|c|
          check_constraint(c, values, y_idx, *y_val)
        )
      );
 
    if valid_y_val == None {
      x_val_idx_to_exclude.push(x_val_idx);
      changed = true;
    }
  }

  values[x_idx] = original_var1_val;

  for x_val_idx in x_val_idx_to_exclude.iter() {
    vars[x_idx].exclude_val(*x_val_idx);
  }

  return changed;
}

pub fn ac3_dynamic(
  vars: &mut Vec<CSPVar>,
  values: &mut Values,
  optimized_constraints: &ConstraintsOptimized,
  constraints: &Vec<Constraint>,
  neighbouring_vars: &NeighbouringVars,
) -> bool {
  let mut worklist: Vec<(usize, usize)> = Vec::new();

  for constraint in constraints.iter() {
    if constraint.vars_indexes.len() == 2 {
      let idx_1 = constraint.vars_indexes[0];
      let idx_2 = constraint.vars_indexes[1];

      if values[idx_1] == None {
        worklist.push(
          (idx_1, idx_2)
        );
      }

      if values[idx_2] == None {
        worklist.push(
          (idx_2, idx_1)
        );
      }
    }
  }

  while worklist.len() != 0 {
    let (x_idx, y_idx) = worklist.pop().unwrap();

    if arc_reduce(vars, values, optimized_constraints, x_idx, y_idx) {
      if values[x_idx] == None &&
         vars[x_idx].domain().collect::<Vec<(usize, i32)>>().len() == 0 {
        return true;
      }

      for z_idx in neighbouring_vars[x_idx].iter() {
        if values[*z_idx] == None && *z_idx != y_idx {
          worklist.push((*z_idx, x_idx));
        }
      }
    }
  }

  return false;
}

pub fn ac3_static(
  vars: &mut Vec<CSPVar>,
  values: &mut Values,
  optimized_constraints: &ConstraintsOptimized,
  constraints: &Vec<Constraint>,
  neighbouring_vars: &NeighbouringVars,
) { 
  ac3_check_unary_constraints(vars, values, optimized_constraints);
  ac3_dynamic(vars, values, &optimized_constraints, &constraints, &neighbouring_vars);
}