use std::env;
use crate::csp::types::SolveType;

pub enum ValSelectorType {
  Next,
  LeastConstraining
}

pub enum VarSelectorType {
  Next,
  MostConstrained
}

pub enum Problem {
  Einstein,
  MapColoring
}

pub struct Args {
  pub problem: Problem,
  pub solve_type: SolveType,
  pub problem_size: usize,
  pub val_selector: ValSelectorType,
  pub var_selector: VarSelectorType,
}

fn parse_problem(arg: &String) -> Option<Problem> {
  match arg.as_str() {
    "Einstein" => Some(Problem::Einstein),
    "MapColoring" => Some(Problem::MapColoring),
    _ => None
  }
}

fn parse_solve_type(arg: &String) -> Option<SolveType> {
  match arg.as_str() {
    "Backtracking" => Some(SolveType::Backtracking),
    "ForwardChecking" => Some(SolveType::ForwardChecking),
    "AC3Dynamic" => Some(SolveType::AC3Dynamic),
    "AC3Static" => Some(SolveType::AC3Static),
    _ => None
  }
}

fn parse_problem_size(arg: &String) -> Option<usize> {
  match arg.parse::<usize>() {
    Ok(size) => Some(size),
    Err(_) => None
  }
}

fn parse_val_selector(arg: &String) -> Option<ValSelectorType> {
  match arg.as_str() {
    "Next" => Some(ValSelectorType::Next),
    "LeastConstraining" => Some(ValSelectorType::LeastConstraining),
    _ => None
  }
}

fn parse_var_selector(arg: &String) -> Option<VarSelectorType> {
  match arg.as_str() {
    "Next" => Some(VarSelectorType::Next),
    "MostConstrained" => Some(VarSelectorType::MostConstrained),
    _ => None
  }
}

pub fn parse_args() -> Option<Args> {
  let args: Vec<String> = env::args().collect();

  for i in 1..6 {
    if args.get(i) == None {
      print!("Not enough arguments");
      return None;
    }
  }

  match (
    parse_problem(args.get(1).unwrap()),
    parse_solve_type(args.get(2).unwrap()),
    parse_problem_size(args.get(3).unwrap()),
    parse_val_selector(args.get(4).unwrap()),
    parse_var_selector(args.get(5).unwrap())
  ) {
    (
      Some(problem),
      Some(solve_type),
      Some(problem_size),
      Some(val_selector),
      Some(var_selector)
    ) => {
      Some(
        Args {
          problem,
          solve_type,
          problem_size,
          val_selector,
          var_selector
        }
      )
    },
    _ => {
      print!("Incorrect args");
      None
    }
  }
}