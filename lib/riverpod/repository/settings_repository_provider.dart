import 'package:flutter_riverpod/flutter_riverpod.dart';
import 'package:weforza/repository/settings_repository.dart';
import 'package:weforza/riverpod/database/database_dao_provider.dart';

/// This provider provides the [SettingsRepository].
final settingsRepositoryProvider = Provider<SettingsRepository>((ref) {
  return SettingsRepository(
    ref.read(rideDaoProvider),
    ref.read(settingsDaoProvider),
  );
});
