/// @docImport 'package:weforza/database/database.dart';
library;

import 'package:weforza/model/settings/settings.dart';

/// This class represents the interface for working with the application [Settings] from the [Database].
abstract interface class SettingsDao {
  /// Read the current application settings.
  Future<Settings> read();

  /// Write the new [settings].
  Future<void> write(Settings settings);
}
