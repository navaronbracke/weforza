import 'dart:async';

import 'package:weforza/model/deferred_save_delegate.dart';
import 'package:weforza/model/rider/rider_filter_option.dart';
import 'package:weforza/riverpod/settings_provider.dart';

/// This class represents the delegate that manages
/// the rider list filter option for the settings page.
class RiderFilterDelegate extends DeferredSaveDelegate<RiderFilterOption> {
  RiderFilterDelegate({required SettingsNotifier settingsDelegate, required super.initialValue})
    : _settingsDelegate = settingsDelegate;

  final SettingsNotifier _settingsDelegate;

  @override
  void saveValue(RiderFilterOption value) {
    unawaited(
      _settingsDelegate.saveRiderListFilter(value).catchError((_) {
        // If the rider list filter could not be saved, do nothing.
      }),
    );
  }
}
