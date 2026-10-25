import 'dart:async';

import 'package:weforza/model/deferred_save_delegate.dart';
import 'package:weforza/riverpod/settings/settings_provider.dart';

/// This class represents the delegate that manages
/// the scan duration option for the settings page.
class ScanDurationDelegate extends DeferredSaveDelegate<double> {
  new({required this._settingsDelegate, required super.initialValue});

  final SettingsNotifier _settingsDelegate;

  @override
  void onValueCommitted(double value) {
    unawaited(
      _settingsDelegate.saveScanDuration(value.floor()).catchError((_) {
        // If the scan duration value could not be saved, do nothing.
      }),
    );
  }
}
