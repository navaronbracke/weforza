import 'package:sembast/sembast_memory.dart';
import 'package:test/test.dart';
import 'package:weforza/cipher/pass_through_cipher.dart';
import 'package:weforza/database/database_migration.dart';
import 'package:weforza/database/database_store_provider.dart';
import 'package:weforza/database/deviceDao.dart';
import 'package:weforza/database/memberDao.dart';
import 'package:weforza/database/rideDao.dart';
import 'package:weforza/model/device.dart';
import 'package:weforza/model/member.dart';
import 'package:weforza/model/memberFilterOption.dart';
import 'package:weforza/model/ride.dart';

import 'test_cipher.dart';

void main(){
  test("DatabaseMigration to version 2 encrypts users and devices", () async {
    // This instance is used to get the store references.
    final storeProvider = DatabaseStoreProvider();
    // The non-encrypting cipher for inserting the initial database records.
    final passThroughCipher = PassThroughCipher();
    // The encrypting cipher that does actual work during the test.
    final encryptingCipher = TestCipher();
    final memoryDatabase = await databaseFactoryMemory.openDatabase(sembastInMemoryDatabasePath);

    final dbMigration = DatabaseMigration(
      encryptingCipher: encryptingCipher,
      storeProvider: storeProvider,
    );

    final initialDataMemberDao = MemberDao.withProvider(
      memoryDatabase,
      storeProvider,
      passThroughCipher,
    );

    final initialDataRideDao = RideDao.withProvider(
      memoryDatabase,
      storeProvider,
      passThroughCipher,
    );

    final initialDataDeviceDao = DeviceDao.withProvider(
      memoryDatabase,
      storeProvider,
      passThroughCipher,
    );

    final encryptingMemberDao = MemberDao.withProvider(
      memoryDatabase,
      storeProvider,
      encryptingCipher,
    );

    final encryptingRideDao = RideDao.withProvider(
      memoryDatabase,
      storeProvider,
      encryptingCipher,
    );

    final encryptingDeviceDao = DeviceDao.withProvider(
      memoryDatabase,
      storeProvider,
      encryptingCipher,
    );

    final today = DateTime.now();

    final ride = Ride(date: today, scannedAttendees: 0);

    final firstMember = Member(
      uuid: "1",
      firstname: "John",
      lastname: "Doe",
      alias: "JohnDoe",
      isActiveMember: true,
      profileImageFilePath: null,
      lastUpdated: today,
    );

    final secondMember = Member(
      uuid: "2",
      firstname: "Jane",
      lastname: "Doe",
      alias: "",
      isActiveMember: false,
      profileImageFilePath: "/foo/bar",
      lastUpdated: today,
    );

    final device = Device(
      ownerId: firstMember.uuid,
      name: "Test Device",
      creationDate: today,
    );

    // Setup the version 1 database, using unencrypted records.
    await initialDataMemberDao.addMember(firstMember);
    await initialDataMemberDao.addMember(secondMember);
    await initialDataRideDao.addRides([ride]);
    await initialDataDeviceDao.addDevice(device);

    // Migrate the database from version 1 to version 2.
    await dbMigration.migrateDatabaseToUseEncryption(memoryDatabase, 1, 2);

    // Now the database should have been migrated to version 2.
    // The records should have been encrypted.

    final encryptedMembers = await encryptingMemberDao.getMembers(MemberFilterOption.ALL);
    final encryptedRides = await encryptingRideDao.getRides();
    final encryptedDevices = await encryptingDeviceDao.getAllDevices();

    final encryptedFirstMember = encryptedMembers.firstWhere((member) => member.uuid == firstMember.uuid);
    final encryptedSecondMember = encryptedMembers.firstWhere((member) => member.uuid == secondMember.uuid);
    final encryptedRide = encryptedRides.firstWhere((ride) => ride.date == today);
    final encryptedDevice = encryptedDevices.firstWhere((device) => device.ownerId == firstMember.uuid);

    // We don't assert on the database version,
    // since we don't use the onChanged function for the test.
    // We only test the migration function itself.
    expect(encryptedRide, ride);
    expect(encryptedDevice, device);
    expect(firstMember, encryptedFirstMember);
    expect(secondMember, encryptedSecondMember);
  });
}