import 'dart:async';

import 'package:weforza/model/deferred_save_delegate.dart';
import 'package:weforza/model/rider/rider_list_display_mode.dart';
import 'package:weforza/riverpod/settings/settings_provider.dart';

/// This class represents the delegate that manages
/// the [RiderListDisplayMode] option for the settings page.
class RiderListDisplayModeDelegate extends DeferredSaveDelegate<RiderListDisplayMode> {
  new({required this._settingsDelegate, required super.initialValue});

  final SettingsNotifier _settingsDelegate;

  @override
  void onValueCommitted(RiderListDisplayMode value) {
    unawaited(
      _settingsDelegate.saveRiderListDisplayMode(value).catchError((_) {
        // If the rider list filter could not be saved, do nothing.
      }),
    );
  }
}
