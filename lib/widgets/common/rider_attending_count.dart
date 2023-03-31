import 'package:flutter/cupertino.dart';
import 'package:flutter/foundation.dart';
import 'package:flutter/material.dart';
import 'package:flutter_riverpod/flutter_riverpod.dart';
import 'package:weforza/model/rider/rider.dart';
import 'package:weforza/riverpod/repository/rider_repository_provider.dart';
import 'package:weforza/riverpod/rider/selected_rider_attending_count_provider.dart';
import 'package:weforza/widgets/platform/platform_aware_loading_indicator.dart';

/// The provider for the attending count of a single rider list item
/// is an `autoDispose` provider as there might be many items in the list,
/// that get built nd destroyed.
final _riderAttendingCount = FutureProvider.autoDispose.family<int, String>((ref, uuid) {
  final repository = ref.read(riderRepositoryProvider);

  return repository.getAttendingCount(uuid);
});

/// This widget represents the base attending count widget
/// that is used by [RiderListItemAttendingCount] and [SelectedRiderAttendingCount].
class _RiderAttendingCount extends StatelessWidget {
  const _RiderAttendingCount(this.value);

  final AsyncValue<int?> value;

  Widget _buildBikeIcon(BuildContext context) {
    switch (defaultTargetPlatform) {
      case TargetPlatform.android:
      case TargetPlatform.fuchsia:
      case TargetPlatform.linux:
      case TargetPlatform.windows:
        return Icon(Icons.directions_bike, color: Theme.of(context).primaryColor);
      case TargetPlatform.iOS:
      case TargetPlatform.macOS:
        return Icon(
          Icons.directions_bike,
          color: CupertinoTheme.of(context).primaryColor,
        );
    }
  }

  @override
  Widget build(BuildContext context) {
    final icon = _buildBikeIcon(context);

    return value.when(
      data: (count) {
        return Row(
          mainAxisSize: MainAxisSize.min,
          mainAxisAlignment: MainAxisAlignment.center,
          children: [
            Padding(
              padding: const EdgeInsets.only(right: 4),
              child: Text('${count ?? '?'}'),
            ),
            icon,
          ],
        );
      },
      error: (error, stackTrace) => Row(
        mainAxisSize: MainAxisSize.min,
        mainAxisAlignment: MainAxisAlignment.center,
        children: [
          const Padding(padding: EdgeInsets.only(right: 4), child: Text('?')),
          icon,
        ],
      ),
      loading: () => const PlatformAwareLoadingIndicator(),
    );
  }
}

/// This widget represents the attending count for a rider list item.
class RiderListItemAttendingCount extends ConsumerWidget {
  const RiderListItemAttendingCount({
    required this.rider,
    super.key,
  });

  final Rider rider;

  @override
  Widget build(BuildContext context, WidgetRef ref) {
    final value = ref.watch(_riderAttendingCount(rider.uuid));

    return _RiderAttendingCount(value);
  }
}

/// This widget represents the attending count for the selected rider.
class SelectedRiderAttendingCount extends ConsumerWidget {
  const SelectedRiderAttendingCount({super.key});

  @override
  Widget build(BuildContext context, WidgetRef ref) {
    final value = ref.watch(selectedRiderAttendingCountProvider);

    return _RiderAttendingCount(value);
  }
}
