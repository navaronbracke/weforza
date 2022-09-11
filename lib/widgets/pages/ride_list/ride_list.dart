import 'package:flutter/material.dart';
import 'package:flutter_riverpod/flutter_riverpod.dart';
import 'package:weforza/generated/l10n.dart';
import 'package:weforza/riverpod/ride/ride_list_provider.dart';
import 'package:weforza/widgets/common/generic_error.dart';
import 'package:weforza/widgets/pages/ride_list/ride_list_empty.dart';
import 'package:weforza/widgets/pages/ride_list/ride_list_item.dart';
import 'package:weforza/widgets/platform/platform_aware_loading_indicator.dart';

/// This widget represents the list of rides.
class RideList extends ConsumerWidget {
  const RideList({super.key});

  @override
  Widget build(BuildContext context, WidgetRef ref) {
    final ridesList = ref.watch(rideListProvider);

    return ridesList.when(
      data: (items) {
        if (items.isEmpty) {
          return const RideListEmpty();
        }

        return ListView.builder(
          itemCount: items.length,
          itemBuilder: (context, index) => RideListItem(ride: items[index]),
        );
      },
      error: (error, stackTrace) {
        return GenericError(text: S.of(context).GenericError);
      },
      loading: () => const Center(child: PlatformAwareLoadingIndicator()),
    );
  }
}
