use rand;
// use rand::rngs::StdRng;
// use rand::SeedableRng;

use crate::ga::params::*;
use crate::sa::params::*;
use crate::parse::*;

pub struct GASAParams {
  pub ga: GAParams,
  pub sa: SAParams,
  pub run_sa_each_iter: u32,
  pub run_sa_for_ind: u32,
}

impl GASAParams {
  pub fn parse(ga_params_str: &String, sa_params_str: &String, ga_sa_params_str: &String) -> GASAParams {
    let mut lines = ga_sa_params_str.lines();

    GASAParams {
      ga: GAParams::parse(ga_params_str),
      sa: SAParams::parse(sa_params_str),
      run_sa_each_iter: parse_uint_param(lines.next()),
      run_sa_for_ind: parse_uint_param(lines.next())
    }
  }

  pub fn print(&self) {
    self.ga.print();
  }
}