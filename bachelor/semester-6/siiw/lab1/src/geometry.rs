use crate::types::*;
use std::cmp;

#[derive(Debug, PartialEq, Clone, Copy)]
enum Orientation {
  Clockwise,
  CounterClockwise,
  Colinear
}

fn on_segment(p: Point, q: Point, r: Point) -> bool {
  q.0 <= cmp::max(p.0, r.0) && q.0 >= cmp::min(p.0, r.0) &&
  q.0 <= cmp::max(p.1, r.1) && q.1 >= cmp::min(p.1, r.1)
}

fn orientation(p: Point, q: Point, r: Point) -> Orientation {
  let val = ((q.1 - p.1) * (r.0 - q.0)) - ((q.0 - p.0) * (r.1 - q.1));

  if val > 0 {
    Orientation::Clockwise
  } else if val < 0 {
    Orientation::CounterClockwise
  } else {
    Orientation::Colinear
  }
}

pub fn get_opposite_dir(dir: Dir) -> Dir {
  match dir {
    Dir::UP => Dir::DOWN,
    Dir::DOWN => Dir::UP,
    Dir::RIGHT => Dir::LEFT,
    Dir::LEFT => Dir::RIGHT
  }
}

pub fn segments_intersect(p1: Point, q1: Point, p2: Point, q2: Point) -> bool {
  let o1 = orientation(p1, q1, p2);
  let o2 = orientation(p1, q1, q2);
  let o3 = orientation(p2, q2, p1);
  let o4 = orientation(p2, q2, q1);

  if o1 != o2 && o3 != o4 {
    return true
  }

  if o1 == Orientation::Colinear && on_segment(p1, p2, q1) {
    return true
  }

  if o2 == Orientation::Colinear && on_segment(p1, q2, q1) {
    return true
  }

  if o3 == Orientation::Colinear && on_segment(p2, p1, q2) {
    return true
  }

  if o4 == Orientation::Colinear && on_segment(p2, q1, q2) {
    return true
  }

  false
}