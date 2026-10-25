/// @docImport 'package:weforza/model/settings/settings.dart';
library;

import 'package:flutter_riverpod/flutter_riverpod.dart';
import 'package:weforza/riverpod/settings/settings_provider.dart';

/// A [FutureProvider] that provides the [Settings.scanDuration].
final settingsScanDurationProvider = FutureProvider<int>((ref) async {
  final settings = await ref.watch(settingsProvider.future);

  return settings.scanDuration;
});
