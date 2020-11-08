def average(arr):
  return sum(arr) / len(arr)

def moving_average(step, arr):
  res = []
  for i in range(0, (len(arr) - step) + 1):
    subset = arr[i:i+step]
    res.append(average(subset))

  return res

arr = [2, 1, 3, 4, 5, 7, 8]

print(moving_average(arr[0], arr[1:]))
