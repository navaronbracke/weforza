import 'package:weforza/model/deferred_save_delegate.dart';
import 'package:weforza/model/member_filter_option.dart';

/// This class represents the delegate that manages
/// the rider list filter option for the settings page.
class RiderFilterDelegate extends DeferredSaveDelegate<MemberFilterOption> {
  RiderFilterDelegate({required super.initialValue});

  @override
  void saveValue(MemberFilterOption value) {
    // TODO: implement partial save of rider list filter
  }
}
