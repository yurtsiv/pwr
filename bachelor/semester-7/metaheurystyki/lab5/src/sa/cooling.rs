// linear
// -(T0/iter_num + 0.1) * currIter + T0

// exponential
// T0 * 0.8 ^ ((35 / iter_num) * currIter)

// inverse exponential
// -1 / (T0 * 0.8 ^ (26.85 / iter_num) * currIter)
use super::params::*;

pub fn next_temperature(curr_iter: f32, params: &SAParams) -> f32 {
  let t0 = params.start_temp;
  let iter_num = params.iter as f32;

  match params.cooling_type {
    CoolingType::Linear =>
      // avoid dividing by zero
      (-t0 / (iter_num + 0.1)) * curr_iter + t0,
    CoolingType::Exponential =>
      t0 * 0.8_f32.powf((35.0 / iter_num) * curr_iter),
    CoolingType::InverseExponential =>
      -1.0 / (t0 * 0.8_f32.powf((26.85 / iter_num) * curr_iter)) + t0,
  }
}