import 'package:flutter/widgets.dart';
import 'package:weforza/model/memberItem.dart';
import 'package:weforza/model/ride.dart';

///This InheritedWidget manages the selected items for Ride and Member.
class SelectedItemProvider extends InheritedWidget {
  SelectedItemProvider({
    Key key,
    @required Widget child,
  }) : assert(child != null), super(key: key, child: child);

  final ValueNotifier<Ride> selectedRide = ValueNotifier(null);
  final ValueNotifier<MemberItem> selectedMember = ValueNotifier(null);

  static SelectedItemProvider of(BuildContext context)
   => context.dependOnInheritedWidgetOfExactType<SelectedItemProvider>();

  @override
  bool updateShouldNotify(SelectedItemProvider old)
   => selectedRide != old.selectedRide && selectedMember != old.selectedMember;
}