import 'package:flutter/widgets.dart';
import 'package:flutter_riverpod/flutter_riverpod.dart';
import 'package:weforza/riverpod/ride/selected_ride_provider.dart';
import 'package:weforza/utils/date_format_utils.dart';

class RideDetailsTitle extends ConsumerWidget {
  const new({super.key});

  @override
  Widget build(BuildContext context, WidgetRef ref) {
    final rideDate = ref.watch(selectedRideProvider)?.date;

    return Text(rideDate?.formatWithPattern(context) ?? '', style: const TextStyle(fontSize: 16));
  }
}
