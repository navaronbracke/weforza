import 'package:flutter/widgets.dart';
import 'package:flutter_riverpod/flutter_riverpod.dart';
import 'package:weforza/generated/l10n.dart';
import 'package:weforza/riverpod/rider/rider_list_provider.dart';

/// This widget represents the title in the rider list page.
class RiderListTitle extends ConsumerWidget {
  const RiderListTitle({super.key});

  @override
  Widget build(BuildContext context, WidgetRef ref) {
    final amount = ref.watch(riderAmountProvider);
    final translator = S.of(context);

    return amount.when(
      data: (value) => Text(translator.ridersListTitle(value)),
      error: (error, stackTrace) => Text(translator.riders),
      loading: () => Text(translator.riders),
    );
  }
}
