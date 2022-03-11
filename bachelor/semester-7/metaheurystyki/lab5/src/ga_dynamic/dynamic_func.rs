use super::params::*;

pub fn next_value(epoch: f32, params: &GADynamicParams) -> f32 {
  ((params.min - params.max) / params.ga.epochs as f32) * epoch as f32 + params.max
}