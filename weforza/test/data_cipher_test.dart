
import 'package:test/test.dart';
import 'package:weforza/cipher/data_cipher.dart';

void main(){
  test("DataCipher can encrypt and decrypt", (){
    final cipher = DataCipher(encryptionKey: "long enough test encryption key1");

    final s = "test123456789Abcéhg";

    final encrypted = cipher.encrypt(s);

    final decrypted = cipher.decrypt(encrypted);
    
    expect(encrypted, isNot(s));

    expect(decrypted, s);
  });
}