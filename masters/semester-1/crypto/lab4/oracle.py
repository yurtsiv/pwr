import random
import jks
from Crypto.Cipher import AES
from numpy import binary_repr

# keytool -genseckey -alias aeskey -keyalg aes -keysize 128 -keystore keystore.jceks -storetype jceks

SUPPORTED_MODES = [AES.MODE_ECB, AES.MODE_CBC, AES.MODE_GCM]


class Oracle:
    def __init__(self, keystore_path, keystore_pass):
        keystore = jks.KeyStore.load(keystore_path, keystore_pass)
        keystore.entries['aeskey'].decrypt(keystore_pass)
        self.key = keystore.entries['aeskey']._key
        self.iv = 0
    
    def reset_iv(self):
        self.iv = 0

    def encrypt(self, mode, m):
        return self._get_enc_func(mode)(m)

    def _get_enc_func(self, mode):
        if not mode in SUPPORTED_MODES:
            raise "Unsupported mode"

        if mode == AES.MODE_ECB:
            return self._encrypt_ecb
        elif mode == AES.MODE_CBC:
            return self._encrypt_cbc
        elif mode == AES.MODE_GCM:
            return self._encrypt_gcm

    def _encrypt_ecb(self, m):
        cipher = AES.new(self.key, AES.MODE_ECB)
        return cipher.encrypt(m)

    def _encrypt_cbc(self, m):
        self.iv += 1
        iv = bytes.fromhex(hex(self.iv)[2:].rjust(32, '0'))
        cipher = AES.new(self.key, AES.MODE_CBC, iv=iv)
        return iv, cipher.encrypt(m)
    
    def _encrypt_gcm(self, m):
        cipher = AES.new(self.key, AES.MODE_GCM)
        c = cipher.encrypt(m) 
        return cipher.nonce, c

    def challenge(self, mode, m1, m2):
        b = random.randint(0, 1)
        m = m1 if b == 0 else m2
        return self._get_enc_func(mode)(m)
