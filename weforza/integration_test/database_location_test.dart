import 'dart:io';

import 'package:integration_test/integration_test.dart';
import 'package:flutter_test/flutter_test.dart';
import 'package:path/path.dart' as path;
import 'package:path_provider/path_provider.dart';
import 'package:sembast/sembast_io.dart';
import 'package:weforza/database/database.dart';
import 'package:weforza/database/memberDao.dart';
import 'package:weforza/model/member.dart';
import 'package:weforza/model/memberFilterOption.dart';

void main(){
  IntegrationTestWidgetsFlutterBinding.ensureInitialized();

  /// Integration/regression test for the database location.
  /// Older versions of the app used to store the database
  /// in the Documents folder. Newer versions correctly store the database
  /// in the application support directory.
  /*
  Run this test:
  flutter drive --driver=test_driver/integration_test.dart --target=integration_test/database_location_test.dart
  */
  testWidgets("Database in documents directory is moved to application support directory", (WidgetTester tester) async {
    final testDbName = "test_database.db";
    final Member testRecord = Member(
      uuid: "1",
      firstname: "John",
      lastname: "Doe",
      alias: "Test",
      isActiveMember: true,
      profileImageFilePath: null,
      lastUpdated: DateTime.now(),
    );

    /*
    * Arrange:
    * Create a new empty db in the old location.
    * Then insert a test record.
    * */
    final db = ApplicationDatabase(databaseName: testDbName);

    final oldDirectory = await getApplicationDocumentsDirectory();
    final oldDatabasePath = path.join(oldDirectory.path, testDbName);

    IMemberDao dao = MemberDao(
      await databaseFactoryIo.openDatabase(oldDatabasePath),
      db.memberStore,
      db.rideAttendeeStore,
      db.deviceStore,
    );
    await dao.addMember(testRecord);

    // Act: Create the 'new' database.
    await db.createDatabase();

    final newDirectory = await getApplicationSupportDirectory();
    final newDatabasePath = path.join(newDirectory.path, testDbName);

    final newDatabase = await databaseFactoryIo.openDatabase(newDatabasePath);
    final newDatabaseVersion = newDatabase.version;
    // Get a new DAO for the new database.
    dao = MemberDao(
      newDatabase,
      db.memberStore,
      db.rideAttendeeStore,
      db.deviceStore,
    );

    final records = await dao.getMembers(MemberFilterOption.ALL);
    final oldDbFile = File(oldDatabasePath);
    final newDbFile = File(newDatabasePath);
    /*
    * Assert:
    * Has the database moved to the new directory?
    * Is the version unchanged?
    * Is the data unchanged?
    * */
    expect(await oldDbFile.exists(), false);
    expect(await newDbFile.exists(), true);
    expect(records.first, testRecord);
    expect(newDatabaseVersion, 1);

    // Clean up.
    try {
      await oldDbFile.delete();
    }catch (_){}
    try {
      await newDbFile.delete();
    }catch (_){}
  });
}