import 'package:flutter/cupertino.dart';
import 'package:flutter/material.dart';
import 'package:flutter_riverpod/flutter_riverpod.dart';
import 'package:weforza/riverpod/rider/selected_rider_provider.dart';
import 'package:weforza/widgets/custom/profile_image/profile_image.dart';

class RiderProfileImage extends ConsumerWidget {
  const RiderProfileImage({super.key});

  @override
  Widget build(BuildContext context, WidgetRef ref) {
    final selectedRider = ref.watch(
      selectedRiderProvider.select((value) => value!),
    );

    return AdaptiveProfileImage.path(
      imagePath: selectedRider.profileImageFilePath,
      personInitials: selectedRider.initials,
      size: 72,
    );
  }
}
