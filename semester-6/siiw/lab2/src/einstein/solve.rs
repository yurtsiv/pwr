use crate::csp;
use crate::csp::types::*;
use super::types::*;

// const solution: &'static [i32] = &[
//     0, 2, 3, 4, 1,
//     1, 3, 2, 4, 0,
//     0, 1, 3, 2, 4,
//     1, 2, 0, 4, 3,
//     0, 2, 4, 1, 3
// ];

fn neighbours(var_id1: VarId, var_id2: VarId) -> Constraint {
  let check = move |vars: &Vec<i32>| {
    (vars[0] - vars[1]).abs() == 1
  };

  Constraint::custom(
    Box::new(check),
    vec![var_idx(var_id1), var_idx(var_id2)]
  )
}

fn on_the_left(var_id1: VarId, var_id2: VarId) -> Constraint {
  let check = move |vars: &Vec<i32>| {
    vars[0] == vars[1] - 1
  };

  Constraint::custom(
    Box::new(check),
    vec![var_idx(var_id1), var_idx(var_id2)]
  )
}

pub fn solve(solve_type: SolveType, var_selector: VarSelector, val_selector: ValSelector) {
  let mut vars: Vec<CSPVar> = Vec::new();

  for i in 0..VAR_IDS.len() {
    vars.push(
      CSPVar::new(i, (0..5).collect(), VAR_IDS[i].to_string())
    )
  }

  let mut constraints: Vec<Constraint> = vec![
    // 1. Norweg zamieszkuje pierwszy dom
    Constraint::unary(
      var_idx(VarId::NORWEGIAN), 0
    ),

    // 2. Anglik mieszka w czerwonym domu.
    Constraint::binary_eq(
      var_idx(VarId::ENGLISH),
      var_idx(VarId::RED)
    ),

    // 3. Zielony dom znajduje się bezpośrednio po lewej stronie domu białego.
    on_the_left(VarId::GREEN, VarId::WHITE),

    // 4. Duńczyk pija herbatkę.
    Constraint::binary_eq(
      var_idx(VarId::DANISH),
      var_idx(VarId::TEA)
    ),

    // 5. Palacz papierosów light mieszka obok hodowcy kotów.
    neighbours(VarId::LIGHTCIGS, VarId::CAT),

    // 6. Mieszkaniec żółtego domu pali cygara.
    Constraint::binary_eq(
      var_idx(VarId::YELLOW),
      var_idx(VarId::CIGARS)
    ),

    // 7. Niemiec pali fajkę.
    Constraint::binary_eq(
      var_idx(VarId::GERMAN),
      var_idx(VarId::PIPE)
    ),

    // 8. Mieszkaniec środkowego domu pija mleko.
    Constraint::unary(
      var_idx(VarId::MILK),
      2
    ),

    // 9. Palacz papierosów light ma sąsiada, który pija wodę.
    neighbours(VarId::LIGHTCIGS, VarId::WATER),

    // 10.Palacz papierosów bez filtra hoduje ptaki.
    Constraint::binary_eq(
      var_idx(VarId::NOFILTER),
      var_idx(VarId::BIRD)
    ),

    // 11.Szwed hoduje psy.
    Constraint::binary_eq(
      var_idx(VarId::SWEDE),
      var_idx(VarId::DOG)
    ),

    // 12.Norweg mieszka obok niebieskiego domu.
    neighbours(VarId::NORWEGIAN, VarId::BLUE),

    // 13.Hodowca koni mieszka obok żółtego domu.
    neighbours(VarId::HORSE, VarId::YELLOW),

    // 14.Palacz mentolowych pija piwo.
    Constraint::binary_eq(
      var_idx(VarId::MENTHOL),
      var_idx(VarId::BEER)
    ),

    // 15.W zielonym domu pija się kawę
    Constraint::binary_eq(
      var_idx(VarId::GREEN),
      var_idx(VarId::COFFEE)
    )
  ];

  // ensure no duplicates assigned
  for group_i in 0..5 {
    for i in 0..5 {
      for j in 0..5 {
        if i != j {
          constraints.push(
            Constraint::not_eq(vec! [
              group_i * 5 + j,
              group_i * 5 + i
            ])
          )
        }
      }
    }
  }

  let solutions = csp::solve::solve(
    &vars,
    constraints,
    solve_type,
    var_selector,
    val_selector
  );

  print!("\nSolutions: {:?}", solutions);
}