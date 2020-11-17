# Levenshtein distance
def calc_lev_dist(a, b):
    def lev_dist(i, j):
        if min(i, j) == 0:
            return max(i, j)
 
        return min(
            lev_dist(i - 1, j) + 1,
            lev_dist(i, j - 1) + 1,
            lev_dist(i - 1, j - 1) + (0 if a[i - 1] == b[j - 1] else 1)
        )

    return lev_dist(len(a), len(b))

print("hello -> hello.....%d" % calc_lev_dist("hello", "hello"))
print("'' -> hello........%d" % calc_lev_dist("", "hello"))
print("kitten -> sitting..%d" % calc_lev_dist("kitten", "sitting"))
print("'' -> ''...........%d" % calc_lev_dist("", ""))