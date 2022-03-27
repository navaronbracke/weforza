import 'package:flutter/material.dart';
import 'package:flutter_riverpod/flutter_riverpod.dart';
import 'package:weforza/generated/l10n.dart';
import 'package:weforza/model/ride.dart';
import 'package:weforza/riverpod/ride/ride_list_provider.dart';
import 'package:weforza/widgets/common/generic_error.dart';
import 'package:weforza/widgets/pages/ride_list/ride_list_empty.dart';
import 'package:weforza/widgets/pages/ride_list/ride_list_item.dart';
import 'package:weforza/widgets/platform/platform_aware_loading_indicator.dart';

/// This widget represents the list of rides.
class RideList extends ConsumerWidget {
  const RideList({Key? key}) : super(key: key);

  Widget _buildList(List<Ride> items) {
    if (items.isEmpty) {
      return const RideListEmpty();
    }

    return ListView.builder(
      itemCount: items.length,
      itemBuilder: (context, index) => RideListItem(ride: items[index]),
    );
  }

  @override
  Widget build(BuildContext context, WidgetRef ref) {
    final future = ref.watch(rideListProvider);

    return FutureBuilder<List<Ride>>(
      future: future,
      builder: (context, snapshot) {
        final translator = S.of(context);

        switch (snapshot.connectionState) {
          case ConnectionState.done:
            final items = snapshot.data;

            return snapshot.hasError
                ? GenericError(text: translator.GenericError)
                : _buildList(items ?? []);
          default:
            return const Center(child: PlatformAwareLoadingIndicator());
        }
      },
    );
  }
}
