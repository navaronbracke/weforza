import 'package:flutter_test/flutter_test.dart';
import 'package:shared_preferences/shared_preferences.dart';
import 'package:shared_preferences_platform_interface/in_memory_shared_preferences_async.dart';
import 'package:shared_preferences_platform_interface/shared_preferences_async_platform_interface.dart';
import 'package:weforza/database/database.dart';
import 'package:weforza/model/rider/rider_list_display_mode.dart';
import 'package:weforza/model/settings/settings.dart';
import 'package:weforza/model/settings/user_preferences.dart';
import 'package:weforza/repository/excluded_terms_repository.dart';
import 'package:weforza/repository/settings_repository.dart';
import 'package:weforza/repository/user_preferences_repository.dart';

void main() {
  late WeForzaDatabase database;
  late ExcludedTermsRepository excludedTermsRepository;

  SettingsRepository createRepository([Map<String, Object> initialData = const {}]) {
    // SharedPreferences caches the underlying instance via its constructor.
    SharedPreferencesAsyncPlatform.instance = InMemorySharedPreferencesAsync.withData(initialData);
    return SettingsRepository(excludedTermsRepository);
  }

  setUp(() {
    database = WeForzaDatabase.memory();
    excludedTermsRepository = ExcludedTermsRepository(database);
  });

  tearDown(() => database.close());

  group('read', () {
    test('returns default settings if nothing is set', () async {
      expect(await createRepository().read(), const Settings());
    });

    test('reads partial settings with only excluded terms', () async {
      await excludedTermsRepository.write({const ExcludedTerm(term: 'term1')});

      final settings = await createRepository().read();

      expect(settings.excludedTermsFilter, {const ExcludedTerm(term: 'term1')});
      expect(settings.userPreferences, UserPreferences.defaultPreferences);
    });

    test('reads partial settings with only user preferences', () async {
      final repository = createRepository({
        UserPreferencesRepository.riderListDisplayModeKey: RiderListDisplayMode.active.value,
        UserPreferencesRepository.scanDurationKey: 50,
      });

      final settings = await repository.read();

      expect(settings.excludedTermsFilter, isEmpty);
      expect(settings.userPreferences.riderListDisplayMode, RiderListDisplayMode.active);
      expect(settings.userPreferences.scanDuration, 50);
    });

    test('reads full settings', () async {
      await excludedTermsRepository.write({const ExcludedTerm(term: 'term1'), const ExcludedTerm(term: 'term2')});

      final repository = createRepository({
        UserPreferencesRepository.riderListDisplayModeKey: RiderListDisplayMode.active.value,
        UserPreferencesRepository.scanDurationKey: 50,
      });

      final settings = await repository.read();

      expect(settings.excludedTermsFilter, {const ExcludedTerm(term: 'term1'), const ExcludedTerm(term: 'term2')});
      expect(settings.userPreferences.riderListDisplayMode, RiderListDisplayMode.active);
      expect(settings.userPreferences.scanDuration, 50);
    });
  });

  group('write', () {
    test('writes default settings', () async {
      await createRepository().write(const Settings());

      final sharedPreferences = SharedPreferencesAsync();

      expect(
        await sharedPreferences.getInt(UserPreferencesRepository.riderListDisplayModeKey),
        RiderListDisplayMode.all.value,
      );
      expect(await sharedPreferences.getInt(UserPreferencesRepository.scanDurationKey), 20);
      expect(await excludedTermsRepository.read(), isEmpty);
    });

    test('writes partial settings with only excluded terms', () async {
      await createRepository().write(Settings(excludedTermsFilter: {const ExcludedTerm(term: 'term1')}));

      final sharedPreferences = SharedPreferencesAsync();

      expect(
        await sharedPreferences.getInt(UserPreferencesRepository.riderListDisplayModeKey),
        RiderListDisplayMode.all.value,
      );
      expect(await sharedPreferences.getInt(UserPreferencesRepository.scanDurationKey), 20);
      expect(await excludedTermsRepository.read(), {const ExcludedTerm(term: 'term1')});
    });

    test('writes partial settings with only user preferences', () async {
      await createRepository().write(
        Settings(userPreferences: .fromValues(riderListDisplayMode: .inactive, scanDuration: 30)),
      );

      final sharedPreferences = SharedPreferencesAsync();
      expect(
        await sharedPreferences.getInt(UserPreferencesRepository.riderListDisplayModeKey),
        RiderListDisplayMode.inactive.value,
      );
      expect(await sharedPreferences.getInt(UserPreferencesRepository.scanDurationKey), 30);
      expect(await excludedTermsRepository.read(), isEmpty);
    });

    test('writes full settings to the database and shared preferences', () async {
      await createRepository().write(
        Settings(
          excludedTermsFilter: {
            const ExcludedTerm(term: 'term1'),
            const ExcludedTerm(term: 'term2'),
          },
          userPreferences: .fromValues(riderListDisplayMode: .active, scanDuration: 50),
        ),
      );

      final sharedPreferences = SharedPreferencesAsync();
      expect(
        await sharedPreferences.getInt(UserPreferencesRepository.riderListDisplayModeKey),
        RiderListDisplayMode.active.value,
      );
      expect(await sharedPreferences.getInt(UserPreferencesRepository.scanDurationKey), 50);

      final storedTerms = await excludedTermsRepository.read();
      expect(storedTerms.toSet(), {const ExcludedTerm(term: 'term1'), const ExcludedTerm(term: 'term2')});
    });

    test('can overwrite existing terms settings', () async {
      await excludedTermsRepository.write({const ExcludedTerm(term: 'term1')});

      await createRepository().write(Settings(excludedTermsFilter: {const ExcludedTerm(term: 'term2')}));

      expect(await excludedTermsRepository.read(), {const ExcludedTerm(term: 'term2')});
    });

    test('can overwrite existing user preferences', () async {
      await createRepository({
        UserPreferencesRepository.riderListDisplayModeKey: RiderListDisplayMode.active.value,
        UserPreferencesRepository.scanDurationKey: 50,
      }).write(Settings(userPreferences: .fromValues(riderListDisplayMode: .inactive, scanDuration: 30)));

      final sharedPreferences = SharedPreferencesAsync();

      expect(
        await sharedPreferences.getInt(UserPreferencesRepository.riderListDisplayModeKey),
        RiderListDisplayMode.inactive.value,
      );
      expect(await sharedPreferences.getInt(UserPreferencesRepository.scanDurationKey), 30);
    });

    test('can overwrite existing settings', () async {
      await excludedTermsRepository.write({const ExcludedTerm(term: 'term1')});

      await createRepository({
        UserPreferencesRepository.riderListDisplayModeKey: RiderListDisplayMode.active.value,
        UserPreferencesRepository.scanDurationKey: 50,
      }).write(
        Settings(
          excludedTermsFilter: {const ExcludedTerm(term: 'term2')},
          userPreferences: .fromValues(riderListDisplayMode: .inactive, scanDuration: 30),
        ),
      );

      final sharedPreferences = SharedPreferencesAsync();

      final storedTerms = await excludedTermsRepository.read();

      expect(storedTerms.toSet(), {const ExcludedTerm(term: 'term2')});
      expect(
        await sharedPreferences.getInt(UserPreferencesRepository.riderListDisplayModeKey),
        RiderListDisplayMode.inactive.value,
      );
      expect(await sharedPreferences.getInt(UserPreferencesRepository.scanDurationKey), 30);
    });
  });
}
