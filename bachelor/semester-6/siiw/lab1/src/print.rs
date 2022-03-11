use draw::*;
use RGB;

use rand::Rng;
use crate::types::*;

const GRID_GAP: i32 = 50;
const HALF_GRID_GAP: i32 = GRID_GAP / 2;
const DOT_RADIUS: u32 = 7;
const GRID_DOT_RADIUS: u32 = 1;
const GRID_DOT_COLOR: RGB = RGB::new(130, 130, 130);
const WHITE_COLOR: RGB = RGB::new(255, 255, 255);

fn transform_coords(point: (i32, i32)) -> (f32, f32) {
  (
    (point.0 * GRID_GAP + HALF_GRID_GAP) as f32,
    (point.1 * GRID_GAP + HALF_GRID_GAP) as f32
  )
}

fn get_rand_rgb(rng: &mut rand::rngs::ThreadRng) -> RGB {
  RGB::new(
    rng.gen_range(0, 220),
    rng.gen_range(0, 220),
    rng.gen_range(0, 220)
  )
}

fn make_dot(x: i32, y: i32, radius: u32, color: RGB) -> Drawing {
  let coords = transform_coords((x, y));

  Drawing::new()
    .with_shape(Shape::Circle {
      radius,
    })
    .with_xy(coords.0, coords.1)
    .with_style(Style::filled(color))
}

pub fn gen_svg(problem: &Problem, solution: &Individual, file_path: &String) {
  let mut rng = rand::thread_rng();
  let x_size = (problem.width * GRID_GAP) as u32;
  let y_size = (problem.height * GRID_GAP) as u32;

  let mut canvas = Canvas::new(x_size, y_size);

  let background = Drawing::new()
    .with_shape(Shape::Rectangle {
      width: x_size,
      height: y_size
    })
    .with_style(Style::filled(WHITE_COLOR));
  
  canvas.display_list.add(background);

  for x in 0..problem.width {
    for y in 0..problem.height {
      let grid_dot = make_dot(x, y, GRID_DOT_RADIUS, GRID_DOT_COLOR);
      canvas.display_list.add(grid_dot);
    }
  }
  
  for (i, path) in solution.iter().enumerate() {
    let mut origin_point = problem.connected_points.get(i).unwrap().0;
    let path_color = get_rand_rgb(&mut rng);

    for segment in path.iter() {
      let mut to_point = origin_point;

      let dir = segment.0;

      match dir {
        Dir::RIGHT => {
          to_point.0 += segment.1
        }
        Dir::LEFT => {
          to_point.0 -= segment.1
        }
        Dir::UP => {
          to_point.1 -= segment.1
        }
        Dir::DOWN => {
          to_point.1 += segment.1
        }
      }

      let to_coords = transform_coords(to_point);
      let origin_coords = transform_coords(origin_point);
  
      let line_shape = shape::LineBuilder::new(
        origin_coords.0,
        origin_coords.1
      )
        .line_to(to_coords.0, to_coords.1)
        .build();
      
      let drawing = Drawing::new()
        .with_shape(line_shape)
        .with_style(Style::stroked(2, path_color));
      
      canvas.display_list.add(drawing);
      origin_point = to_point;
    }
  }

  for connected_pair in problem.connected_points.iter() {
    let (point1, point2) = connected_pair;
    let color = get_rand_rgb(&mut rng);
    let dot1 = make_dot(point1.0, point1.1, DOT_RADIUS, color); 
    let dot2 = make_dot(point2.0, point2.1, DOT_RADIUS, color); 

    canvas.display_list.add(dot1);
    canvas.display_list.add(dot2);
  }

  render::save(
    &canvas,
    file_path,
    SvgRenderer::new(),
  )
  .expect("Failed to save");
}
