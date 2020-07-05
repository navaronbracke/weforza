import 'package:flutter/material.dart';
import 'package:weforza/widgets/platform/platformAwareLoadingIndicator.dart';

class MemberDetailsAttendingCounter extends StatelessWidget {
  MemberDetailsAttendingCounter({
    @required this.future
  }): assert(future != null);


  final Future<int> future;

  @override
  Widget build(BuildContext context) {
    return Row(
      mainAxisAlignment: MainAxisAlignment.center,
      children: <Widget>[
        Icon(Icons.location_on),
        SizedBox(width: 5),
        FutureBuilder<int>(
          future: future,
          builder: (context,snapshot){
            if(snapshot.connectionState == ConnectionState.done){
              if(snapshot.hasError){
                return Text("?");
              }
              return Text("${snapshot.data}");
            }else{
              return PlatformAwareLoadingIndicator();
            }
          },
        )
      ],
    );
  }
}
