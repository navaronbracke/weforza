import 'package:flutter/widgets.dart';
import 'package:flutter_riverpod/flutter_riverpod.dart';
import 'package:weforza/generated/l10n.dart';
import 'package:weforza/riverpod/rider/rider_list_provider.dart';

/// This widget represents the title in the rider list page.
class RiderListTitle extends ConsumerWidget {
  const RiderListTitle({super.key});

  @override
  Widget build(BuildContext context, WidgetRef ref) {
    final riderList = ref.watch(riderListProvider);
    final translator = S.of(context);

    return riderList.when(
      data: (items) => Text(translator.RidersListTitle(items.length)),
      error: (error, stackTrace) => Text(translator.Riders),
      loading: () => Text(translator.Riders),
    );
  }
}
