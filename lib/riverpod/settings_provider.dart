import 'package:flutter_riverpod/flutter_riverpod.dart';
import 'package:weforza/model/settings.dart';

/// This provider provides the application settings.
///
/// This provider is overridden at startup with the preloaded settings.
final settingsProvider = StateProvider<Settings>((_) {
  throw UnsupportedError('The settings should be preloaded at startup.');
});
