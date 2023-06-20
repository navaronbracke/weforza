import 'package:file/local.dart';
import 'package:flutter/widgets.dart';
import 'package:flutter_riverpod/flutter_riverpod.dart';
import 'package:package_info_plus/package_info_plus.dart';
import 'package:weforza/database/database.dart';
import 'package:weforza/database/sembast_database.dart';
import 'package:weforza/file/file_system.dart';
import 'package:weforza/file/io_file_system.dart';
import 'package:weforza/native_service/file_provider.dart';
import 'package:weforza/riverpod/database/database_provider.dart';
import 'package:weforza/riverpod/file_system_provider.dart';
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

  final bool hasAndroidScopedStorage = await const FileProvider().hasScopedStorage();

  final FileSystem fileSystem = await IoFileSystem.fromPlatform(
    fileSystem: const LocalFileSystem(),
    hasAndroidScopedStorage: hasAndroidScopedStorage,
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
