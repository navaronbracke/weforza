import 'dart:io';

import 'package:weforza/model/exportable_member.dart';

/// This class defines an interface
/// for reading a file that acts as members import datasource.
abstract class ImportMembersFileReader<T> {
  /// Read the given file.
  /// Returns the file contents in readable chunks.
  Future<List<T>> readFile(File file);

  /// Process the given [data] element.
  ///
  /// The given [collection] is used to collect valid exportable members.
  Future<void> processData(T data, List<ExportableMember> collection);
}
