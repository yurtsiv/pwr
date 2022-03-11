use draw::*;
use rand::Rng;

use super::types::*;

const WHITE: RGB = RGB::new(255, 255, 255);
const BLACK: RGB = RGB::new(0, 0, 0);

fn make_dot(x: i32, y: i32, radius: u32, color: RGB) -> Drawing {
  Drawing::new()
    .with_shape(Shape::Circle {
      radius,
    })
    .with_xy(x as f32, y as f32)
    .with_style(Style::filled(color))
}

fn get_rand_rgb(rng: &mut rand::rngs::ThreadRng) -> RGB {
  RGB::new(
    rng.gen_range(0, 255),
    rng.gen_range(0, 255),
    rng.gen_range(0, 255)
  )
}

pub fn get_colors_vec(num_of_colors: i32) -> Vec<RGB> {
  let mut rng = rand::thread_rng();

  (0..num_of_colors)
    .map(|_| get_rand_rgb(&mut rng))
    .collect()
}

pub fn gen_svg(
  map: &Map, 
  width: u32, 
  height: u32, 
  file_path: &String
) {
  let point_radius = ((width + height) as f32 * 0.007) as u32;

  let mut canvas = Canvas::new(width, height);

  let background = Drawing::new()
    .with_shape(Shape::Rectangle {
      width,
      height
    })
    .with_style(Style::filled(WHITE));

  canvas.display_list.add(background);

  for edge in map.raw_edges() {
    let point1 = map.node_weight(edge.source()).unwrap();
    let point2 = map.node_weight(edge.target()).unwrap();

    let line_shape = shape::LineBuilder::new(
      point1.x as f32,
      point1.y as f32
    )
      .line_to(point2.x as f32, point2.y as f32)
      .build();
    
    let drawing = Drawing::new()
      .with_shape(line_shape)
      .with_style(Style::stroked(2, BLACK));

    canvas.display_list.add(drawing);
  }

  for node_index in map.node_indices() {
    let point = map.node_weight(node_index).unwrap();
    let color = match point.color {
      Some(color) => color,
      None => BLACK
    };

    let dot = make_dot(point.x, point.y, point_radius, color);
    canvas.display_list.add(dot);
  }

  render::save(
    &canvas,
    file_path,
    SvgRenderer::new(),
  )
  .expect("Failed to save");
}