
/// This class represents an interface that encrypts and decrypts Strings.
abstract class Cipher {
  /// Encrypt the given [value].
  String encrypt(String value);

  /// Decrypt the given [value].
  String decrypt(String value);
}