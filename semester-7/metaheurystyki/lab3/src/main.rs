use std::env;

pub mod parse;
pub mod print;
pub mod ga;
pub mod types;
pub mod geometry;
pub mod helpers;
pub mod init;
pub mod mutation;
pub mod fitness;
pub mod random;
pub mod greedy;
pub mod tabu;
pub mod sa;

fn main() {
    let args: Vec<String> = env::args().collect();

    match args.get(1) {
        Some(filepath) => {
            let problem = parse::parse_file(filepath).unwrap();

            // let solution =
            match args.get(2) {
                Some(second_param) => {
                    match second_param.as_str() {
                        "random" => random::random_simulation(&problem),
                        "greedy" => greedy::greedy_simulation(&problem),
                        "genetic" => ga::run::run_ga(&problem),
                        "tabu" => tabu::run::run_tabu(&problem),
                        "simulated_annealing" => sa::run::run_sa(&problem),
                        _ => panic!("Unknow second param. Allowed: random, greedy or genetic") 
                    }
                },
                None => panic!("Pass a second param")
            };
        },
        None => panic!("Pass a file path")
    }
}