use std::fs;
use crate::types::*;
use crate::geometry::*;

fn parse_int(s: Option<&str>) -> i32 {
  s.unwrap().trim().parse().unwrap()
}

fn parse_uint(s: Option<&str>) -> u32 {
  s.unwrap().trim().parse().unwrap()
}

fn parse_float(s: Option<&str>) -> f32 {
  s.unwrap().trim().parse().unwrap()
}

pub fn parse_int_param(s: Option<&str>) -> i32 {
  let mut line = s.unwrap().split(" : ");
  line.next();
  parse_int(line.next())
}

pub fn parse_uint_param(s: Option<&str>) -> u32 {
  let mut line = s.unwrap().split(" : ");
  line.next();
  parse_uint(line.next())
}

pub fn parse_float_param(s: Option<&str>) -> f32 {
  let mut line = s.unwrap().split(" : ");
  line.next();
  parse_float(line.next())
}

pub fn parse_str_param(s: Option<&str>) -> String {
  let mut line = s.unwrap().split(" : ");
  line.next();

  String::from(line.next().unwrap())
}

fn parse(content: &String) -> Problem {
  let mut lines = content.lines();

  lines.next();
  lines.next();
  lines.next(); 

  let dimension = parse_int_param(lines.next());

  lines.next();

  let capacity = parse_int_param(lines.next());

  lines.next();

  let mut cities_coords: Vec<Point> = Vec::new();
  for _ in 0..dimension {
    let mut chunks = lines.next().unwrap().trim().split(' ');

    chunks.next();

    let x = parse_int(chunks.next());
    let y = parse_int(chunks.next());
    cities_coords.push(
      (x, y)
    );
  }

  lines.next();

  let mut demands: Vec<i32> = Vec::new();
  for _ in 0..dimension {
    let mut chunks = lines.next().unwrap().split(' ');

    chunks.next();

    demands.push(
      parse_int(
        chunks.next()
      )
    );
  }

  lines.next();

  let depot_idx = parse_int(lines.next()) - 1;

  let mut depot: Option<Point> = None;
  let mut cities: Vec<City> = Vec::new();
  for (i, coords) in cities_coords.iter().enumerate() {
    if i == depot_idx as usize {
      depot = Some(*coords);
    } else {
      cities.push(
        City {
          number: i as i32,
          coords: *coords,
          demand: *demands.get(i).unwrap()
        }
      )
    }
  }

  Problem {
    capacity,
    distances: calc_distance_matrix(&cities, &depot.unwrap()),
    depot: depot.unwrap(),
    cities
  }
}

pub fn parse_file(filepath: &String) -> Option<Problem> {
  match fs::read_to_string(filepath) {
    Ok(content) => Some(parse(&content)),
    Err(_) => None
  }
}