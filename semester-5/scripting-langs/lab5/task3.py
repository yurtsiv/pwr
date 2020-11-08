def read_int(label):
  while True:
    print(label)
    s = input()
    try:
      return int(s)
    except:
      pass

def is_prime(n):
  if n < 2:
    return False

  for i in range(2, n // 2):
    if (n % i) == 0:
      return False
  
  return True

def next_prime(n):
  count = n + 1
  while True:
    if is_prime(count):
      return count
    else:
      count += 1

k = read_int("k:")
while k < 1:
  k = read_int("k:")

n = read_int("\nStart value:")

print("\nPrimes:")
for _ in range(0, k):
  next = next_prime(n)
  print(next)
  n = next
