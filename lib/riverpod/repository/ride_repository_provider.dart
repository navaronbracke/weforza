import 'package:flutter_riverpod/flutter_riverpod.dart';
import 'package:weforza/repository/ride_repository.dart';
import 'package:weforza/riverpod/database/database_provider.dart';

final rideRepositoryProvider = Provider<RideRepository>((ref) => RideRepository(ref.watch(databaseProvider)));
