import statistics

def is_num(x):
  t = type(x)
  return t == int or t == float

def test(arr):
  num_arr = [e for e in arr if is_num(e)]
  length = len(num_arr)

  return (
    len(num_arr),
    0 if length == 0 else sum(num_arr) / length,
    statistics.variance(num_arr),
    min(num_arr),
    max(num_arr)
  )


arr = [True, 10, 2, 1, 1.2, 5, "hello"]

print(test(arr))