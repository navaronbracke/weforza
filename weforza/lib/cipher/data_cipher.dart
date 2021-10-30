import 'package:encrypt/encrypt.dart';
import 'package:weforza/cipher/cipher.dart';

class DataCipher implements Cipher {
  DataCipher({
    required String encryptionKey,
    required String encryptionSalt,
  }) {
    assert(
      encryptionKey.length == 32,
      "A DataCipher requires an encryption key that is 32 characters long. Current key length: ${encryptionKey.length}",
    );
    _encrypter = Encrypter(
      AES(
        Key.fromUtf8(encryptionKey),
        mode: AESMode.ctr,
        padding: null,
      ),
    );
    _salt = IV.fromUtf8(encryptionSalt);
  }

  /// The internal encrypter.
  late final Encrypter _encrypter;

  /// The salt that is used for encryption.
  late final IV _salt;

  @override
  String decrypt(String value) {
    if (value.isEmpty) {
      return value;
    }

    return _encrypter.decrypt(Encrypted.fromBase64(value), iv: _salt);
  }

  @override
  String encrypt(String value) {
    if (value.isEmpty) {
      return value;
    }

    return _encrypter.encrypt(value, iv: _salt).base64;
  }
}