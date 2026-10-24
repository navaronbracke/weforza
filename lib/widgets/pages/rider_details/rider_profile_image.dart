import 'package:flutter/widgets.dart';
import 'package:weforza/database/database.dart';
import 'package:weforza/widgets/custom/profile_image/profile_image.dart';

class RiderProfileImage extends StatelessWidget {
  const new({required this.rider, super.key});

  final Rider rider;

  @override
  Widget build(BuildContext context) {
    return AdaptiveProfileImage.fromRider(rider, size: 72);
  }
}
