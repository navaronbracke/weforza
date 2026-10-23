import 'package:file/file.dart' as fs;
import 'package:weforza/model/export/exportable_rider.dart';

/// This interface defines a file reader for importing a rider data source file.
abstract class ImportRidersFileReader<T> {
  /// Process the given [chunk].
  ///
  /// Valid chunks are added to the given [exportedRiders] collection.
  Future<void> processChunk(T chunk, List<ExportableRider> exportedRiders);

  /// Read the given file.
  /// Returns the file contents in readable chunks.
  ///
  /// Throws a [FormatException] if the file is malformed.
  Future<List<T>> readFile(fs.File file);
}
