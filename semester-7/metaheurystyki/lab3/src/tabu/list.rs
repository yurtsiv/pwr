use crate::types::*;
use linked_hash_set::*;

pub struct TabuList {
  size: i32,
  curr_size: i32,
  set: LinkedHashSet<Individual>
}

impl TabuList {
  pub fn new(size: i32) -> TabuList {
    TabuList {
      size,
      curr_size: 0,
      set: LinkedHashSet::new()
    }
  } 

  pub fn add(&mut self, ind: &Individual) {
    self.set.insert(ind.clone());

    if self.curr_size == self.size {
      self.set.pop_back();
    } else {
      self.curr_size += 1;
    }
  }

  pub fn contains(&self, ind: &Individual) -> bool {
    self.set.contains(ind)
  }
}