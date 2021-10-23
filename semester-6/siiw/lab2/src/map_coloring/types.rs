use draw::RGB;
use petgraph::graph::Graph;
use petgraph::Undirected;

pub type Map = Graph<Point, u32, Undirected>;

#[derive(Debug, PartialEq, Clone)]
pub struct Point {
  pub x: i32,
  pub y: i32,
  pub color: Option<RGB>
}
