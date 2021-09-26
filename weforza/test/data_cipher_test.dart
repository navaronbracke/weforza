
import 'package:test/test.dart';
import 'package:weforza/cipher/data_cipher.dart';

void main(){
  group("DataCipher tests", (){
    final cipher = DataCipher(encryptionKey: "long enough test encryption key1");

    test("DataCipher can encrypt and decrypt", (){
      final s = "test123456789Abcéhg";

      final encrypted = cipher.encrypt(s);

      final decrypted = cipher.decrypt(encrypted);

      expect(encrypted, isNot(s));

      expect(decrypted, s);
    });

    test("DataCipher encrypt empty value returns value", (){
      expect(cipher.encrypt(""), "");
    });

    test("DataCipher decrypt empty value returns value", (){
      expect(cipher.decrypt(""), "");
    });
  });
}