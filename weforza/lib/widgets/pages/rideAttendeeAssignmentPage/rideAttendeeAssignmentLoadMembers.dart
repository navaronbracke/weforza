import 'package:flutter/cupertino.dart';
import 'package:flutter/material.dart';
import 'package:flutter/widgets.dart';
import 'package:weforza/generated/i18n.dart';
import 'package:weforza/widgets/platform/platformAwareLoadingIndicator.dart';
import 'package:weforza/widgets/platform/platformAwareWidget.dart';

class RideAttendeeAssignmentLoadMembers extends StatelessWidget implements PlatformAwareWidget {
  RideAttendeeAssignmentLoadMembers(this.title,this.future): assert(title != null && future != null);

  final Future<void> future;
  final String title;

  @override
  Widget build(BuildContext context) => PlatformAwareWidgetBuilder.build(context, this);

  @override
  Widget buildAndroidWidget(BuildContext context) {
    return FutureBuilder<void>(
      future: future,
      builder: (context,snapshot){
        if(snapshot.hasError){
          return Scaffold(
            appBar: AppBar(title: Text(title,style: TextStyle(fontSize: 16))),
            body: Column(
              mainAxisAlignment: MainAxisAlignment.center,
              children: <Widget>[
                Icon(Icons.warning),
                SizedBox(height: 5),
                Text(S.of(context).MemberListLoadingFailed),
              ],
            ),
          );
        }else{
          return Scaffold(
            appBar: AppBar(title: Text(title,style: TextStyle(fontSize: 16))),
            body: Center(child: PlatformAwareLoadingIndicator()),
          );
        }
      },
    );
  }

  @override
  Widget buildIosWidget(BuildContext context) {
    return FutureBuilder<void>(
      future: future,
        builder: (context,snapshot){
        if(snapshot.hasError){
          return CupertinoPageScaffold(
            navigationBar: CupertinoNavigationBar(
              middle: Text(title),
              transitionBetweenRoutes: false,
            ),
            child: Column(
              mainAxisAlignment: MainAxisAlignment.center,
              children: <Widget>[
                Icon(Icons.warning),
                SizedBox(height: 5),
                Text(S.of(context).MemberListLoadingFailed),
              ],
            ),
          );
        }else{
          return CupertinoPageScaffold(
            navigationBar: CupertinoNavigationBar(
              middle: Text(title),
              transitionBetweenRoutes: false,
            ),
            child: Center(child: PlatformAwareLoadingIndicator()),
          );
        }
      }
    );
  }
}
