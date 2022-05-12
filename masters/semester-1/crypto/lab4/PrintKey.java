import java.security.KeyStore;
import java.io.FileInputStream;

public class PrintKey {
  private static final char[] HEX_ARRAY = "0123456789ABCDEF".toCharArray();

  public static String bytesToHex(byte[] bytes) {
      char[] hexChars = new char[bytes.length * 2];
      for (int j = 0; j < bytes.length; j++) {
          int v = bytes[j] & 0xFF;
          hexChars[j * 2] = HEX_ARRAY[v >>> 4];
          hexChars[j * 2 + 1] = HEX_ARRAY[v & 0x0F];
      }
      return new String(hexChars);
  }

  public static void main(String[] args) throws Exception {
    KeyStore ks = KeyStore.getInstance(KeyStore.getDefaultType());
  
    char[] password = "password".toCharArray();

    FileInputStream fis = null;

    try {
      fis = new FileInputStream("/home/stepy/.keystore");
      ks.load(fis, password);
    } finally {
      if (fis != null) {
        fis.close();
      }
    }

    KeyStore.Entry entry = ks.getEntry("mykey", new KeyStore.PasswordProtection(password));

    //Assign the entry as our secret key for later retrieval.
    javax.crypto.SecretKey key = ((KeyStore.SecretKeyEntry) entry).getSecretKey();

    System.out.println(PrintKey.bytesToHex(key.getEncoded()));
  }
}