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
                  child: Icon(Icons.directions_bike, color: ApplicationTheme.primaryColor),
                ),
                Text("?")
              ],
            );
          }

          return Row(
            children: [
              Padding(
                padding: const EdgeInsets.only(right: 5),
                child: Icon(Icons.directions_bike, color: ApplicationTheme.primaryColor),
              ),
              Text(snapshot.data.toString())
            ],
          );
        }else{
          return PlatformAwareLoadingIndicator();
        }
      },
    );
  }
}