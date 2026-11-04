import 'package:flutter/foundation.dart' show visibleForTesting;
import 'package:shared_preferences/shared_preferences.dart';
import 'package:weforza/model/settings/user_preferences.dart';

class UserPreferencesRepository {
  /// The key for the rider list display mode in shared preferences.
  @visibleForTesting
  static const String riderListDisplayModeKey = 'riderListDisplayMode';

  /// The key for the scan duration in shared preferences.
  @visibleForTesting
  static const String scanDurationKey = 'scanDuration';

  /// Read the user preferences from shared preferences.
  Future<UserPreferences> read() async {
    final SharedPreferencesAsync preferences = SharedPreferencesAsync();

    // Shared preferences may throw errors when reading invalid values.
    final (int? scanDuration, int? riderListDisplayMode) = await (
      preferences.getInt(scanDurationKey).catchError((_) => null),
      preferences.getInt(riderListDisplayModeKey).catchError((_) => null),
    ).wait;

    return .fromValues(riderListDisplayMode: .fromInt(riderListDisplayMode), scanDuration: scanDuration);
  }

  /// Write the given user preferences to shared preferences.
  Future<void> write(UserPreferences value) {
    final SharedPreferencesAsync preferences = SharedPreferencesAsync();

    return Future.wait<void>([
      preferences.setInt(riderListDisplayModeKey, value.riderListDisplayMode.value),
      preferences.setInt(scanDurationKey, value.scanDuration),
    ]);
  }
}
