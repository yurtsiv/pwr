use std::fs;

use crate::types::*;

fn parse_int(s: Option<&str>) -> i32 {
  s.unwrap().parse().unwrap()
}

fn parse(content: &String) -> Problem {
  let mut lines = content.lines();

  let mut dims = lines.next().unwrap().split(';');
  let width = parse_int(dims.next());
  let height = parse_int(dims.next());

  let mut connected_points: Vec<ConnectedPair> = Vec::new();
  let mut next_line = lines.next();

  while next_line != None {
    let mut coords = next_line.unwrap().split(';');
    let x1 = parse_int(coords.next());
    let y1 = parse_int(coords.next());

    let x2 = parse_int(coords.next());
    let y2 = parse_int(coords.next());

    connected_points.push(((x1, y1), (x2, y2)));

    next_line = lines.next();
  }

  Problem {
    width,
    height,
    connected_points
  }
}

pub fn parse_file(filepath: &String) -> Option<Problem> {
  match fs::read_to_string(filepath) {
    Ok(content) => Some(parse(&content)),
    Err(_) => None
  }
}