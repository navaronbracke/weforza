/// @docImport 'package:weforza/model/settings/settings.dart';
library;

import 'package:flutter_riverpod/flutter_riverpod.dart';
import 'package:weforza/database/database.dart';
import 'package:weforza/riverpod/repository/rider_repository_provider.dart';
import 'package:weforza/riverpod/settings/settings_rider_list_filter_provider.dart';

/// This provider provides the list of riders.
final riderListProvider = FutureProvider<List<Rider>>((ref) async {
  final repository = ref.watch(riderRepositoryProvider);

  final filter = await ref.watch(settingsRiderListFilterProvider.future);

  return repository.getRiders(filter);
});
