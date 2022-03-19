import 'package:file/local.dart';
import 'package:flutter/widgets.dart';
import 'package:flutter_riverpod/flutter_riverpod.dart';
import 'package:sembast/sembast_io.dart';
import 'package:weforza/database/database.dart';
import 'package:weforza/database/database_factory.dart';
import 'package:weforza/database/database_tables.dart';
import 'package:weforza/database/settings_dao.dart';
import 'package:weforza/repository/settings_repository.dart';
import 'package:weforza/riverpod/database/database_dao_provider.dart';
import 'package:weforza/riverpod/database/database_provider.dart';
import 'package:weforza/riverpod/repository/settings_repository_provider.dart';
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

  final databaseTables = DatabaseTables();

  final settingsDao = SettingsDao(
    database.getDatabase(),
    databaseTables.settings,
    databaseTables.ride,
  );

  final settingsRepository = SettingsRepository(settingsDao);

  runApp(
    ProviderScope(
      overrides: [
        // Inject the database after it is ready.
        databaseProvider.overrideWithValue(database),
        databaseTableProvider.overrideWithValue(databaseTables),
        // Inject the preloaded settings.
        settingsProvider.overrideWithValue(
          SettingsNotifier(
            currentSettings: await settingsRepository.loadApplicationSettings(),
            settingsRepository: settingsRepository,
          ),
        ),
        // Inject the preloaded settings repository.
        settingsRepositoryProvider.overrideWithValue(settingsRepository),
        // Inject the preloaded settings dao.
        settingsDaoProvider.overrideWithValue(settingsDao),
      ],
      child: const WeForzaApp(),
    ),
  );
}
