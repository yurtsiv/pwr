import unittest
from oracle import Oracle
from Crypto.Cipher import AES

class OracleTest(unittest.TestCase):
    def setUp(self):
        self.oracle = Oracle("./keystore.jceks", "password")

    def test_ecb_encrypt(self):
        # 256 bits
        m = bytes.fromhex('AAAAAAAAAAAAAAAAAAAAAAAAAAAAAAAAAAAAAAAAAAAAAAAAAAAAAAAAAAAAAAAA')
        c = self.oracle.encrypt(AES.MODE_ECB, m)

        self.assertNotEqual(c, m)
        self.assertEqual(c[:16], c[16:])
 
    def test_cbc_encrypt(self):
        # 128 bits
        m = bytes.fromhex('AAAAAAAAAAAAAAAAAAAAAAAAAAAAAAAA')

        iv1, c1 = self.oracle.encrypt(AES.MODE_CBC, m)
        iv2, c2 = self.oracle.encrypt(AES.MODE_CBC, m)

        iv1int = int(iv1.hex(), 16)
        iv2int = int(iv2.hex(), 16)

        self.assertNotEqual(c1, m)
        self.assertNotEqual(c2, m)
        self.assertNotEqual(c1, c2)
        self.assertEqual(iv1int + 1, iv2int)
    
    def test_gcm_encrypt(self):
        # 128 bits
        m = bytes.fromhex('AAAAAAAAAAAAAAAAAAAAAAAAAAAAAAAA')

        iv1, c1 = self.oracle.encrypt(AES.MODE_GCM, m)
        iv2, c2 = self.oracle.encrypt(AES.MODE_GCM, m)

        iv1int = int(iv1.hex(), 16)
        iv2int = int(iv2.hex(), 16)

        self.assertNotEqual(c1, m)
        self.assertNotEqual(c2, m)
        self.assertNotEqual(c1, c2)
        self.assertNotEqual(iv1, iv2)
        self.assertNotEqual(iv1int + 1, iv2int)
    
    def test_challenge(self):
        # 128 bits
        m1 = bytes.fromhex('AAAAAAAAAAAAAAAAAAAAAAAAAAAAAAAA')
        m2 = bytes.fromhex('BBBBBBBBBBBBBBBBBBBBBBBBBBBBBBBB')

        c1 = self.oracle.challenge(AES.MODE_ECB, m1, m2)
        c1_count = 1
        c2_count = 0

        for _ in range(0, 1000):
            c = self.oracle.challenge(AES.MODE_ECB, m1, m2)
            if c == c1:
                c1_count += 1
            else:
                c2_count += 1

        self.assertLess(abs(1 - c1_count / c2_count), 0.1)
    
if __name__ == '__main__':
    unittest.main()