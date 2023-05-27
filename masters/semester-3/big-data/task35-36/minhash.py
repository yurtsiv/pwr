import mmh3
import numpy as np

class MinHash:
    def __init__(self, k):
        self.k = k
        self.elems = [float('inf')] * k
    
    def add(self, elem):
        for i in range(self.k):
            h = mmh3.hash(elem, i, signed=False)
            self.elems[i] = min(self.elems[i], h)

    def from_set(k, elems):
        min_hash = MinHash(k)
        for elem in elems:
            min_hash.add(elem)
        return min_hash
    
    def jaccard(self, other):
        return np.sum(np.array(self.elems) == np.array(other.elems)) / self.k
