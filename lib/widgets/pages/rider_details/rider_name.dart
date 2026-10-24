import 'package:flutter/widgets.dart';
import 'package:flutter_riverpod/flutter_riverpod.dart';
import 'package:weforza/riverpod/rider/selected_rider_provider.dart';
import 'package:weforza/widgets/theme.dart';

class RiderName extends ConsumerWidget {
  const new({super.key});

  @override
  Widget build(BuildContext context, WidgetRef ref) {
    final firstName = ref.watch(selectedRiderProvider.select((value) => value!.firstName));

    final lastName = ref.watch(selectedRiderProvider.select((value) => value!.lastName));

    final alias = ref.watch(selectedRiderProvider.select((value) => value!.alias));

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
