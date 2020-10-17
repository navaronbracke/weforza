import 'package:flutter/material.dart';
import 'package:weforza/theme/appTheme.dart';
import 'package:weforza/widgets/platform/platformAwareLoadingIndicator.dart';

class MemberAttendingCount extends StatelessWidget {
  MemberAttendingCount({ @required this.future }): assert(future != null);

  final Future<int> future;

  @override
  Widget build(BuildContext context) {
    return FutureBuilder<int>(
      future: future,
      builder: (context,snapshot){
        if(snapshot.connectionState == ConnectionState.done){
          if(snapshot.hasError){
            return Row(
              children: [
                Padding(
                  padding: const EdgeInsets.only(right: 5),
                  child: Text("?"),
                ),
                Icon(Icons.directions_bike, color: ApplicationTheme.primaryColor)
              ],
            );
          }

          return Row(
            children: [
              Padding(
                padding: const EdgeInsets.only(right: 5),
                child: Text(snapshot.data.toString()),
              ),
              Icon(Icons.directions_bike, color: ApplicationTheme.primaryColor)
            ],
          );
        }else{
          return PlatformAwareLoadingIndicator();
        }
      },
    );
  }
}