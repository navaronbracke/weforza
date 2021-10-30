import 'package:file/file.dart';
import 'package:path/path.dart';
import 'package:path_provider/path_provider.dart';
import 'package:sembast/sembast.dart';
import 'package:weforza/cipher/cipher.dart';
import 'package:weforza/cipher/pass_through_cipher.dart';
import 'package:weforza/database/database_store_provider.dart';
import 'package:weforza/model/device.dart';
import 'package:weforza/model/member.dart';

/// This class handles database migrations.
class DatabaseMigration {
  DatabaseMigration({
    required this.encryptingCipher,
    required this.storeProvider,
  });

  /// The cipher that will handle encrypting records.
  final Cipher encryptingCipher;

  /// THe store provides that provides access to the database tables.
  final DatabaseStoreProvider storeProvider;

  //TODO remove when all testers migrated to new directory.
  /// Moves the database from the old Documents directory
  /// to the Application Support directory for the current platform.
  Future<void> moveDatabase(
    String newDatabasePath,
    FileSystem fileSystem,
    String databaseName,
  ) async {
    final oldDirectory = await getApplicationDocumentsDirectory();
    final oldDatabasePath = join(oldDirectory.path, databaseName);
    final file = fileSystem.file(oldDatabasePath);

    if (await file.exists()) {
      print("Found database on old location: $oldDatabasePath");
      print("Migrating database to new location: $newDatabasePath");

      try {
        print("Using migration strategy: RENAME FILE");

        await file.rename(newDatabasePath);
      } on FileSystemException {
        print("Migration using migration strategy: RENAME FILE failed.");
        print("Retrying with migration strategy: MOVE FILE");

        await file.copy(newDatabasePath);
        await file.delete();
      }

      print("Done migrating database.");
    }
  }

  //TODO remove when all testers have version 2 database.
  // Migrate the database to version 2 by encrypting the members and devices.
  Future<void> migrateDatabaseToUseEncryption(
    Database db,
    int oldVersion,
    int newVersion,
  ) async {
    // The database is a new one. There are no records to migrate.
    if (oldVersion < 1) {
      return;
    }

    // Only apply the migration when we go from v1 to v2.
    if (oldVersion == 1 && newVersion == 2) {
      final passThroughCipher = PassThroughCipher();

      await db.transaction((txn) async {
        final members =
            await storeProvider.memberStore.find(txn).then((records) {
          return records.map((record) {
            return Member.decrypt(record.key, record.value, passThroughCipher);
          });
        });

        await storeProvider.memberStore
            .records(members.map((m) => m.uuid))
            .update(
              txn,
              members.map((m) => m.encrypt(encryptingCipher)).toList(),
            );

        final devices =
            await storeProvider.deviceStore.find(txn).then((records) {
          return records.map((record) {
            return Device.decrypt(record.key, record.value, passThroughCipher);
          });
        });

        await storeProvider.deviceStore
            .records(devices.map((d) => d.creationDate.toIso8601String()))
            .update(
              txn,
              devices.map((d) => d.encrypt(encryptingCipher)).toList(),
            );
      });
    }

    // Later versions already have encryption.
  }
}
