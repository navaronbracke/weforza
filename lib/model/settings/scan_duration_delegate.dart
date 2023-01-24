import 'package:weforza/model/deferred_save_delegate.dart';
import 'package:weforza/riverpod/settings_provider.dart';

/// This class represents the delegate that manages
/// the scan duration option for the settings page.
class ScanDurationDelegate extends DeferredSaveDelegate<double> {
  ScanDurationDelegate({
    required SettingsNotifier settingsDelegate,
    required super.initialValue,
  }) : _settingsDelegate = settingsDelegate;

  final SettingsNotifier _settingsDelegate;

  @override
  void saveValue(double value) {
    // TODO: implement partial save of scan duration
  }
}
