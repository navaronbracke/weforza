import 'package:collection/collection.dart';
import 'package:weforza/database/database.dart';
import 'package:weforza/model/settings/user_preferences.dart';

/// This class defines the persistent application settings.
class Settings {
  const new({this.excludedTermsFilter = const <ExcludedTerm>{}, this.userPreferences = .defaultPreferences});

  /// The set of excluded terms that are ignored during a device scan.
  final Set<ExcludedTerm> excludedTermsFilter;

  /// The user's preferences for the application, for the simple settings.
  ///
  /// The [excludedTermsFilter] can be potentially large, so that is not stored in the user defaults.
  final UserPreferences userPreferences;

  /// Create a copy of this object, replacing any non-null values.
  Settings copyWith({Set<ExcludedTerm>? excludedTermsFilter, UserPreferences? userPreferences}) {
    return Settings(
      excludedTermsFilter: excludedTermsFilter ?? this.excludedTermsFilter,
      userPreferences: userPreferences ?? this.userPreferences,
    );
  }

  @override
  int get hashCode => Object.hash(userPreferences, Object.hashAll(excludedTermsFilter));

  @override
  bool operator ==(Object other) {
    return other is Settings &&
        userPreferences == other.userPreferences &&
        const SetEquality<ExcludedTerm>().equals(excludedTermsFilter, other.excludedTermsFilter);
  }
}
