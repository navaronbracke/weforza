import 'package:file/file.dart' as fs;

import 'package:weforza/exceptions/exceptions.dart';

/// This interface defines a delegate for picking a file to import data from.
abstract interface class ImportFileDelegate {
  /// Choose the file to use as data source
  /// for importing riders and their devices.
  ///
  /// Returns the chosen file or null if no file was chosen.
  /// Throws an [UnsupportedFileFormatException] if a file with an unsupported file type was chosen.
  Future<fs.File?> pickImportRidersDataSource();
}
