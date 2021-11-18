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

    match (args.get(1), args.get(2), args.get(3)) {
        (Some(filepath), Some(algorithm), Some(params)) => {
            let problem = parse::parse_file(filepath).unwrap();
            match algorithm.as_str() {
                // "random" => random::random_simulation(&problem, params),
                // "greedy" => greedy::greedy_simulation(&problem, params),
                "ga" => ga::run::run_ga(&problem, params),
                "tabu" => tabu::run::run_tabu(&problem, params),
                "sa" => sa::run::run_sa(&problem, params),
                _ => {
                    panic!("Unknow algorithm.")
                }
            };
        }
        _ => panic!("Invalid params")
    }
}