import 'package:flutter_riverpod/flutter_riverpod.dart';
import 'package:weforza/database/database.dart';

/// This provider provides the application database.
///
/// This provider should be overridden with the opened database at application startup.
final databaseProvider = Provider<ApplicationDatabase>((ref) {
  throw UnsupportedError('The application database should be preloaded at startup.');
});
