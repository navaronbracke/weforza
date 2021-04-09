import 'package:encrypt/encrypt.dart';
import 'package:test/test.dart';
import 'package:weforza/crypto/cipher.dart';

void main(){
  group("Cipher tests", (){
    test("Cipher can encrypt a value and decrypt it again", (){
      final cipher = Cipher();

      final String value = "text to encrypt";
      final Encrypted encrypted = cipher.encrypt(value);

      expect(cipher.decrypt(encrypted), equals(value));
    });
  });
}