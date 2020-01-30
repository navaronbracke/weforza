import 'package:flutter/cupertino.dart';
import 'package:flutter/material.dart';
import 'package:flutter/widgets.dart';
import 'package:weforza/blocs/editRideBloc.dart';
import 'package:weforza/generated/i18n.dart';
import 'package:weforza/injection/injector.dart';
import 'package:weforza/provider/rideProvider.dart';
import 'package:weforza/repository/rideRepository.dart';
import 'package:weforza/widgets/platform/platformAwareWidget.dart';

class EditRidePage extends StatefulWidget {
  @override
  _EditRidePageState createState() => _EditRidePageState(EditRideBloc(InjectionContainer.get<RideRepository>()));
}

class _EditRidePageState extends State<EditRidePage> implements PlatformAwareWidget {
  _EditRidePageState(this._bloc): assert(_bloc != null);

  final EditRideBloc _bloc;

  ///The key for the form.
  final _formKey = GlobalKey<FormState>();

  String _titleLabel;
  String _departureLabel;
  String _destinationLabel;
  String _distanceLabel;

  ///Initialize localized strings for the form.
  ///This requires a [BuildContext] for the lookup.
  void _initStrings(BuildContext context) {
    final S translator = S.of(context);
    //TODO fetch strings
  }

  @override
  Widget build(BuildContext context) {
    _initStrings(context);
    return PlatformAwareWidgetBuilder.build(context, this);
  }

  @override
  Widget buildAndroidWidget(BuildContext context) {
    final ride = RideProvider.selectedRide;
    return Scaffold(
      appBar: AppBar(
        title: Text(S.of(context).EditRidePageTitle),
      ),
      body: SingleChildScrollView(
        child: Form(
          key: _formKey,
          child: Column(
            children: <Widget>[
              Center(
                child: Row(
                  children: <Widget>[
                    Icon(Icons.calendar_today),
                    SizedBox(width: 4),
                    Text(ride.getFormattedDate(context,false),style: TextStyle(fontWeight: FontWeight.w500)),
                  ],
                ),
              ),
              Expanded(
                //TODO inputs
                child: Column(
                  children: <Widget>[
                    TextFormField(),//Title
                    SizedBox(height: 5),
                    TextFormField(),//Departure
                    SizedBox(height: 5),
                    TextFormField(),//Destination
                    SizedBox(height: 5),
                    TextFormField(),//Distance
                  ],
                ),
              ),
              //TODO submit button
            ],
          ),
        ),
      ),
    );
  }

  @override
  Widget buildIosWidget(BuildContext context) {
    //TODO IOS layout
    return CupertinoPageScaffold(
      navigationBar: CupertinoNavigationBar(
        transitionBetweenRoutes: false,
        middle: Text(S.of(context).EditRidePageTitle),
      ),
      child: Center(child: Text("Edit Ride Screen")),
    );
  }
}
