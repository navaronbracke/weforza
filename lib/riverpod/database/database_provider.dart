import 'package:flutter_riverpod/flutter_riverpod.dart';
import 'package:weforza/database/database.dart';

/// This provider provides the application database.
final databaseProvider = Provider<ApplicationDatabase>(
  (_) => ApplicationDatabase(),
);
