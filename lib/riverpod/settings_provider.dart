import 'package:flutter_riverpod/flutter_riverpod.dart';
import 'package:weforza/model/settings.dart';
import 'package:weforza/riverpod/repository/settings_repository_provider.dart';
import 'package:weforza/riverpod/ride/ride_list_provider.dart';

/// This provider provides the application settings.
final settingsProvider = FutureProvider<Settings>((ref) async {
  final repository = ref.read(settingsRepositoryProvider);

  final ridesCount = await ref.watch(rideListCountProvider.future);

  return repository.loadApplicationSettings(ridesCount);
});
