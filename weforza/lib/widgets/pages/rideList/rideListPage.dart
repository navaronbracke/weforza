
import 'package:flutter/cupertino.dart';
import 'package:flutter/material.dart';
import 'package:flutter/widgets.dart';
import 'package:weforza/blocs/rideListBloc.dart';
import 'package:weforza/generated/i18n.dart';
import 'package:weforza/injection/injector.dart';
import 'package:weforza/widgets/platformAwareWidgetBuilder.dart';

///This [Widget] shows the list of Rides.
class RideListPage extends StatefulWidget {
  @override
  State<RideListPage> createState() => _RideListPageState(InjectionContainer.get<RideListBloc>());
}

///This class is the [State] for [RideListPage].
class _RideListPageState extends State<RideListPage> implements PlatformAwareWidget {
  _RideListPageState(this._bloc): assert(_bloc != null);

  ///The BLoC for this [Widget].
  final RideListBloc _bloc;

  @override
  Widget build(BuildContext context) => PlatformAwareWidgetBuilder.buildPlatformAwareWidget(context, this);

  @override
  Widget buildAndroidWidget(BuildContext context) {
    // TODO: implement buildAndroidWidget
    return Scaffold(
      appBar: AppBar(
        title: Text(S.of(context).RideListTitle),
      ),
      body: Center(),
    );
  }

  @override
  Widget buildIosWidget(BuildContext context) {
    // TODO: implement buildIosWidget
    return CupertinoPageScaffold(
      navigationBar: CupertinoNavigationBar(
        middle: Text(S.of(context).RideListTitle),
      ),
      child: Center(),
    );
  }

}