import 'package:encrypt/encrypt.dart';

/// This class provides encryption/decryption of data.
class Cipher {

  /// Encrypt a given value.
  /// Returns value as an instance of [Encrypted].
  Encrypted encrypt(String value){
    final Key key = Key.fromLength(32);
    final IV iv = IV.fromLength(16);
    final Encrypter crypto = Encrypter(AES(key));

    return crypto.encrypt(value, iv: iv);
  }

  /// Decrypt a given [Encrypted] value.
  /// Returns the unencrypted value as a String.
  String decrypt(Encrypted value){
    final Key key = Key.fromLength(32);
    final IV iv = IV.fromLength(16);
    final Encrypter crypto = Encrypter(AES(key));

    return crypto.decrypt(value, iv: iv);
  }
}