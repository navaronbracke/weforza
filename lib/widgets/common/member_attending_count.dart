import 'package:flutter/material.dart';
import 'package:weforza/theme/app_theme.dart';
import 'package:weforza/widgets/platform/platformAwareLoadingIndicator.dart';

class MemberAttendingCount extends StatelessWidget {
  const MemberAttendingCount({
    Key? key,
    required this.future,
  }) : super(key: key);

  final Future<int> future;

  @override
  Widget build(BuildContext context) {
    return FutureBuilder<int>(
      future: future,
      builder: (context, snapshot) {
        if (snapshot.connectionState == ConnectionState.done) {
          if (snapshot.hasError) {
            return Row(
              mainAxisSize: MainAxisSize.min,
              mainAxisAlignment: MainAxisAlignment.center,
              children: const [
                Padding(padding: EdgeInsets.only(right: 5), child: Text('?')),
                Icon(
                  Icons.directions_bike,
                  color: ApplicationTheme.primaryColor,
                ),
              ],
            );
          }

          return Row(
            mainAxisSize: MainAxisSize.min,
            mainAxisAlignment: MainAxisAlignment.center,
            children: [
              Padding(
                padding: const EdgeInsets.only(right: 5),
                child: Text(snapshot.data.toString()),
              ),
              const Icon(
                Icons.directions_bike,
                color: ApplicationTheme.primaryColor,
              ),
            ],
          );
        } else {
          return const PlatformAwareLoadingIndicator();
        }
      },
    );
  }
}