import 'package:flutter_riverpod/flutter_riverpod.dart';
import 'package:weforza/database/database.dart';

/// This provider provides the application database.
final databaseProvider = Provider<WeForzaDatabase>((ref) {
  final database = WeForzaDatabase();

  ref.onDispose(database.close);

  return database;
});
