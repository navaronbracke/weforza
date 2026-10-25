import 'package:flutter_riverpod/flutter_riverpod.dart';
import 'package:weforza/model/rider/rider_filter_option.dart';
import 'package:weforza/riverpod/settings/settings_provider.dart';

final riderListFilterProvider = Provider<AsyncValue<RiderFilterOption>>((ref) {
  return ref.watch(settingsProvider.select((settings) => settings.whenData((value) => value.riderListFilter)));
});
