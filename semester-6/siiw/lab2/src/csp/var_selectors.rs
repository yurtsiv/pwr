use super::types::*;

pub fn most_constrained_var(
  vars: &Vec<CSPVar>,
  vals: &Vec<Option<i32>>,
  _curr_var_idx: Option<usize>
) -> Option<usize> {
  vars
    .iter()
    .enumerate()
    .filter(|(idx, _)| vals[*idx] == None)
    .min_by_key(|(_, var)| var.domain().collect::<Vec<(usize, i32)>>().len())
    .map(|(idx, _)| idx)
}

pub fn next_var(
  vars: &Vec<CSPVar>,
  _vals: &Vec<Option<i32>>,
  curr_var_idx: Option<usize>
) -> Option<usize> {
  if curr_var_idx == None {
    Some(0)
  } else if curr_var_idx.unwrap() == vars.len() - 1 {
    None
  } else {
    Some(curr_var_idx.unwrap() + 1)
  }
}