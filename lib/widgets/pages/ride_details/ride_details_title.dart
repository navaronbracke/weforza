import 'package:flutter/widgets.dart';
import 'package:flutter_riverpod/flutter_riverpod.dart';
import 'package:weforza/riverpod/ride/selected_ride_provider.dart';

class RideDetailsTitle extends ConsumerWidget {
  const RideDetailsTitle({Key? key}) : super(key: key);

  @override
  Widget build(BuildContext context, WidgetRef ref) {
    final ride = ref.watch(selectedRideProvider.select((r) => r!.value));

    return Text(
      ride.getFormattedDate(context),
      style: const TextStyle(fontSize: 16),
    );
  }
}
