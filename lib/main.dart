import 'dart:io' show Directory, Platform;

import 'package:file/local.dart';
import 'package:flutter/widgets.dart';
import 'package:flutter_riverpod/flutter_riverpod.dart';
import 'package:package_info_plus/package_info_plus.dart';
import 'package:path_provider/path_provider.dart';
import 'package:weforza/database/database.dart';
import 'package:weforza/database/sembast_database.dart';
import 'package:weforza/file/file_system.dart';
import 'package:weforza/file/io_file_system.dart';
import 'package:weforza/native_service/io_file_storage_delegate.dart';
import 'package:weforza/riverpod/database/database_provider.dart';
import 'package:weforza/riverpod/file/file_system_provider.dart';
import 'package:weforza/riverpod/package_info_provider.dart';
import 'package:weforza/riverpod/settings_provider.dart';
import 'package:weforza/widgets/app.dart';

void main() async {
  WidgetsFlutterBinding.ensureInitialized();

  // Setup the database at startup.
  final Database database = SembastDatabase();
  await database.open();

  // Preload the settings.
  final settings = await database.settingsDao.read();

  // Preload the package info.
  final packageInfo = await PackageInfo.fromPlatform();

  // The delegate that looks up whether the storage is scoped is a constant.
  // Therefor the delegate here and in the respective provider, evaluates to the same object.
  final bool hasAndroidScopedStorage = await const IoFileStorageDelegate().hasScopedStorage();

  final Directory applicationDocumentsDirectory = await getApplicationDocumentsDirectory();
  final Directory tempDirectory = await getTemporaryDirectory();

  // Android only has top level directories when Scoped Storage is not being used,
  // while iOS does not have accessible top level directories.
  Directory? topLevelDocumentsDir;
  Directory? topLevelImagesDir;

  if (Platform.isAndroid && !hasAndroidScopedStorage) {
    final List<Directory> documentsDirs = await getExternalStorageDirectories(type: StorageDirectory.documents) ?? [];
    final List<Directory> imagesDirs = await getExternalStorageDirectories(type: StorageDirectory.pictures) ?? [];

    topLevelDocumentsDir = documentsDirs.firstOrNull;
    topLevelImagesDir = imagesDirs.firstOrNull;
  }

  final FileSystem fileSystem = IoFileSystem(
    documentsDirectory: applicationDocumentsDirectory,
    fileSystem: const LocalFileSystem(),
    hasScopedStorage: hasAndroidScopedStorage,
    imagesDirectory: applicationDocumentsDirectory,
    tempDirectory: tempDirectory,
    topLevelDocumentsDirectory: topLevelDocumentsDir,
    topLevelImagesDirectory: topLevelImagesDir,
  );

  runApp(
    ProviderScope(
      overrides: [
        // Inject the database after it is ready.
        databaseProvider.overrideWith((ref) {
          // Ensure the database is closed when the provider container is closed.
          ref.onDispose(database.dispose);

          return database;
        }),
        // Inject the preloaded package info.
        packageInfoProvider.overrideWithValue(packageInfo),
        // Inject the preloaded settings.
        initialSettingsProvider.overrideWithValue(settings),
        // Inject the file system.
        fileSystemProvider.overrideWithValue(fileSystem),
      ],
      child: const WeForzaApp(),
    ),
  );
}
