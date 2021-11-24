use crate::types::*;

fn distance(p1: Point, p2: Point) -> f32 {
  ((
    (p2.0 - p1.0).pow(2) + (p2.1 - p1.1).pow(2)
  ) as f32).sqrt().round()
}

pub fn calc_distance_matrix(cities: &Vec<City>, depot: &Point) -> Vec<Vec<f32>> {
  let mut res: Vec<Vec<f32>> = Vec::new();

  let mut first_row: Vec<f32> = vec![0f32];
  for city in cities.iter() {
    first_row.push(
      distance(city.coords, *depot)
    )
  }

  res.push(first_row);

  for city_1 in cities.iter() {
    let mut row: Vec<f32> = vec![distance(city_1.coords, *depot)];

    for city_2 in cities.iter() {
      row.push(
        distance(city_1.coords, city_2.coords)
      );
    }

    res.push(row);
  }

  res
}