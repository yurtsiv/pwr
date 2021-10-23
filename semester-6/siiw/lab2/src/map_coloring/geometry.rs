use super::types::*;
use std::cmp;

#[derive(Debug, PartialEq, Clone, Copy)]
enum Orientation {
  Clockwise,
  CounterClockwise,
  Colinear
}

fn on_segment(p: &Point, q: &Point, r: &Point) -> bool {
  q.x <= cmp::max(p.x, r.x) && q.x >= cmp::min(p.x, r.x) &&
  q.x <= cmp::max(p.y, r.y) && q.y >= cmp::min(p.y, r.y)
}

fn orientation(p: &Point, q: &Point, r: &Point) -> Orientation {
  let val = ((q.y - p.y) * (r.x - q.x)) - ((q.x - p.x) * (r.y - q.y));

  if val > 0 {
    Orientation::Clockwise
  } else if val < 0 {
    Orientation::CounterClockwise
  } else {
    Orientation::Colinear
  }
}

pub fn segments_intersect(p1: &Point, q1: &Point, p2: &Point, q2: &Point) -> bool {
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

pub fn calc_dist(a: &Point, b: &Point) -> f32 {
  (((a.x - b.x).pow(2) + (a.y - b.y).pow(2)) as f32).sqrt()
}
