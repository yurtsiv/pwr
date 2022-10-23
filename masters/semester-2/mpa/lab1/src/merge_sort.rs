pub fn merge_sort(x: &mut [u32], comp: &mut u32) {
	let n = x.len();
	let m = n / 2;
 
	if n <= 1 {
		return;
	}
 
	merge_sort(&mut x[0..m], comp);
	merge_sort(&mut x[m..n], comp);
 
	let mut y: Vec<u32> = x.to_vec();
 
	merge(&x[0..m], &x[m..n], &mut y[..], comp);
 
	x.copy_from_slice(&y);
}

fn merge(x1: &[u32], x2: &[u32], y: &mut [u32], comp: &mut u32) {
    assert_eq!(x1.len() + x2.len(), y.len());

    let mut i = 0;
    let mut j = 0;
    let mut k = 0;

    while i < x1.len() && j < x2.len() {
        *comp += 1;
        if x1[i] < x2[j] {
            y[k] = x1[i];
            k += 1;
            i += 1;
        } else {
            y[k] = x2[j];
            k += 1;
            j += 1;
        }
    }

    if i < x1.len() {
        y[k..].copy_from_slice(&x1[i..]);
    }

    if j < x2.len() {
        y[k..].copy_from_slice(&x2[j..]);
    }
}