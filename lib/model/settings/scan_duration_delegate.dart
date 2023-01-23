import 'package:weforza/model/deferred_save_delegate.dart';

/// This class represents the delegate that manages
/// the scan duration option for the settings page.
class ScanDurationDelegate extends DeferredSaveDelegate<double> {
  ScanDurationDelegate({required super.initialValue});

  @override
  void saveValue(double value) {
    // TODO: implement partial save of scan duration
  }
}
