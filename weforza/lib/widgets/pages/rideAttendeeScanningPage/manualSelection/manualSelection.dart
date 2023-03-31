import 'package:flutter/widgets.dart';
import 'package:weforza/model/member.dart';
import 'package:weforza/widgets/pages/rideAttendeeScanningPage/manualSelection/manualSelectionListEmpty.dart';

class RideAttendeeManualSelection extends StatelessWidget {
  RideAttendeeManualSelection({
    @required this.items,
    @required this.itemBuilder,
    @required this.saveButtonBuilder
  }): assert(items != null && itemBuilder != null && saveButtonBuilder != null);

  final List<Member> items;
  final Widget Function(Member item) itemBuilder;
  final Widget Function() saveButtonBuilder;

  @override
  Widget build(BuildContext context) {
    if(items.isEmpty){
      return Center(child: ManualSelectionListEmpty());
    }else{
      return Column(
        children: <Widget>[
          Expanded(
            child: ListView.builder(
              itemBuilder: (context, index) => itemBuilder(items[index]),
              itemCount: items.length,
            ),
          ),
          saveButtonBuilder(),
        ],
      );
    }
  }
}
