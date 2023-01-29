import 'package:flutter_riverpod/flutter_riverpod.dart';

import 'package:weforza/model/rider/rider.dart';
import 'package:weforza/riverpod/repository/rider_repository_provider.dart';
import 'package:weforza/riverpod/settings_provider.dart';

/// This provider provides the list of riders.
final riderListProvider = FutureProvider<List<Rider>>((ref) {
  final repository = ref.read(riderRepositoryProvider);

  // Watch the rider list filter for changes.
  final filter = ref.watch(
    settingsProvider.select((settings) => settings.memberListFilter),
  );

  return repository.getRiders(filter);
});
