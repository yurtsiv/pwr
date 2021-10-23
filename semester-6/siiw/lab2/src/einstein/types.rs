use std::fmt;

#[derive(PartialEq, Debug)]
pub enum VarId {
  // nationalities
  NORWEGIAN, // 0
  ENGLISH, // 1
  GERMAN,  // 2
  SWEDE, // 3
  DANISH, // 4
 
  // colors
  BLUE, // 5
  GREEN, // 6
  RED, // 7
  WHITE, // 8
  YELLOW, // 9
 
  // tabaccos
  CIGARS, // 10
  LIGHTCIGS, // 11
  PIPE, // 12
  NOFILTER, // 13
  MENTHOL, // 14
 
  // beverages
  TEA, // 15 
  MILK, // 16
  WATER, // 17
  BEER, // 18
  COFFEE, // 19
 
  // animals
  CAT, // 20
  BIRD, // 21
  DOG, // 22
  HORSE, // 23
  FISH, // 24
}

impl fmt::Display for VarId {
  fn fmt(&self, f: &mut fmt::Formatter) -> fmt::Result {
    write!(f, "{:?}", self)
  }
}

pub const VAR_IDS: &'static [VarId] = &[
  // nationality
  VarId::NORWEGIAN,
  VarId::ENGLISH,
  VarId::GERMAN,
  VarId::SWEDE,
  VarId::DANISH,
 
  // colors
  VarId::BLUE,
  VarId::GREEN,
  VarId::RED,
  VarId::WHITE,
  VarId::YELLOW,
 
  // tabaccos
  VarId::CIGARS,
  VarId::LIGHTCIGS,
  VarId::PIPE,
  VarId::NOFILTER,
  VarId::MENTHOL,
 
  // beverages
  VarId::TEA,
  VarId::MILK,
  VarId::WATER,
  VarId::BEER,
  VarId::COFFEE,
 
  // animals
  VarId::CAT,
  VarId::BIRD,
  VarId::DOG,
  VarId::HORSE,
  VarId::FISH
];

pub fn var_idx(id: VarId) -> usize {
  VAR_IDS.iter().position(|x| id == *x).unwrap()
}
