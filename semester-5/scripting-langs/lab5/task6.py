from decimal import Decimal

def calc_pi(n):
  res = Decimal(1)
  for i in range(1, n + 1):
    x = Decimal(4 * i ** 2) / Decimal(4 * i ** 2 - 1)
    res *= x

  return res * 2

def read_int(label):
  while True:
    print(label)
    s = input()
    try:
      return int(s)
    except:
      pass

while True:
  n = read_int("n:")
  print("Pi: " + str(calc_pi(n)))