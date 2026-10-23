import 'package:flutter/cupertino.dart';
import 'package:flutter/foundation.dart';
import 'package:flutter/material.dart';
import 'package:flutter_riverpod/flutter_riverpod.dart';
import 'package:weforza/database/database.dart';
import 'package:weforza/riverpod/repository/rider_repository_provider.dart';
import 'package:weforza/riverpod/rider/selected_rider_attending_count_provider.dart';
import 'package:weforza/widgets/platform/platform_aware_loading_indicator.dart';

/// The provider for the attending count of a single rider list item
/// is an `autoDispose` provider as there might be many items in the list,
/// that get built nd destroyed.
final _riderAttendingCount = FutureProvider.autoDispose.family<int, int>((ref, id) {
  final repository = ref.watch(riderRepositoryProvider);

  return repository.getAttendingCount(id);
});

/// This widget represents the base attending count widget
/// that is used by [RiderListItemAttendingCount] and [SelectedRiderAttendingCount].
class _RiderAttendingCount extends StatelessWidget {
  const new(this.value, {required this.labelAlignment})
    : assert(
        labelAlignment == .left || labelAlignment == .right,
        'The label alignment should be AxisDirection.left or AxisDirection.right',
      );

  /// The alignment for the label.
  final AxisDirection labelAlignment;

  /// The attending count value to display.
  final AsyncValue<int?> value;

  Widget _buildBikeIcon(BuildContext context) {
    switch (defaultTargetPlatform) {
      case TargetPlatform.android:
      case TargetPlatform.fuchsia:
      case TargetPlatform.linux:
      case TargetPlatform.windows:
        return Icon(Icons.directions_bike, color: ColorScheme.of(context).primary);
      case TargetPlatform.iOS:
      case TargetPlatform.macOS:
        return Icon(Icons.directions_bike, color: CupertinoTheme.of(context).primaryColor);
    }
  }

  Widget _buildLabelAndIcon(Widget label, Widget icon) {
    return Row(
      mainAxisSize: .min,
      mainAxisAlignment: .center,
      children: [
        if (labelAlignment == .right) Padding(padding: const .only(right: 4), child: icon),
        label,
        if (labelAlignment == .left) Padding(padding: const .only(left: 4), child: icon),
      ],
    );
  }

  @override
  Widget build(BuildContext context) {
    final icon = _buildBikeIcon(context);

    const Widget fallbackLabel = Text('?');

    return value.when(
      data: (count) => _buildLabelAndIcon(count == null ? fallbackLabel : Text('$count'), icon),
      error: (error, stackTrace) => _buildLabelAndIcon(fallbackLabel, icon),
      loading: () => const PlatformAwareLoadingIndicator(),
    );
  }
}

/// This widget represents the attending count for a rider list item.
class RiderListItemAttendingCount extends ConsumerWidget {
  const new({required this.rider, super.key});

  final Rider rider;

  @override
  Widget build(BuildContext context, WidgetRef ref) {
    final value = ref.watch(_riderAttendingCount(rider.id));

    return _RiderAttendingCount(value, labelAlignment: .left);
  }
}

/// This widget represents the attending count for the selected rider.
class SelectedRiderAttendingCount extends ConsumerWidget {
  const new({super.key});

  @override
  Widget build(BuildContext context, WidgetRef ref) {
    final value = ref.watch(selectedRiderAttendingCountProvider);

    return _RiderAttendingCount(value, labelAlignment: .right);
  }
}
