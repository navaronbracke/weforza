import 'package:flutter_riverpod/flutter_riverpod.dart';
import 'package:weforza/repository/rider_repository.dart';
import 'package:weforza/riverpod/database/database_provider.dart';

final riderRepositoryProvider = Provider<RiderRepository>((ref) => RiderRepository(ref.watch(databaseProvider)));
