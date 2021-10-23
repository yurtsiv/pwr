use petgraph::graph::NodeIndex;
use super::gen_map::*;
use super::print_map::*;
use crate::csp::types::*;
use crate::csp;

pub fn solve(num_of_points: usize, solve_type: SolveType, var_selector: VarSelector, val_selector: ValSelector) {
    let width = 1000;
    let height = 1000;
    let k = 4;

    let mut map = gen_map(width, height, num_of_points as i32);

    let mut vars: Vec<CSPVar> = Vec::new();
    let mut constraints: Vec<Constraint> = Vec::new();

    for node_index in map.node_indices() {
        vars.push(
            CSPVar::new(
                node_index.index(),
                (0..k).collect(),
                String::from("noname")
            )
        );
    }

    for edge in map.raw_edges() {
        constraints.push(
            Constraint::not_eq(
                vec![edge.source().index(), edge.target().index()]
            )
        )
    }

    print!("\nMap generated");

    let solutions = csp::solve::solve(
        &mut vars,
        constraints,
        solve_type,
        var_selector,
        val_selector
    );

    // let colors = get_colors_vec(k);

    // for (i, values) in solutions.iter().enumerate() {
    //   for (point_idx, color) in values.iter().enumerate() {
    //       let node = map.node_weight_mut(
    //           NodeIndex::new(vars[point_idx].index)
    //       ).unwrap();

    //       node.color = Some(colors[*color as usize]);
    //   }

    //   gen_svg(
    //       &map,
    //       width as u32,
    //       height as u32,
    //       &format!("/home/stepy/Dev/pwr-priv/semester-6/siiw/lab2/map{}.svg", i)
    //   );
    // }
}
