from Crypto.Cipher import AES
from oracle import Oracle

def xor_bytes(x, y):
    return bytearray([a ^ b for (a,b) in zip(x, y)])

oracle = Oracle("./keystore.jceks", "password")

m0 = bytes.fromhex('AAAAAAAAAAAAAAAAAAAAAAAAAAAAAAAA')
m1 = bytes.fromhex('BBBBBBBBBBBBBBBBBBBBBBBBBBBBBBBB')

def distinguish():
    iv, c = oracle.challenge(AES.MODE_CBC, m0, m1)
    next_iv = bytes.fromhex(hex(int(iv.hex(), 16) + 1)[2:].rjust(32, '0'))

    m = xor_bytes(xor_bytes(iv, next_iv), m0)
    _, c_prime = oracle.encrypt(AES.MODE_CBC, m)

    return (0, c) if c == c_prime else (1, c)

experiments = 1000
succ = 0
for _ in range(experiments):
    oracle.reset_iv()
    b, c = distinguish()
    oracle.reset_iv()
    _, c_check = oracle.encrypt(AES.MODE_CBC, m0 if b == 0 else m1)
    succ += 1 if c == c_check else 0

print(f"{succ} out of {experiments} guessed")
