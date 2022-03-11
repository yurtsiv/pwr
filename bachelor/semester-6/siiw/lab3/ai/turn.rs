use super::minimax::*;
use super::alphabeta::*;
use crate::game::game::*;

pub fn next_turn(game: &Game) -> usize {
  // alphabeta(
  //   &game,
  //   0,
  //   -f32::INFINITY,
  //   f32::INFINITY
  // ).0.unwrap()

  minimax(
    &game,
    0
  ).0.unwrap()
}