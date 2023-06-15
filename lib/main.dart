import 'dart:io';

import 'package:flutter/widgets.dart';
import 'package:flutter_riverpod/flutter_riverpod.dart';
import 'package:package_info_plus/package_info_plus.dart';
import 'package:path_provider/path_provider.dart';
import 'package:weforza/database/database.dart';
import 'package:weforza/database/sembast_database.dart';
import 'package:weforza/riverpod/database/database_provider.dart';
import 'package:weforza/riverpod/file_handler_provider.dart';
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

  Directory? defaultExportDirectory;

  // On iOS, the Documents directory within the application
  // is a good default for the export directory.
  if (Platform.isIOS) {
    defaultExportDirectory = await getApplicationDocumentsDirectory();
  }

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
        // Inject the default directory for file exports.
        exportDataDefaultDirectoryProvider.overrideWithValue(
          defaultExportDirectory,
        ),
      ],
      child: const WeForzaApp(),
    ),
  );
}
