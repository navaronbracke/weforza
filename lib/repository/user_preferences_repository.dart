import 'package:flutter/foundation.dart' show visibleForTesting;
import 'package:shared_preferences/shared_preferences.dart';
import 'package:weforza/model/settings/user_preferences.dart';

class UserPreferencesRepository {
  /// The Shared Preferences instance that manages the primitive value settings,
  /// such as the scan duration and the rider list display mode.
  final SharedPreferencesAsync _preferences = SharedPreferencesAsync();

  /// The key for the rider list display mode in shared preferences.
  @visibleForTesting
  static const String riderListDisplayModeKey = 'riderListDisplayMode';

  /// The key for the scan duration in shared preferences.
  @visibleForTesting
  static const String scanDurationKey = 'scanDuration';

  /// Read the user preferences from shared preferences.
  Future<UserPreferences> read() async {
    final (int? scanDuration, int? riderListDisplayMode) = await (
      _preferences.getInt(scanDurationKey),
      _preferences.getInt(riderListDisplayModeKey),
    ).wait;

    return .fromValues(riderListDisplayMode: .fromInt(riderListDisplayMode), scanDuration: scanDuration);
  }

  /// Write the given user preferences to shared preferences.
  Future<void> write(UserPreferences value) => Future.wait<void>([
    _preferences.setInt(riderListDisplayModeKey, value.riderListDisplayMode.value),
    _preferences.setInt(scanDurationKey, value.scanDuration),
  ]);
}
