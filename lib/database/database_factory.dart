import 'package:file/file.dart';
import 'package:sembast/sembast.dart';

class ApplicationDatabaseFactory {
  ApplicationDatabaseFactory({
    required this.fileSystem,
    required this.factory,
  });

  final FileSystem fileSystem;
  final DatabaseFactory factory;
}
