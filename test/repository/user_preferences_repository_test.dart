import 'package:flutter_test/flutter_test.dart';
import 'package:shared_preferences_platform_interface/in_memory_shared_preferences_async.dart';
import 'package:shared_preferences_platform_interface/shared_preferences_async_platform_interface.dart';
import 'package:weforza/model/rider/rider_list_display_mode.dart';
import 'package:weforza/model/settings/user_preferences.dart';
import 'package:weforza/repository/user_preferences_repository.dart';

void main() {
  UserPreferencesRepository createRepository([Map<String, Object> initialData = const {}]) {
    // SharedPreferences caches the underlying instance via its constructor.
    SharedPreferencesAsyncPlatform.instance = InMemorySharedPreferencesAsync.withData(initialData);
    return UserPreferencesRepository();
  }

  test('UserPreferences default values are correct', () {
    expect(UserPreferences.defaultPreferences.riderListDisplayMode, RiderListDisplayMode.all);
    expect(UserPreferences.defaultPreferences.scanDuration, 20);
    expect(UserPreferences.minScanDuration, 10);
    expect(UserPreferences.maxScanDuration, 60);
  });

  group('read', () {
    test('returns default preferences if none are set', () async {
      expect(await createRepository().read(), UserPreferences.defaultPreferences);
    });

    test('reads rider list display mode if set in preferences', () async {
      final repository = createRepository({
        UserPreferencesRepository.riderListDisplayModeKey: RiderListDisplayMode.active.value,
      });

      final preferences = await repository.read();

      expect(preferences.riderListDisplayMode, RiderListDisplayMode.active);
    });

    test('reads scan duration if set in preferences', () async {
      final preferences = await createRepository({UserPreferencesRepository.scanDurationKey: 50}).read();

      expect(preferences.scanDuration, 50);
    });

    test('reads all preferences if set', () async {
      final repository = createRepository({
        UserPreferencesRepository.riderListDisplayModeKey: RiderListDisplayMode.active.value,
        UserPreferencesRepository.scanDurationKey: 50,
      });

      final preferences = await repository.read();

      expect(preferences.riderListDisplayMode, RiderListDisplayMode.active);
      expect(preferences.scanDuration, 50);
    });

    test('does not crash on invalid values for rider list display mode', () async {
      final values = [
        'invalid',
        3,
        3.14,
        double.nan,
        double.infinity,
        double.negativeInfinity,
        true,
        [],
        {},
        <int, int>{},
      ];

      for (final value in values) {
        final preferences = await createRepository({UserPreferencesRepository.riderListDisplayModeKey: value}).read();

        expect(preferences.riderListDisplayMode, RiderListDisplayMode.all);
      }
    });

    test('does not crash on invalid values for scan duration', () async {
      final values = [
        'invalid',
        3.14,
        double.nan,
        double.infinity,
        double.negativeInfinity,
        true,
        [],
        {},
        <int, int>{},
      ];

      for (final value in values) {
        final preferences = await createRepository({UserPreferencesRepository.scanDurationKey: value}).read();

        expect(preferences.scanDuration, UserPreferences.defaultPreferences.scanDuration);
      }
    });
  });

  group('write', () {
    test('writes rider list display mode', () async {
      final repository = createRepository();

      await repository.write(UserPreferences.defaultPreferences.copyWith(riderListDisplayMode: .active));

      final preferences = await repository.read();

      expect(preferences.riderListDisplayMode, RiderListDisplayMode.active);
    });

    test('writes scan duration', () async {
      final repository = createRepository();

      await repository.write(UserPreferences.defaultPreferences.copyWith(scanDuration: 50));

      final preferences = await repository.read();

      expect(preferences.scanDuration, 50);
    });

    test('writes all preferences', () async {
      final repository = createRepository();

      await repository.write(
        UserPreferences.defaultPreferences.copyWith(riderListDisplayMode: .active, scanDuration: 50),
      );

      final preferences = await repository.read();

      expect(preferences.riderListDisplayMode, RiderListDisplayMode.active);
      expect(preferences.scanDuration, 50);
    });

    test('clamps scan duration setting between min and max on write', () async {
      final repository = createRepository();

      final List<({int actual, double expected})> values = [
        (actual: -1, expected: UserPreferences.minScanDuration),
        (actual: 0, expected: UserPreferences.minScanDuration),
        (actual: 1, expected: UserPreferences.minScanDuration),
        (actual: 9, expected: UserPreferences.minScanDuration),
        (actual: 10, expected: UserPreferences.minScanDuration),
        (actual: 12, expected: 12),
        (actual: 59, expected: 59),
        (actual: 60, expected: UserPreferences.maxScanDuration),
        (actual: 61, expected: UserPreferences.maxScanDuration),
      ];

      for (final value in values) {
        await repository.write(UserPreferences.defaultPreferences.copyWith(scanDuration: value.actual));

        final preferences = await repository.read();

        expect(preferences.scanDuration, value.expected);
      }
    });
  });
}
