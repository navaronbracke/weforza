import 'package:flutter_riverpod/flutter_riverpod.dart';
import 'package:weforza/repository/export_rides_repository.dart';
import 'package:weforza/riverpod/database/database_dao_provider.dart';

/// This provider provides the [ExportRidesRepository].
final exportRidesRepositoryProvider = Provider<ExportRidesRepository>((ref) {
  return ExportRidesRepository(ref.read(exportRidesDaoProvider));
});
