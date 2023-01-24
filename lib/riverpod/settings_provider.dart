import 'package:flutter_riverpod/flutter_riverpod.dart';
import 'package:weforza/model/settings/settings.dart';
import 'package:weforza/repository/settings_repository.dart';

/// This provider provides the application settings.
///
/// This provider is overridden at startup with the preloaded settings.
final settingsProvider = StateNotifierProvider<SettingsNotifier, Settings>(
  (ref) {
    throw UnsupportedError('The settings should be preloaded at startup.');
  },
);

/// The notifier that manages the settings.
class SettingsNotifier extends StateNotifier<Settings> {
  SettingsNotifier(
    super.initialValue,
    this._settingsRepository,
  );

  /// The repository that manages the settings.
  final SettingsRepository _settingsRepository;
}
