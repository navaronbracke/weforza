import 'package:flutter_riverpod/flutter_riverpod.dart';
import 'package:weforza/repository/export_rides_repository.dart';
import 'package:weforza/riverpod/database/database_provider.dart';

final exportRidesRepositoryProvider = Provider<ExportRidesRepository>((ref) {
  return ExportRidesRepository(ref.watch(databaseProvider));
});
