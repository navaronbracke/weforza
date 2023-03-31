import 'package:flutter_riverpod/flutter_riverpod.dart';
import 'package:weforza/repository/serialize_riders_repository.dart';
import 'package:weforza/riverpod/database/database_dao_provider.dart';

final serializeRidersRepositoryProvider = Provider(
  (ref) => SerializeRidersRepository(
    ref.read(deviceDaoProvider),
    ref.read(importRidersDaoProvider),
    ref.read(memberDaoProvider),
  ),
);
