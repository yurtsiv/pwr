use super::heuristics::*;
use super::params::*;
use crate::game::game::*;

// (best move, evaluation)
type MinimaxRes = (Option<usize>, f32);

pub fn alphabeta(game: &Game, depth: usize, alpha: f32, beta: f32) -> MinimaxRes {
  if depth == TREE_DEPTH || game.game_over() {
    let e = evaluate_game_state(&game);
    // print!("\nEVAL {}", e);
    return (None, e);
  }

  if *game.current_player() == AI_PLAYER {
    let mut max_eval = -f32::INFINITY;
    let mut max_eval_move = 0usize;
    let mut max_alpha = alpha;

    for player_move in 1..7 {
      let mut game_clone = game.clone();

      if game_clone.should_skip_next_move() {
        game_clone.skip_turn()
      } else if game_clone.turn(player_move) == None {
        // invalid move
        continue; 
      }

      let (_, eval) = alphabeta(&game_clone, depth + 1, max_alpha, beta);

      if eval > max_eval {
        max_eval = eval;
        max_eval_move = player_move;
      };

      if eval >= beta {
        break;
      }

      if eval > max_alpha {
        max_alpha = eval;
      }
    }

    // print!("\nMAX EVAL {}", max_eval);
    return if depth == 0 {
      (Some(max_eval_move), max_eval)
    } else {
      (None, max_eval)
    };
  }

  let mut min_eval = f32::INFINITY;
  let mut min_beta = beta;

  for player_move in 1..7 {
    let mut game_clone = game.clone();

    if game_clone.should_skip_next_move() {
      game_clone.skip_turn()
    } else if game_clone.turn(player_move) == None {
      // invalid move
      continue; 
    }

    let (_, eval) = alphabeta(&game_clone, depth + 1, alpha, min_beta);

    if eval < min_eval {
      min_eval = eval;
    }

    if eval <= alpha {
      break;
    }

    if eval < min_beta {
      min_beta = eval;
    }
  }

  // print!("\nMIN EVAL {}", min_eval);
  return (None, min_eval);
}
