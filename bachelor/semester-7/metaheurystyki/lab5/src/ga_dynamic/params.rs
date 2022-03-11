use rand;
// use rand::rngs::StdRng;
// use rand::SeedableRng;

use crate::types::*;
use crate::parse::*;
use crate::ga::params::*;

pub struct GADynamicParams {
  pub ga: GAParams,

  pub min: f32,
  pub max: f32
}

impl GADynamicParams {
  pub fn parse(ga_params_str: &String, params_str: &String) -> GADynamicParams {
    let mut lines = params_str.lines();

    GADynamicParams {
      ga: GAParams::parse(ga_params_str),
      min: parse_float_param(lines.next()),
      max: parse_float_param(lines.next())
    }
  }
}