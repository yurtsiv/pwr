import jks
import sys

# keytool -genseckey -alias aeskey -keyalg aes -keysize 128 -keystore keystore.jceks -storetype jceks

keystore_path = sys.argv[1]
keystore_pass = 'passphrase'

keystore = jks.KeyStore.load(keystore_path, keystore_pass)

print(keystore.private_keys)
print(keystore.certs)
print(keystore.secret_keys)