def average(arr):
  return sum(arr) / len(arr)

def moving_average(step, arr):
  res = []
  actual_step = min(step, len(arr))
  for i in range(0, (len(arr) - actual_step) + 1):
    subset = arr[i:i+actual_step]
    res.append(average(subset))

  return res

arr = [2, 1, 3, 4, 5, 7, 8]

print(moving_average(arr[0], arr[1:]))
