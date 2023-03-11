import 'dart:io';

import 'package:file/local.dart';
import 'package:flutter/widgets.dart';
import 'package:flutter_riverpod/flutter_riverpod.dart';
import 'package:package_info_plus/package_info_plus.dart';
import 'package:path_provider/path_provider.dart';
import 'package:sembast/sembast_io.dart';
import 'package:weforza/database/database.dart';
import 'package:weforza/database/database_factory.dart';
import 'package:weforza/database/settings_dao.dart';
import 'package:weforza/repository/settings_repository.dart';
import 'package:weforza/riverpod/database/database_provider.dart';
import 'package:weforza/riverpod/file_handler_provider.dart';
import 'package:weforza/riverpod/package_info_provider.dart';
import 'package:weforza/riverpod/settings_provider.dart';
import 'package:weforza/widgets/app.dart';

void main() async {
  WidgetsFlutterBinding.ensureInitialized();

  // Setup the database at startup.
  final database = ApplicationDatabase();
  await database.openDatabase(
    ApplicationDatabaseFactory(
      factory: databaseFactoryIo,
      fileSystem: const LocalFileSystem(),
    ),
  );

  // Preload the settings.
  final settingsRepository = SettingsRepository(
    SettingsDaoImpl(database.getDatabase()),
  );
  final settings = await settingsRepository.read();

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
        databaseProvider.overrideWithValue(database),
        // Inject the preloaded package info.
        packageInfoProvider.overrideWithValue(packageInfo),
        // Inject the preloaded settings.
        settingsProvider.overrideWith(
          (ref) => SettingsNotifier(settings, settingsRepository),
        ),
        // Inject the default directory for file exports.
        exportDataDefaultDirectoryProvider.overrideWithValue(
          defaultExportDirectory,
        ),
      ],
      child: const WeForzaApp(),
    ),
  );
}
