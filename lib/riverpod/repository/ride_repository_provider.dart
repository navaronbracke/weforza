import 'package:flutter_riverpod/flutter_riverpod.dart';
import 'package:weforza/repository/ride_repository.dart';
import 'package:weforza/riverpod/database/database_dao_provider.dart';

/// This provider provides the [RideRepository].
final rideRepositoryProvider = Provider<RideRepository>((ref) {
  return RideRepository(ref.read(rideDaoProvider));
});
