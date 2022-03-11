use rand::{
  self,
  distributions::{Distribution, Uniform},
  rngs::{StdRng},
  SeedableRng
};
use petgraph::graph::Graph;
use petgraph::graph::NodeIndex;
use super::types::*;
use super::geometry::*;

fn intersect_some_edge(map: &Map, point1: &Point, point2: &Point) -> bool {
  // to avoid colission detection with other
  // edges of a point
  let mut p1 = point1.clone();
  p1.x -= 1;
  p1.y -= 1;

  let mut p2 = point2.clone();
  p2.x -= 1;
  p2.y -= 1;

  for edge in map.raw_edges() {
    if segments_intersect(
      &p1,
      &p2,
      map.node_weight(edge.source()).unwrap(),
      map.node_weight(edge.target()).unwrap()
    ) {
      return true
    }
  }

  false
}

fn get_next_neighbour(map: &Map, node_indices: &Vec<NodeIndex>, origin_idx: usize) -> Option<NodeIndex> {
  let mut indices_sorted = (0..node_indices.len())
    .map(|idx| (
      idx as usize,
      calc_dist(
        map.node_weight(node_indices[idx as usize]).unwrap(),
        map.node_weight(node_indices[origin_idx]).unwrap()
      )
    ))
    .collect::<Vec<(usize, f32)>>();
  
  indices_sorted.sort_by(|(_, d1), (_, d2)| {
    d1.partial_cmp(d2).unwrap()
  });

  let current_neighbors: Vec<NodeIndex> = map
    .neighbors_undirected(node_indices[origin_idx])
    .collect();

  for (potential_neighbor_idx, dist) in indices_sorted {
    if  dist != 0.0 &&
        !current_neighbors.contains(&node_indices[potential_neighbor_idx]) &&
        !intersect_some_edge(
          map,
          &map.node_weight(node_indices[origin_idx]).unwrap(),
          &map.node_weight(node_indices[potential_neighbor_idx]).unwrap()
        )
    {
      return Some(node_indices[potential_neighbor_idx]);
    }
  }

  return None
}

pub fn gen_map(width: i32, height: i32, num_of_points: i32) -> Map {
  let x_distr = Uniform::from(0..width);
  let y_distr = Uniform::from(0..height);

  // let mut rng = rand::thread_rng();
  let mut rng = StdRng::seed_from_u64(222);
  let mut map = Graph::new_undirected();

  for _ in 0..num_of_points {
    map.add_node(
      Point {
        x: x_distr.sample(&mut rng),
        y: y_distr.sample(&mut rng),
        color: None
      }
    );
  }

  let point_distr = Uniform::from(0..num_of_points);
  let node_indices: Vec<NodeIndex> = map.node_indices().collect();

  // will not generate a complete graph
  // todo: SHUFFLE THE ARRAY
  for _ in 0..(num_of_points * num_of_points * num_of_points)  {
    let node_idx = point_distr.sample(&mut rng);

    match get_next_neighbour(&map, &node_indices, node_idx as usize) {
      Some(next_neighbour) => {
        map.add_edge(
          node_indices[node_idx as usize],
          next_neighbour,
          0
        );
      }
      None => {
      }
    }
  }


  map
}