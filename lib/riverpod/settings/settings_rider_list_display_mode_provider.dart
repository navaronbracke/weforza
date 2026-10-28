/// @docImport 'package:weforza/model/settings/user_preferences.dart';
library;

import 'package:flutter_riverpod/flutter_riverpod.dart';
import 'package:weforza/model/rider/rider_list_display_mode.dart';
import 'package:weforza/riverpod/settings/settings_provider.dart';

/// A [FutureProvider] that provides the [UserPreferences.riderListDisplayMode].
final settingsRiderListDisplayModeProvider = FutureProvider<RiderListDisplayMode>((ref) async {
  final settings = await ref.watch(settingsProvider.future);

  return settings.userPreferences.riderListDisplayMode;
});
