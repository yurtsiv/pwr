const SEEDS_IN_HOLE: usize = 4;
const BOARD_LEN: usize = 14;
const PLAYER_1_WELL_IDX: usize = 6;
const PLAYER_2_WELL_IDX: usize = 13;

#[derive(PartialEq, Clone, Copy, Debug)]
pub enum Player {
  Player1,
  Player2
}

pub struct Board<'a> {
  pub p1_board: &'a [usize],
  pub p2_board: &'a [usize],
  pub p1_well: usize,
  pub p2_well: usize
}

type BoardInternal = [usize; 14];

#[derive(PartialEq)]
pub struct TurnResult {
  pub captured: bool,
  pub next_player: Player
}

#[derive(Debug)]
pub struct Game {
  winner: Option<Player>,
  current_player: Player,
  game_over: bool,
  board: BoardInternal,
  should_skip_next_move: bool
}

impl Game {
  pub fn new() -> Game {
    Game {
      current_player: Player::Player2,
      game_over: false,
      winner: None,
      should_skip_next_move: false,
      board: [
        SEEDS_IN_HOLE,
        SEEDS_IN_HOLE,
        SEEDS_IN_HOLE,
        SEEDS_IN_HOLE,
        SEEDS_IN_HOLE,
        SEEDS_IN_HOLE,
        0,
        SEEDS_IN_HOLE,
        SEEDS_IN_HOLE,
        SEEDS_IN_HOLE,
        SEEDS_IN_HOLE,
        SEEDS_IN_HOLE,
        SEEDS_IN_HOLE,
        0
      ]
    }
  }

  pub fn skip_turn(&mut self) {
      self.should_skip_next_move = false;
      self.switch_players();
  }

  pub fn turn(&mut self, relative_hole: usize) -> Option<TurnResult> {
    if self.game_over {
      return None
    }

    if self.should_skip_next_move {
      return None
    }

    if relative_hole < 1 || relative_hole > 6 {
      return None
    }

    let hole = if self.current_player == Player::Player1 {
      relative_hole - 1
    } else {
      relative_hole + 6
    };

    if self.board[hole] == 0 {
      return None
    }

    let last_hole = self.distribute_seeds(hole);

    let captured = self.capture(last_hole);
    let finished_on_well =
      last_hole == PLAYER_1_WELL_IDX ||
      last_hole == PLAYER_2_WELL_IDX;

    self.should_skip_next_move = !captured && finished_on_well;
    self.switch_players();
    self.check_game_over();

    Some(TurnResult {
      captured,
      next_player: self.current_player
    })
  }

  pub fn game_over(&self) -> bool {
    self.game_over
  }

  pub fn current_player(&self) -> &Player {
    &self.current_player
  }

  pub fn winner(&self) -> &Option<Player> {
    &self.winner
  }

  pub fn should_skip_next_move(&self) -> bool {
    self.should_skip_next_move
  }

  pub fn board(&self) -> Board {
    Board {
      p1_board: &self.board[..6],
      p2_board: &self.board[7..13],
      p1_well: self.board[PLAYER_1_WELL_IDX],
      p2_well: self.board[PLAYER_2_WELL_IDX]
    }
  }

  pub fn p1_score(&self) -> usize {
    self.board[PLAYER_1_WELL_IDX]
  }

  pub fn p2_score(&self) -> usize {
    self.board[PLAYER_2_WELL_IDX]
  }

  pub fn clone(&self) -> Game {
    Game {
      current_player: self.current_player,
      game_over: self.game_over,
      winner: self.winner,
      should_skip_next_move: self.should_skip_next_move,
      board: self.board.clone()
    }
  }

  fn switch_players(&mut self) {
    self.current_player = if self.current_player == Player::Player1 {
      Player::Player2
    } else {
      Player::Player1
    }
  }

  fn opposite_hole_idx(hole: usize) -> usize {
    (BOARD_LEN - 2) - hole
  }

  fn capture(&mut self, last_hole: usize) -> bool {
    if last_hole == PLAYER_1_WELL_IDX || last_hole == PLAYER_2_WELL_IDX {
      return false;
    }

    // hole was not empty
    if self.board[last_hole] - 1 != 0 {
      return false
    }

    let opposite_hole = Game::opposite_hole_idx(last_hole);

    // opposite hole is empty
    if self.board[Game::opposite_hole_idx(last_hole)] == 0 {
      return false
    }

    match (self.current_player, last_hole) {
      (Player::Player1, h) if h < 5 => {
        self.board[PLAYER_1_WELL_IDX] += self.board[opposite_hole] + self.board[last_hole];
        self.board[last_hole] = 0;
        self.board[opposite_hole] = 0;
        return true;
      }
      (Player::Player2, h) if h > 7 => {
        self.board[PLAYER_2_WELL_IDX] += self.board[opposite_hole];
        self.board[last_hole] = 0;
        self.board[opposite_hole] = 0;
        return true;
      }
      _ => {}
    }
  
    false
  }

  fn distribute_seeds(&mut self, hole: usize) -> usize {
    let mut seeds = self.board[hole];

    self.board[hole] = 0;

    let mut next_idx = hole + 1;
    while seeds != 0 {
      match (self.current_player, next_idx) {
        (Player::Player1, PLAYER_2_WELL_IDX) | (Player::Player2, PLAYER_1_WELL_IDX) => {},
        _ => {
          self.board[next_idx] += 1;
          seeds -= 1;
        }
      }

      if seeds != 0 {
        next_idx = (next_idx + 1) % BOARD_LEN
      }
    }

    next_idx
  }

  fn check_game_over(&mut self) {
    self.game_over =
      self.board[..6].iter().all(|&s| s == 0) ||
      self.board[7..13].iter().all(|&s| s == 0);
    
    if self.game_over {
      let player1_sum: usize = self.board[PLAYER_1_WELL_IDX] + self.board[..6].iter().sum::<usize>();
      let player2_sum: usize = self.board[PLAYER_2_WELL_IDX] + self.board[7..13].iter().sum::<usize>();

      self.winner = Some(
        if player1_sum > player2_sum { Player::Player1 } else { Player::Player2 }
      );
    }
  }
}