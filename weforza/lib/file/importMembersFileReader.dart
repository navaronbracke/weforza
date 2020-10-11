
import 'dart:io';

import 'package:weforza/model/exportableMember.dart';

///This interface provides a contract for reading importable member data files.
abstract class ImportMembersFileReader<T> {
  /// Read the given file.
  /// Returns the data that was read, on a per object basis.
  Future<List<T>> readFile(File file);

  /// Process the given data and add it to the [ExportableMember] collection, if its valid.
  Future<void> processData(T data, List<ExportableMember> collection);
}