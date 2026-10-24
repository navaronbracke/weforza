import 'package:flutter/widgets.dart';
import 'package:weforza/widgets/theme.dart';

class RiderName extends StatelessWidget {
  const new({required this.firstName, required this.lastName, super.key, this.alias});

  final String firstName;
  final String lastName;
  final String? alias;

  @override
  Widget build(BuildContext context) {
    const textTheme = AppTheme.riderTextTheme;

    return Column(
      crossAxisAlignment: .start,
      children: <Widget>[
        Text(firstName, style: textTheme.firstNameLargeStyle, overflow: .ellipsis),
        Text(lastName, style: textTheme.lastNameLargeStyle, overflow: .ellipsis),
        if (alias case final alias? when alias.isNotEmpty)
          Text("'$alias'", style: textTheme.aliasStyle, overflow: .ellipsis),
      ],
    );
  }
}
