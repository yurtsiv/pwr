pub fn quick_sort(arr: &mut [u32], comp: &mut u32) {
    let len = arr.len();
    _quick_sort(arr, 0, (len - 1) as isize, comp);
}

fn _quick_sort(arr: &mut [u32], low: isize, high: isize, comp: &mut u32) {
    if low >= 0 && high >= 0 && low < high {
        let p = partition(arr, low, high, comp);
        _quick_sort(arr, low, p, comp);
        _quick_sort(arr, p + 1, high, comp);
    }
}

fn partition(arr: &mut [u32], low: isize, high: isize, comp: &mut u32) -> isize {
    let pivot_idx = ((high as f32 + low as f32) / 2f32).floor() as usize;

    let mut i = low - 1;
    let mut j = high + 1;

    loop {
        loop {
            i += 1;
            *comp += 1;
            if arr[i as usize] >= arr[pivot_idx] {
                break
            }
        }

        loop {
            j -= 1;
            *comp += 1;
            if arr[j as usize] <= arr[pivot_idx] {
                break
            }
        }

        if i >= j {
            return j
        }

        arr.swap(i as usize, j as usize);
    }
}
