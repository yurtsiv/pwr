pub mod csp;
pub mod einstein;
pub mod map_coloring;
pub mod args_parser;

use args_parser::*;

fn run_solver(args: Args) {
    let var_selector = Box::new(
        match args.var_selector {
            VarSelectorType::Next =>
                csp::var_selectors::next_var,
            VarSelectorType::MostConstrained =>
                csp::var_selectors::most_constrained_var
        }
    );

    let val_selector = Box::new(
        match args.val_selector {
            ValSelectorType::Next =>
                csp::val_selectors::next_val,
            ValSelectorType::LeastConstraining =>
                csp::val_selectors::least_constraining_val
        }
    );

    match args.problem {
        Problem::Einstein => {
            einstein::solve::solve(args.solve_type, var_selector, val_selector);
        },
        Problem::MapColoring => {
            map_coloring::solve::solve(
                args.problem_size,
                args.solve_type,
                var_selector,
                val_selector
            )
        }
    }
}

fn main() {
    match parse_args() {
        Some(args) => {
            run_solver(args);
        },
        None => {}
    }
}
