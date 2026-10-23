import 'package:file/file.dart' as fs;
import 'package:weforza/database/riders.dart';
import 'package:weforza/model/export/exportable_rider.dart';

/// This interface defines a file reader for importing a rider data source file.
abstract class ImportRidersFileReader<T> {
  /// The regular expression that validates the first name, last name and alias cells.
  static final RegExp _nameAndAliasRegex = Riders.nameAndAliasRegex;

  /// Process the given [chunk].
  ///
  /// Valid chunks are added to the given [exportedRiders] collection.
  Future<void> processChunk(T chunk, List<ExportableRider> exportedRiders);

  /// Read the given file.
  /// Returns the file contents in readable chunks.
  ///
  /// Throws a [FormatException] if the file is malformed.
  Future<List<T>> readFile(fs.File file);

  /// Whether the three name cells (first name, last name, alias) are valid.
  static bool nameIsValid({required String firstName, required String lastName, required String alias}) {
    return _nameAndAliasRegex.hasMatch(firstName) &&
        _nameAndAliasRegex.hasMatch(lastName) &&
        (alias.isEmpty || _nameAndAliasRegex.hasMatch(alias));
  }

  /// Parse the active status from the given [value].
  static bool parseActiveValue(Object? value) {
    return switch (value) {
      final String activeAsString => switch (activeAsString.toLowerCase()) {
        '0' || 'false' || '' => false,
        '1' || 'true' => true,
        _ => true,
      },
      final bool activeAsBool => activeAsBool,
      _ => true,
    };
  }
}
