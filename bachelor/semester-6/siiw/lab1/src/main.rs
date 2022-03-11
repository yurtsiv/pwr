use std::env;

pub mod parse;
pub mod print;
pub mod ga;
pub mod types;
pub mod geometry;

fn main() {
    let args: Vec<String> = env::args().collect();

    match (args.get(1), args.get(2)) {
        (Some(filepath), Some(img_path)) => {
            let problem = parse::parse_file(filepath).unwrap();

            let solution = match args.get(3) {
                Some(_) => ga::random::random_simulation(&problem),
                None => ga::run::run_ga(&problem)
            };

            for i in 0..solution.len() {
                print::gen_svg(
                    &problem,
                    &solution[i],
                    img_path
                );
            }
        },
        _ => println!("Pass a file path and resulting image name")
    }
}