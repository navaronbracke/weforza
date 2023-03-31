import 'package:file/file.dart';
import 'package:sembast/sembast.dart';

class ApplicationDatabaseFactory {
  ApplicationDatabaseFactory({required this.factory, required this.fileSystem});

  final DatabaseFactory factory;

  final FileSystem fileSystem;
}
