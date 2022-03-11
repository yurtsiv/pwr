#[derive(Clone)]
pub struct CSPVar {
  pub index: usize,
  pub value: Option<i32>,
  pub label: String,

  domain: Vec<i32>,
  domain_mask: Vec<bool>,
  saved_domain_mask: Option<Vec<bool>>
}

impl CSPVar {
  pub fn new(index: usize, domain: Vec<i32>, label: String) -> CSPVar {
    let domain_len = (&domain).len();

    CSPVar {
      index,
      value: None,
      label,
      domain,
      domain_mask: (0..domain_len).map(|_| true).collect(),
      saved_domain_mask: None
    }
  }

  pub fn domain(&self) -> Box<dyn Iterator<Item=(usize, i32)> + '_> {
    Box::new(
      self.domain_mask
        .iter()
        .enumerate()
        .filter(|(_, val_included)| **val_included)
        .map(move |(val_idx, _)| (val_idx, self.domain[val_idx]))
    )
  }

  pub fn full_domain(&self) -> Box<dyn Iterator<Item=(usize, i32)> + '_> {
    Box::new(
      self.domain
        .iter()
        .map(|v| *v)
        .enumerate()
    )
  }

  pub fn exclude_val(&mut self, val_idx: usize) {
    self.domain_mask[val_idx] = false
  }

  pub fn include_val(&mut self, val_idx: usize) {
    self.domain_mask[val_idx] = true
  }

  pub fn save_domain_mask(&mut self) {
    self.saved_domain_mask = Some(self.domain_mask.clone())
  }

  pub fn restore_saved_mask(&mut self) {
    if self.saved_domain_mask != None {
      self.domain_mask = self.saved_domain_mask.as_ref().unwrap().to_vec();
      self.saved_domain_mask = None
    } else {
      panic!("No saved domain mask to restore");
    }
  }

  pub fn reset_domain(&mut self) {
    self.domain_mask = self
      .domain_mask
      .iter()
      .map(|_| true)
      .collect();
  }
}



pub enum ConstraintKind {
  Eq,
  NotEq,
  Custom
}

pub struct Constraint {
  pub kind: ConstraintKind,
  pub vars_indexes: Vec<usize>,
  pub custom_fn: Option<Box<dyn Fn(&Vec<i32>) -> bool>>
}

impl Constraint {
  pub fn basic(
    kind: ConstraintKind,
    vars_indexes: Vec<usize>
  ) -> Constraint {
    Constraint {
      kind,
      vars_indexes,
      custom_fn: None
    }
  }

  pub fn eq(vars_indexes: Vec<usize>) -> Constraint {
    Constraint::basic(ConstraintKind::Eq, vars_indexes)
  }

  pub fn not_eq(vars_indexes: Vec<usize>) -> Constraint {
    Constraint::basic(ConstraintKind::NotEq, vars_indexes)
  }

  pub fn binary_eq(idx1: usize, idx2: usize) -> Constraint {
    Constraint::eq(vec![idx1, idx2])
  }

  pub fn custom(
    custom_fn: Box<dyn Fn(&Vec<i32>) -> bool>,
    vars_indexes: Vec<usize>
  ) -> Constraint {
    Constraint {
      kind: ConstraintKind::Custom,
      vars_indexes,
      custom_fn: Some(custom_fn)
    }
  }

  pub fn unary(
    var_idx: usize,
    var_val: i32
  ) -> Constraint {
    let closure = move |vars: &Vec<i32>| {
      vars[0] == var_val
    };

    Constraint::custom(
      Box::new(closure),
      vec![var_idx]
    )
  }
}

#[derive(PartialEq)]
pub enum SolveType {
  Backtracking,
  ForwardChecking ,
  AC3Dynamic,
  AC3Static
}

// corresponding indexes
pub type ConstraintsOptimized<'a> = Vec<Vec<&'a Constraint>>;
pub type NeighbouringVars = Vec<Vec<usize>>;

pub type Solution = Vec<i32>;
pub type DomainVal = (usize, i32);
pub type Domain = Vec<DomainVal>;
pub type Values = Vec<Option<i32>>;
pub type Vars = Vec<CSPVar>;

pub type VarSelector = Box<dyn Fn(&Vars, &Values, Option<usize>) -> Option<usize>>;
pub type ValSelector = Box<dyn Fn(&Vars, &mut Values, &ConstraintsOptimized, &NeighbouringVars, usize) -> Option<DomainVal>>;