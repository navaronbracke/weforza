import 'package:flutter_riverpod/flutter_riverpod.dart';
import 'package:weforza/database/database.dart';
import 'package:weforza/model/rider/rider_filter_option.dart';
import 'package:weforza/riverpod/repository/rider_repository_provider.dart';
import 'package:weforza/riverpod/settings/settings_provider.dart';

/// This provider provides the list of riders.
final riderListProvider = FutureProvider<List<Rider>>((ref) async {
  final repository = ref.watch(riderRepositoryProvider);

  final filter = await ref.watch(_riderListFilterProvider.future);

  return repository.getRiders(filter);
});

/// A private [FutureProvider] that provides the rider list filter option from the settings.
///
/// This provider is needed since [AsyncNotifier] does not allow selects on the `.future` getter.
final _riderListFilterProvider = FutureProvider<RiderFilterOption>((ref) async {
  final settings = await ref.watch(settingsProvider.future);

  return settings.riderListFilter;
});
