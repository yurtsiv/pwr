pub mod experiment;
pub mod merge_sort;
pub mod quick_sort;

fn main() {
    let n_min = 10u32;
    let n_max = 10_000u32;
    let n_step = 10u32;
    let n_repeat = 100u32;

    for n in n_min..n_max {
        if n % n_step == 0 {
            experiment::run(experiment::SortAlg::QuickSort, n, n_repeat);
        }
    }
}
