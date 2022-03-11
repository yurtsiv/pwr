use rand;
use rand::Rng;
use rand::seq::SliceRandom;
use crate::geometry::*;

use crate::types::*;


fn get_move_dir(segment_dir: Dir, params: &mut GAParams) -> Dir {
  let possible_move_dirs: Vec<Dir> = match segment_dir {
    Dir::UP | Dir::DOWN => vec![Dir::RIGHT, Dir::LEFT],
    Dir::RIGHT | Dir::LEFT => vec![Dir::UP, Dir::DOWN]
  };

  *possible_move_dirs.choose(&mut params.rng).unwrap()
}

fn fix_path(path: &mut Path) {
  let mut i = 0;
  loop {
    if i >= (path.len() - 1) {
      break;
    }

    if path[i].0 == get_opposite_dir(path[i+1].0) {
      let new_len = path[i].1 - path[i+1].1;

      if new_len == 0 {
        path.remove(i);
        path.remove(i);
      } else if new_len < 0 {
        path[i+1].1 = -new_len;
        path.remove(i);
      } else {
        path[i].1 = new_len;
        path.remove(i+1);
      }
    } else {
      i += 1;
    }
  }
}

fn move_segment(path: &mut Path, segment_idx: usize, params: &mut GAParams) {
  let move_by = (if params.max_segment_move == 1 {
    1
  } else {
    params.rng.gen_range(1, params.max_segment_move)
  }) as i32;

  let mut seg_idx = segment_idx;

  let segment = path[seg_idx as usize];
  let move_dir = get_move_dir(segment.0, params);
  let move_dir_opposite = get_opposite_dir(move_dir);

  if seg_idx > 0 && (path[seg_idx - 1].0 == move_dir || path[seg_idx - 1].0 == move_dir_opposite) {
    let prev_seg = path[seg_idx - 1];
    let add_to_prev = move_by * (if prev_seg.0 == move_dir { 1 } else { -1 });

    let new_len = prev_seg.1 + add_to_prev;

    if new_len == 0 {
      path.remove(seg_idx - 1);
      seg_idx -= 1;
    } else if new_len < 0 {
      path[seg_idx - 1] = (move_dir, -new_len)
    } else {
      path[seg_idx - 1].1 += add_to_prev;
    }
  } else {
    path.insert(
      segment_idx,
      (move_dir, move_by)
    );

    seg_idx += 1;
  };

  if seg_idx < path.len() - 1 && (path[seg_idx + 1].0 == move_dir || path[seg_idx + 1].0 == move_dir_opposite) {
    let next_seg = path[seg_idx + 1];
    let add_to_next = move_by * (if next_seg.0 == move_dir { -1 } else { 1 });

    let new_len = next_seg.1 + add_to_next;
    if new_len == 0 {
      path.remove(seg_idx + 1);
    } else if new_len < 0 {
      path[seg_idx + 1] = (move_dir_opposite, -new_len);
    } else {
      path[seg_idx + 1].1 += add_to_next;
    }
  } else {
    path.insert(
      seg_idx + 1,
      (move_dir_opposite, move_by)
    );
  };
}

pub fn mutate_random(path: &mut Path, params: &mut GAParams) {
  if params.rng.gen::<f32>() > params.mutation_chance {
    return
  }

  let mut segment_idx = params.rng.gen_range(0, path.len()) as usize;
  let segment = path.get(segment_idx).unwrap();
  let segment_len = segment.1;

  let should_split_segment = segment_len > 1 && params.rng.gen::<f32>() <= params.split_segment_chance;
  if should_split_segment {
    let split_at = if segment_len == 2 {
      1
    } else {
      params.rng.gen_range(1, segment_len - 1)
    };

    let first_chunk = (segment.0, split_at);
    let second_chunk = (segment.0, segment_len - split_at);

    path[segment_idx] = first_chunk;
    path.insert(segment_idx + 1, second_chunk);

    segment_idx = params.rng.gen_range(segment_idx, segment_idx + 1);
  }

  move_segment(path, segment_idx, params);
  fix_path(path);
} 
