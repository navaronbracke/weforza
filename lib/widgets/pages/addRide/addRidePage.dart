import 'package:flutter/cupertino.dart';
import 'package:flutter/material.dart';
import 'package:weforza/blocs/add_ride_bloc.dart';
import 'package:weforza/generated/l10n.dart';
import 'package:weforza/injection/injectionContainer.dart';
import 'package:weforza/repository/ride_repository.dart';
import 'package:weforza/widgets/custom/add_ride_calendar/add_ride_calendar.dart';
import 'package:weforza/widgets/custom/add_ride_calendar/add_ride_calendar_color_legend.dart';
import 'package:weforza/widgets/pages/addRide/addRideSubmit.dart';
import 'package:weforza/widgets/platform/cupertinoIconButton.dart';
import 'package:weforza/widgets/platform/platformAwareLoadingIndicator.dart';
import 'package:weforza/widgets/platform/platformAwareWidget.dart';
import 'package:weforza/widgets/providers/reloadDataProvider.dart';

///This [Widget] represents a page where one or more rides can be added.
class AddRidePage extends StatefulWidget {
  const AddRidePage({Key? key}) : super(key: key);

  @override
  _AddRidePageState createState() => _AddRidePageState(
        bloc: AddRideBloc(repository: InjectionContainer.get<RideRepository>()),
      );
}

///This class is the State for [AddRidePage].
class _AddRidePageState extends State<AddRidePage> {
  _AddRidePageState({required this.bloc});

  ///The BLoC for this page.
  final AddRideBloc bloc;

  @override
  void initState() {
    super.initState();
    bloc.initCalendarDate();
    bloc.loadRideDatesIfNotLoaded();
  }

  @override
  Widget build(BuildContext context) => PlatformAwareWidget(
        android: () => _buildAndroidLayout(context),
        ios: () => _buildIOSLayout(context),
      );

  Widget _buildBody() {
    return Column(
      children: <Widget>[
        _buildCalendar(),
        Expanded(
          child: Column(
            mainAxisSize: MainAxisSize.min,
            children: [
              const Padding(
                padding: EdgeInsets.symmetric(vertical: 10),
                child: AddRideCalendarColorLegend(),
              ),
              Padding(
                padding: const EdgeInsets.only(bottom: 20),
                child: AddRideSubmit(
                  stream: bloc.submitStream,
                  onPressed: _onSubmit,
                ),
              ),
            ],
          ),
        ),
      ],
    );
  }

  Widget _buildAndroidLayout(BuildContext context) {
    return Scaffold(
      appBar: AppBar(
        title: Text(S.of(context).AddRideTitle),
        actions: <Widget>[
          StreamBuilder<bool>(
            initialData: false,
            stream: bloc.showDeleteSelectionStream,
            builder: (context, snapshot) {
              bool? show = snapshot.data;

              if (show == null || !show) {
                return const SizedBox.shrink();
              }

              return IconButton(
                icon: const Icon(Icons.delete_sweep),
                onPressed: bloc.onClearSelection,
              );
            },
          ),
        ],
      ),
      body: _buildBody(),
    );
  }

  Widget _buildIOSLayout(BuildContext context) {
    return CupertinoPageScaffold(
      navigationBar: CupertinoNavigationBar(
        transitionBetweenRoutes: false,
        trailing: StreamBuilder<bool>(
          initialData: false,
          stream: bloc.showDeleteSelectionStream,
          builder: (context, snapshot) {
            bool? show = snapshot.data;

            if (show == null || !show) {
              return const SizedBox.shrink();
            }

            return CupertinoIconButton(
              idleColor: CupertinoColors.destructiveRed,
              onPressedColor: Colors.red.shade300,
              icon: CupertinoIcons.xmark_rectangle_fill,
              onPressed: bloc.onClearSelection,
            );
          },
        ),
        middle: Text(S.of(context).AddRideTitle),
      ),
      child: SafeArea(
        child: _buildBody(),
      ),
    );
  }

  ///Build the calendar.
  Widget _buildCalendar() {
    return FutureBuilder<void>(
        future: bloc.loadExistingRidesFuture,
        builder: (context, snapshot) {
          if (snapshot.connectionState == ConnectionState.done) {
            if (snapshot.hasError) {
              return Center(
                child: Text(S.of(context).GenericError),
              );
            }

            return AddRideCalendar(bloc: bloc);
          }

          return const Center(
            child: PlatformAwareLoadingIndicator(),
          );
        });
  }

  void _onSubmit() async {
    await bloc.addRides().then((_) {
      ReloadDataProvider.of(context).reloadRides.value = true;
      Navigator.pop(context);
    }).catchError((e) {
      bloc.onError(e);
    });
  }

  @override
  void dispose() {
    bloc.dispose();
    super.dispose();
  }
}
