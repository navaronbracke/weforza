/// @docImport 'package:weforza/model/settings/settings.dart';
library;

import 'package:flutter_riverpod/flutter_riverpod.dart';
import 'package:weforza/model/rider/rider_filter_option.dart';
import 'package:weforza/riverpod/settings/settings_provider.dart';

/// A [FutureProvider] that provides the [Settings.riderListFilter].
final settingsRiderListFilterProvider = FutureProvider<RiderFilterOption>((ref) async {
  final settings = await ref.watch(settingsProvider.future);

  return settings.riderListFilter;
});
