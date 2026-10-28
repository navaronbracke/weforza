import 'package:weforza/database/database.dart';
import 'package:weforza/model/settings/settings.dart';
import 'package:weforza/model/settings/user_preferences.dart';
import 'package:weforza/repository/excluded_terms_repository.dart';
import 'package:weforza/repository/user_preferences_repository.dart';

class SettingsRepository {
  new(this._excludedTermsRepository);

  final ExcludedTermsRepository _excludedTermsRepository;

  static final UserPreferencesRepository _userPreferencesRepository = UserPreferencesRepository();

  /// Read the current application settings.
  Future<Settings> read() async {
    final (UserPreferences userPreferences, Set<ExcludedTerm> excludedTerms) = await (
      _userPreferencesRepository.read(),
      _excludedTermsRepository.read(),
    ).wait;

    return Settings(userPreferences: userPreferences, excludedTermsFilter: {...excludedTerms});
  }

  /// Write the new [settings].
  Future<void> write(Settings settings) {
    return Future.wait<void>([
      _excludedTermsRepository.write(settings.excludedTermsFilter),
      _userPreferencesRepository.write(settings.userPreferences),
    ]);
  }
}
