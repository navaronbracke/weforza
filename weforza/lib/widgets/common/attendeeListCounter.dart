import 'package:flutter/widgets.dart';
import 'package:weforza/generated/l10n.dart';

class AttendeeListCounter extends StatelessWidget {
  AttendeeListCounter({
    required this.count
  });

  final int count;

  @override
  Widget build(BuildContext context) {
    // We usually show an empty list widget in this case.
    if(count == 0){
      return SizedBox.shrink();
    }

    if(count == 1){
      return Text(
        S.of(context).AttendeeCounterOne,
        style: TextStyle(fontSize: 12),
      );
    }

    return Text(
      S.of(context).AttendeeCounterMany(count),
      style: TextStyle(fontSize: 12),
    );
  }
}