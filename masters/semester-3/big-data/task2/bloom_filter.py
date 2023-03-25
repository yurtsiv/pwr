from bitarray import bitarray
import mmh3


class BloomFilter:
    def __init__(self, m, k):
        self.k = k
        self.m = m
        self.bits = bitarray('0' * m)

    def add(self, elem):
        for i in range(self.k):
            hash = mmh3.hash(elem, i, signed=False)
            self.bits[hash % self.m] = 1

    def add_multiple(self, elems):
        for elem in elems:
            self.add(elem)

    def has(self, elem):
        matches = 0
        for i in range(self.k):
            hash = mmh3.hash(elem, i, signed=False)
            matches += 1 if self.bits[hash % self.m] == 1 else 0

        return matches == self.k
