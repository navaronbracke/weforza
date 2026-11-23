import 'package:drift/drift.dart';
import 'package:file/file.dart';
import 'package:file/memory.dart';
import 'package:flutter_test/flutter_test.dart';
import 'package:weforza/database/database.dart';
import 'package:weforza/database/database_migrator.dart';

DatabaseMigrator createMigrator(WeForzaDatabase database, MemoryFileSystem fileSystem, Directory oldDatabaseDirectory) {
  return .test(database, fileSystem: fileSystem, getDatabaseDirectory: (fileSystem) async => oldDatabaseDirectory);
}

Future<void> expectDatabaseIsEmpty(WeForzaDatabase database) async {
  expect(await database.devices.count().getSingle(), 0);
  expect(await database.excludedTerms.count().getSingle(), 0);
  expect(await database.rideAttendees.count().getSingle(), 0);
  expect(await database.riders.count().getSingle(), 0);
  expect(await database.rides.count().getSingle(), 0);
}

Future<void> writeLinesToOldDatabaseFile(Iterable<String> lines, File file) async {
  await file.create(recursive: true);
  await file.writeAsString(lines.join('\n'));
}
