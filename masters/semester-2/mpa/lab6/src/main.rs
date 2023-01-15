use rand::Rng;
use rand::seq::SliceRandom;

const N_MAX: usize = 100_000;
const STEP: usize = 100;
const REPEATS: usize = 10;
const D: usize = 4;

fn task_1(n: usize) -> usize {
    let mut rng = rand::thread_rng();
    let mut bins: Vec<usize> = vec![0; n];
    for _ in 0..n {
        bins[rng.gen_range(0..n)] += 1;
    }

    *bins.iter().max().unwrap()
}

fn task_2(n: usize) -> usize {
    let mut rng = rand::thread_rng();
    let mut bins: Vec<usize> = vec![0 as usize; n];
    let idxs: Vec<usize> = (0..n).collect();

    for _ in 0..n { 
        let chosen_bins: Vec<usize> = idxs.choose_multiple(&mut rng, D).cloned().collect();
        let min_val = chosen_bins.clone().into_iter().map(|i| bins[i]).min().unwrap();
        let pick_from_bins: Vec<usize> = chosen_bins.into_iter().filter(|i| bins[*i] == min_val).collect();
        bins[*pick_from_bins.choose(&mut rng).unwrap()] += 1;
    }

    *bins.iter().max().unwrap()
}

fn task_3(n: usize) -> usize {
    let mut rng = rand::thread_rng();
    let groups_num = n / D;
    let mut bins: Vec<usize> = vec![0 as usize; groups_num * D];

    for _ in 0..n {
        let chosen_bins: Vec<usize> = (0..groups_num).into_iter().map(|group| (group * D) + rng.gen_range(0..D)).collect();
        let min_val = chosen_bins.clone().into_iter().map(|i| bins[i]).min().unwrap();
        let pick_from_bins: Vec<usize> = chosen_bins.into_iter().filter(|i| bins[*i] == min_val).collect();
        bins[pick_from_bins[0]] += 1;
    }

    *bins.iter().max().unwrap()
}

fn main() {
    for n in (10..N_MAX).step_by(STEP) {
        let mut values: Vec<usize> = vec![];
        for _ in 0..REPEATS {
            values.push(task_3(n));
        }
        print!("{}:{:?}\n", n, values);
    }
}
