import 'package:weforza/cipher/data_cipher.dart';

/// This [DataCipher] uses a fixed encryption key that is suitable for testing.
class TestCipher extends DataCipher {
  TestCipher(): super(
      encryptionKey: "01234567890123456789012345678901",
      encryptionSalt: "HyTLaZVttOjWriUx",
  );
}