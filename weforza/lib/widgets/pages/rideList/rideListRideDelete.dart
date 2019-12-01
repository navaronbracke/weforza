

import 'package:flutter/cupertino.dart';
import 'package:flutter/material.dart';
import 'package:flutter/widgets.dart';
import 'package:weforza/generated/i18n.dart';
import 'package:weforza/widgets/platform/platformAwareWidget.dart';

abstract class IRideDeleteHandler {

  void cancelDeletion();

  void deleteSelection();
}

class RideListRideDelete extends StatelessWidget implements PlatformAwareWidget {
  RideListRideDelete(this.handler): assert(handler != null);

  final IRideDeleteHandler handler;

  @override
  Widget build(BuildContext context) => PlatformAwareWidgetBuilder.build(context, this);

  @override
  Widget buildAndroidWidget(BuildContext context) {
    return Center(
      child: Column(
        mainAxisAlignment: MainAxisAlignment.center,
        crossAxisAlignment: CrossAxisAlignment.center,
        children: <Widget>[
          Text(S.of(context).RideListDeleteRidesDescription,softWrap: true),
          SizedBox(height: 10),
          Center(
            child: Row(
              mainAxisAlignment: MainAxisAlignment.center,
              children: <Widget>[
                FlatButton(
                  child: Text(S.of(context).DialogCancel),
                  onPressed: (){
                    handler.cancelDeletion();
                  },
                ),
                SizedBox(width: 10),
                FlatButton(
                  child: Text(S.of(context).DialogDelete,style: TextStyle(color: Colors.red)),
                  onPressed: (){
                    handler.deleteSelection();
                  },
                ),
              ],
            ),
          ),
        ],
      ),
    );
  }

  @override
  Widget buildIosWidget(BuildContext context) {
    return Center(
      child: Column(
        mainAxisAlignment: MainAxisAlignment.center,
        crossAxisAlignment: CrossAxisAlignment.center,
        children: <Widget>[
          Text(S.of(context).RideListDeleteRidesDescription,softWrap: true),
          SizedBox(height: 10),
          Center(
            child: Row(
              mainAxisAlignment: MainAxisAlignment.center,
              children: <Widget>[
                CupertinoButton(
                  child: Text(S.of(context).DialogCancel),
                  onPressed: (){
                    handler.cancelDeletion();
                  },
                ),
                SizedBox(width: 10),
                CupertinoButton(
                  child: Text(S.of(context).DialogDelete,style: TextStyle(color: Colors.red)),
                  onPressed: (){
                    handler.deleteSelection();
                  },
                ),
              ],
            ),
          ),
        ],
      ),
    );
  }
}
