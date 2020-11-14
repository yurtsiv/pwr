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

print(calc_lev_dist("kitten", "sitting"))
print(calc_lev_dist("", "hello"))