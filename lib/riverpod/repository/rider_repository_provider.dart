import 'package:flutter_riverpod/flutter_riverpod.dart';
import 'package:weforza/repository/rider_repository.dart';
import 'package:weforza/riverpod/database/database_dao_provider.dart';

/// This provider provides the [RiderRepository].
final riderRepositoryProvider = Provider<RiderRepository>((ref) {
  return RiderRepository(ref.read(riderDaoProvider));
});
