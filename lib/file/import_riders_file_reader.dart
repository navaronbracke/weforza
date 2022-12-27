import 'dart:io';

import 'package:weforza/model/rider/serializable_rider.dart';

/// This interface defines a file reader for importing a rider data source file.
abstract class ImportRidersFileReader<T> {
  /// Process the given [chunk].
  ///
  /// Valid chunks are added to the given [serializedRiders] collection.
  Future<void> processChunk(T chunk, List<SerializableRider> serializedRiders);

  /// Read the given file.
  /// Returns the file contents in readable chunks.
  ///
  /// Throws a [FormatException] if the file is malformed.
  Future<List<T>> readFile(File file);
}
