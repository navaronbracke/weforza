import 'package:flutter/widgets.dart';
import 'package:weforza/database/database.dart';
import 'package:weforza/widgets/theme.dart';

class RiderName extends StatelessWidget {
  const new({required this.rider, super.key});

  final Rider rider;

  @override
  Widget build(BuildContext context) {
    const textTheme = AppTheme.riderTextTheme;

    return Column(
      crossAxisAlignment: .start,
      children: <Widget>[
        Text(rider.firstName, style: textTheme.firstNameLargeStyle, overflow: .ellipsis),
        Text(rider.lastName, style: textTheme.lastNameLargeStyle, overflow: .ellipsis),
        if (rider.alias case final alias? when alias.isNotEmpty)
          Text("'$alias'", style: textTheme.aliasStyle, overflow: .ellipsis),
      ],
    );
  }
}
