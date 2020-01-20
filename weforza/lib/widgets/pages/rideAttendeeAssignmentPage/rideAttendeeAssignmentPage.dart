import 'package:flutter/material.dart';
import 'package:flutter/widgets.dart';
import 'package:intl/intl.dart';
import 'package:provider/provider.dart';
import 'package:weforza/blocs/rideAttendeeAssignmentBloc.dart';
import 'package:weforza/generated/i18n.dart';
import 'package:weforza/injection/injector.dart';
import 'package:weforza/model/rideAttendeeDisplayMode.dart';
import 'package:weforza/repository/memberRepository.dart';
import 'package:weforza/repository/rideRepository.dart';
import 'package:weforza/widgets/pages/rideAttendeeAssignmentPage/rideAttendeeAssignmentItem.dart';
import 'package:weforza/widgets/pages/rideAttendeeAssignmentPage/rideAttendeeAssignmentScanning.dart';
import 'package:weforza/widgets/pages/rideAttendeeAssignmentPage/rideAttendeeAssignmentSubmit.dart';
import 'package:weforza/widgets/platform/platformAwareLoadingIndicator.dart';
import 'package:weforza/widgets/platform/platformAwareWidget.dart';
import 'package:weforza/widgets/provider/rideProvider.dart';


class RideAttendeeAssignmentPage extends StatefulWidget {

  @override
  _RideAttendeeAssignmentPageState createState() => _RideAttendeeAssignmentPageState(
      RideAttendeeAssignmentBloc(InjectionContainer.get<RideRepository>(),InjectionContainer.get<MemberRepository>())
  );
}

class _RideAttendeeAssignmentPageState extends State<RideAttendeeAssignmentPage> implements PlatformAwareWidget {
  _RideAttendeeAssignmentPageState(this._bloc): assert(_bloc != null);

  final RideAttendeeAssignmentBloc _bloc;

  @override
  Widget build(BuildContext context) => PlatformAwareWidgetBuilder.build(context, this);

  @override
  Widget buildAndroidWidget(BuildContext context) {
    final ride = Provider.of<RideProvider>(context).selectedRide;
    return StreamBuilder<RideAttendeeDisplayMode>(
      stream: _bloc.displayModeStream,
      initialData: RideAttendeeDisplayMode.MEMBERS,
      builder: (context,snapshot){
        if(snapshot.hasError){
          return Scaffold(
            appBar: AppBar(
              title: Text(
                  S.of(context).RideAttendeeAssignmentTitle(
                      DateFormat(_bloc.titleDateFormat,Localizations.localeOf(context)
                          .languageCode)
                          .format(ride.date))
              ),
            ),
            body: Center(child: Text(S.of(context).RideAttendeeAssignmentGenericError)),
          );
        }else{
          switch(snapshot.data){
            case RideAttendeeDisplayMode.IDLE: return Scaffold(
              appBar: AppBar(
                title: Text(
                    S.of(context).RideAttendeeAssignmentTitle(
                        DateFormat(_bloc.titleDateFormat,Localizations.localeOf(context)
                            .languageCode)
                            .format(ride.date))
                ),
                actions: _bloc.items.isEmpty ? []: <Widget>[
                  IconButton(
                    icon: Icon(Icons.bluetooth),
                    onPressed: (){
                      setState(() {
                        _bloc.startScan();
                      });
                    },
                  ),
                ],
              ),
              body: _bloc.items.isEmpty ?
              Center(child: Text(S.of(context).MemberListNoItems)) :
              Column(
                children: <Widget>[
                  StreamBuilder<String>(
                    initialData: S.of(context).RideAttendeeAssignmentInstruction,
                    builder: (context,snapshot){
                      if(snapshot.hasError){
                        return Text(S.of(context).RideAttendeeAssignmentGenericError);
                      }else{ return Text(snapshot.data); }
                    },
                  ),
                  Expanded(
                    child: ListView.builder(
                        itemBuilder: (context,index)=> RideAttendeeAssignmentItem(_bloc.items[index]),
                        itemCount: _bloc.items.length,
                    ),
                  ),
                  RideAttendeeAssignmentSubmit(() => _bloc.onSubmit(ride)),
                ],
              ),
            );
            case RideAttendeeDisplayMode.MEMBERS: return FutureBuilder<void>(
              future: _bloc.loadMembers(ride),
              builder: (context,snapshot){
                if(snapshot.hasError){
                  return Scaffold(
                    appBar: AppBar(
                      title: Text(
                          S.of(context).RideAttendeeAssignmentTitle(
                              DateFormat(_bloc.titleDateFormat,Localizations.localeOf(context)
                                  .languageCode)
                                  .format(ride.date))
                      ),
                    ),
                    body: Center(
                      child: Text(S.of(context).MemberListLoadingFailed),
                    ),
                  );
                }else{
                  return Scaffold(
                    appBar: AppBar(
                      title: Text(
                          S.of(context).RideAttendeeAssignmentTitle(
                              DateFormat(_bloc.titleDateFormat,Localizations.localeOf(context)
                                  .languageCode)
                                  .format(ride.date))
                      ),
                    ),
                    body: Center(child: PlatformAwareLoadingIndicator()),
                  );
                }
              },
            );//future builder for members
            case RideAttendeeDisplayMode.SCANNING: return FutureBuilder<void>(
              future: _bloc.scanFuture,
              builder: (context,snapshot){
                if(snapshot.hasError){
                  return Scaffold(
                    appBar: AppBar(
                      title: Text(
                          S.of(context).RideAttendeeAssignmentTitle(
                              DateFormat(_bloc.titleDateFormat,Localizations.localeOf(context)
                                  .languageCode)
                                  .format(ride.date))
                      ),
                    ),
                    body: Center(
                      child: Column(
                        children: <Widget>[
                          Text(S.of(context).RideAttendeeAssignmentScanningFailed),
                          SizedBox(height: 20),
                          FlatButton(
                              child: Text(S.of(context).DialogOk),
                              onPressed: () => _bloc.onScanErrorDismissed()
                          )
                        ],
                      ),
                    ),
                  );
                }else{
                  return Scaffold(
                    appBar: AppBar(
                      title: Text(
                          S.of(context).RideAttendeeAssignmentTitle(
                              DateFormat(_bloc.titleDateFormat,Localizations.localeOf(context)
                                  .languageCode)
                                  .format(ride.date))
                      ),
                    ),
                    body: RideAttendeeAssignmentScanning(_bloc),
                  );
                }
              },
            );
            default: return Scaffold(
              appBar: AppBar(
                title: Text(
                    S.of(context).RideAttendeeAssignmentTitle(
                        DateFormat(_bloc.titleDateFormat,Localizations.localeOf(context)
                            .languageCode)
                            .format(ride.date))
                ),
              ),
              body: Center(child: Text(S.of(context).RideAttendeeAssignmentGenericError)),
            );
          }
        }
      },
    );
  }

  @override
  Widget buildIosWidget(BuildContext context) {
    // TODO: implement buildIosWidget
    return null;
  }
}
