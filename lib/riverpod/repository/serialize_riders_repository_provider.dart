import 'package:flutter_riverpod/flutter_riverpod.dart';
import 'package:weforza/repository/serialize_riders_repository.dart';
import 'package:weforza/riverpod/database/database_dao_provider.dart';
import 'package:weforza/riverpod/file/file_uri_parser_provider.dart';

final serializeRidersRepositoryProvider = Provider(
  (ref) => SerializeRidersRepository(
    ref.read(deviceDaoProvider),
    ref.read(fileUriParserProvider),
    ref.read(importRidersDaoProvider),
    ref.read(riderDaoProvider),
  ),
);
