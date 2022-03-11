use std::env;

pub mod parse;
pub mod print;
pub mod ga;
pub mod types;
pub mod geometry;
pub mod helpers;

fn main() {
    let args: Vec<String> = env::args().collect();

    match args.get(1) {
        Some(filepath) => {
            let problem = parse::parse_file(filepath).unwrap();

            // let solution =
            match args.get(2) {
                Some(second_param) => {
                    match second_param.as_str() {
                        "random" => ga::random::random_simulation(&problem),
                        "greedy" => ga::greedy::greedy_simulation(&problem),
                        "genetic" => ga::run::run_ga(&problem),
                        _ => panic!("Unknow second param. Allowed: random, greedy or genetic") 
                    }
                },
                None => panic!("Pass a second param")
            };
        },
        None => panic!("Pass a file path and resulting image name")
    }
}