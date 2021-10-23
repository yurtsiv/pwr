use crate::game::game::*;
use super::params::*;

fn score_diff(game: &Game) -> f32 {
  let res = (game.p1_score() as f32 - game.p2_score() as f32) * (if AI_PLAYER == Player::Player1 {
    1
  } else {
    -1
  }) as f32;

  return res;
}

fn capture_opportunities(game: &Game) -> f32 {
  let mut captures = 0;
  let prev_player = game.current_player().clone();

  for i in 1..7 {
    let mut game_clone = game.clone();

    match game_clone.turn(i) {
      Some(res) => {
        if res.captured {
          if prev_player == AI_PLAYER {
            captures -= 1;
          } else {
            captures += 1;
          }
        }
      },
      _ => {}
    }
  }

  return captures as f32;
}

fn winning_moves(game: &Game) -> f32 {
  let mut moves = 0;

  let prev_player = game.current_player().clone();

  for i in 1..7 {
    let mut game_clone = game.clone();

    match game_clone.turn(i) {
      Some(_) => {
        if game_clone.game_over() {
          if prev_player == AI_PLAYER {
            moves -= 1;
          } else {
            moves += 1;
          }
        }
      }
      _ => {}
    }
  }

  return moves as f32;
}

fn turn_keeping_moves(game: &Game) -> f32 {
  let mut moves = 0;

  let prev_player = game.current_player().clone();

  for i in 1..7 {
    let mut game_clone = game.clone();

    match game_clone.turn(i) {
      Some(_) => {
        if *game_clone.current_player() == prev_player {
          if prev_player == AI_PLAYER {
            moves -= 1;
          } else {
            moves += 1;
          }
        }
      }
      _ => {}
    }
  }

  return moves as f32;
}

pub fn evaluate_game_state(game: &Game) -> f32 {
  score_diff(game) +
  2_f32 * capture_opportunities(game) +
  10_f32 * turn_keeping_moves(game) +
  1000_f32 * winning_moves(game)
}