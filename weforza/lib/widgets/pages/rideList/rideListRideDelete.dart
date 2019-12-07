

import 'package:flutter/cupertino.dart';
import 'package:flutter/material.dart';
import 'package:flutter/widgets.dart';
import 'package:weforza/generated/i18n.dart';
import 'package:weforza/widgets/platform/platformAwareLoadingIndicator.dart';
import 'package:weforza/widgets/platform/platformAwareWidget.dart';

abstract class IRideDeleteHandler {

  void cancelDeletion();

  Future<void> deleteSelection();
}

class RideListRideDelete extends StatefulWidget {
  RideListRideDelete(this.handler): assert(handler != null);

  final IRideDeleteHandler handler;

  @override
  _RideListRideDeleteState createState() => _RideListRideDeleteState();
}

class _RideListRideDeleteState extends State<RideListRideDelete> implements PlatformAwareWidget {

  Future<void> _future;

  @override
  Widget build(BuildContext context) => PlatformAwareWidgetBuilder.build(context, this);

  @override
  Widget buildAndroidWidget(BuildContext context) {
    return (_future == null) ? Center(
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
                    widget.handler.cancelDeletion();
                  },
                ),
                SizedBox(width: 10),
                FlatButton(
                  child: Text(S.of(context).DialogDelete,style: TextStyle(color: Colors.red)),
                  onPressed: (){
                    setState(() {
                      _future = widget.handler.deleteSelection();
                    });
                  },
                ),
              ],
            ),
          ),
        ],
      ),
    ): FutureBuilder(
      future: _future,
      builder: (context,snapshot){
        if(snapshot.connectionState == ConnectionState.done){
          if(snapshot.hasError){
            return Center(
              child: Text(S.of(context).RideListDeleteRidesError),
            );
          }
          return Center();
        }else{
          return Center(
            child: SizedBox(
              width: 100,
              height: 100,
              child: PlatformAwareLoadingIndicator(),
            ),
          );
        }
      },
    );
  }

  @override
  Widget buildIosWidget(BuildContext context) {
    return (_future == null) ? Center(
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
                    widget.handler.cancelDeletion();
                  },
                ),
                SizedBox(width: 10),
                CupertinoButton(
                  child: Text(S.of(context).DialogDelete,style: TextStyle(color: Colors.red)),
                  onPressed: (){
                    setState(() {
                      _future = widget.handler.deleteSelection();
                    });
                  },
                ),
              ],
            ),
          ),
        ],
      ),
    ): FutureBuilder(
      future: _future,
      builder: (context,snapshot){
        if(snapshot.connectionState == ConnectionState.done){
          if(snapshot.hasError){
            return Center(
              child: Text(S.of(context).RideListDeleteRidesError),
            );
          }
          return Center();
        }else{
          return Center(
            child: SizedBox(
              width: 100,
              height: 100,
              child: PlatformAwareLoadingIndicator(),
            ),
          );
        }
      },
    );
  }
}
