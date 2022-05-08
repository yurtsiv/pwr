import random

M = 100
N = 1000
P = 1

with open("big.txt", "a") as f:
    for m in range(0, M):
        for n in range(0, N):
            f.write("A," + str(m) + "," + str(n) + "," + str(random.randint(1, 10)) + "\n")

    for m in range(0, N):
        for n in range(0, P):
            f.write("B," + str(m) + "," + str(n) + "," + str(random.randint(1, 10)) + "\n")
