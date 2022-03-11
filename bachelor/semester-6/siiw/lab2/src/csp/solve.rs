use std::time::Instant;
use super::types::*;
use super::constraints::*;
use super::ac3::*;
use super::forward_checking::*;
use super::helpers::*;

pub fn solve(
  original_vars: &Vars, 
  constraints: Vec<Constraint>,
  solve_type: SolveType,
  select_var: VarSelector, 
  select_val: ValSelector 
) -> Vec<Solution> {
  // metrics
  let mut states_checked = 0;
  let mut states_until_first_solution = 0;
  let mut time_until_first = 0;
  let start_time = Instant::now();

  let mut vars = original_vars.clone();
  let optimized_constraints = get_optimized_constraints(vars.clone(), &constraints);
  let neighbouring_vars = get_neighbouring_vars(&optimized_constraints);
  let mut all_solutions: Vec<Solution> = Vec::new();
  let mut values: Values = (0..vars.len()).map(|_| None).collect();
  let mut var_idx_stack: Vec<usize> = vec![
    select_var(&vars, &values, None).unwrap()
  ];

  if solve_type == SolveType::AC3Static || solve_type == SolveType::AC3Dynamic {
    ac3_static(&mut vars, &mut values, &optimized_constraints, &constraints, &neighbouring_vars);

    // recreate vars to restrict domains
    vars = vars
      .iter()
      .map(|v| CSPVar::new(
        v.index,
        v.domain().map(|(_, x)| x).collect::<Vec<i32>>(),
        v.label.clone()
      ))
      .collect();
  }

  let mut got_solution = false;

  'variables_loop: while var_idx_stack.len() != 0 {
    // print!("\nStack: {:?}", var_idx_stack);

    if got_solution {
      if all_solutions.len() == 0 {
        states_until_first_solution = states_checked;
        time_until_first = start_time.elapsed().as_millis();
      }

      let solution = values.iter().map(|v| v.unwrap()).collect();
      // print!("\n\n----------");
      print!("\nSolution: {:?}", solution);
      // print!("\n------------\n");
      all_solutions.push(solution);

      let last_idx = var_idx_stack[var_idx_stack.len() - 1];
      values[last_idx] = None;
      got_solution = false;

      continue 'variables_loop;
    }

    got_solution = false;
    let var_idx = *var_idx_stack.last().unwrap();
    // print!("\n\nSelected var: {}", var_idx);

    loop {
  
      let next_val = select_val(
        &vars,
        &mut values,
        &optimized_constraints,
        &neighbouring_vars,
        var_idx
      );

  
      if next_val == None {
        // print!("\nNo value selected");
        break;
      }

      states_checked += 1;

      // print!("\nIteration: {}", states_checked);
      print!("\nValues: {:?}", values);
      // print!("\nVar idx: {}", var_idx);
      // print!("\nNext val: {}", next_val.unwrap().1);
      // print!("\nDomains:");
      // for var in vars.iter() {
      //   print!("\n{} {:?}", var.label, var.domain().collect::<Domain>().len());
      // }


      let (val_idx, val) = next_val.unwrap();


      vars[var_idx].exclude_val(val_idx);

      if check_constraints(&values, &optimized_constraints, var_idx, val) {
        for var in vars.iter_mut() {
          var.save_domain_mask();
        }

        match solve_type {
          SolveType::ForwardChecking | SolveType::AC3Dynamic => {
            values[var_idx] = Some(val);

            let no_solution = if solve_type == SolveType::ForwardChecking {
              forward_check(&mut vars, &values, &optimized_constraints, &neighbouring_vars, var_idx)
            } else {
              ac3_dynamic(&mut vars, &mut values, &optimized_constraints, &constraints, &neighbouring_vars)
            };

            if no_solution {
              for var in vars.iter_mut() {
                if values[var.index] == None {
                  var.reset_domain();
                }
              }
            } else {
              match select_var(&vars, &values, Some(var_idx)) {
                Some(i) => var_idx_stack.push(i),
                None => {
                  got_solution = true;
                }
              }

              continue 'variables_loop;
            }
          },
          SolveType::Backtracking | SolveType::AC3Static => {
            values[var_idx] = Some(val);
            match select_var(&vars, &values, Some(var_idx)) {
              Some(i) => var_idx_stack.push(i),
              None => {
                got_solution = true;
              }
            }

            continue 'variables_loop;
          }
        }
      }
    }

    var_idx_stack.pop().unwrap();
    values[var_idx] = None;

    for var in vars.iter_mut() {
      if values[var.index] == None {
        var.reset_domain();
      }
    }
  }

  print!("\nMETRIC_total_time {}", start_time.elapsed().as_millis());
  print!("\nMETRIC_total_until_first {}", time_until_first);
  print!("\nMETRIC_states_checked {}", states_checked);
  print!("\nMETRIC_states_until_first {}", states_until_first_solution);

  return all_solutions
}