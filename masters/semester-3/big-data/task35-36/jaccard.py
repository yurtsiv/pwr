def jaccard(set1, set2):
    nominator = float(len(set1.intersection(set2)))
    denominator = float(len(set1.union(set2)))
    return nominator / denominator