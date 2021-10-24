
import 'package:weforza/cipher/cipher.dart';

/// This class represents a cipher that does not modify the input.
class PassThroughCipher implements Cipher {
  @override
  String decrypt(String value) => value;

  @override
  String encrypt(String value) => value;
}