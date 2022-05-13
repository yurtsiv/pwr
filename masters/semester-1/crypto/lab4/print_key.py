import jks
import sys

keystore_path = sys.argv[1]
keystore_pass = sys.argv[2]

keystore = jks.KeyStore.load(keystore_path, keystore_pass)
keystore.entries['aeskey'].decrypt(keystore_pass)

print(keystore.entries['aeskey']._key.hex())
