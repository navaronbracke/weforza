import 'package:flutter/cupertino.dart';
import 'package:flutter/material.dart';
import 'package:flutter/widgets.dart';
import 'package:weforza/generated/l10n.dart';
import 'package:weforza/model/member.dart';
import 'package:weforza/widgets/common/genericError.dart';
import 'package:weforza/widgets/pages/rideDetails/rideDetailsAttendees/rideDetailsAttendeesListEmpty.dart';
import 'package:weforza/widgets/pages/rideDetails/rideDetailsAttendees/rideDetailsAttendeesListItem.dart';
import 'package:weforza/widgets/platform/cupertinoBottomBar.dart';
import 'package:weforza/widgets/platform/platformAwareLoadingIndicator.dart';
import 'package:weforza/widgets/platform/platformAwareWidget.dart';

class RideDetailsAttendeesList extends StatelessWidget {
  RideDetailsAttendeesList({
    required this.future,
    required this.scannedAttendees,
  });

  final Future<List<Member>>? future;
  final int? scannedAttendees;

  @override
  Widget build(BuildContext context) {
    return FutureBuilder<List<Member>>(
      future: future,
      builder: (context, snapshot) {
        if(snapshot.connectionState == ConnectionState.done){
          if (snapshot.hasError) {
            return GenericError(text: S.of(context).GenericError);
          } else {
            if (snapshot.data == null || snapshot.data!.isEmpty) {
              return RideDetailsAttendeesListEmpty();
            } else {
              final list = snapshot.data!;

              return Column(
                children: [
                  Expanded(
                    child: ListView.builder(
                      itemBuilder: (context, index) {
                        final member = list[index];
                        return RideDetailsAttendeesListItem(
                          firstName: member.firstname,
                          lastName: member.lastname,
                          alias: member.alias,
                        );
                      },
                      itemCount: snapshot.data!.length,
                    ),
                  ),
                  PlatformAwareWidget(
                    android: () => _buildAndroidLayout(context, list.length, scannedAttendees),
                    ios: () => _buildIosLayout(context, list.length, scannedAttendees),
                  ),
                ],
              );
            }
          }
        }else{
          return Center(child: PlatformAwareLoadingIndicator());
        }
      },
    );
  }

  Widget _buildAndroidLayout(BuildContext context, int total, int? scannedNumber){
    return BottomAppBar(
      child: Padding(
        padding: const EdgeInsets.symmetric(horizontal: 8),
        child: Row(
          children: [
            Tooltip(
              message: S.of(context).RideDetailsTotalAttendeesTooltip,
              child: const Icon(Icons.people, color: Colors.white),
            ),
            Padding(
              padding: const EdgeInsets.only(left: 4),
              child: Text("$total", style: TextStyle(color: Colors.white)),
            ),
            Expanded(child: Center()),
            Tooltip(
              message: S.of(context).RideDetailsScannedAttendeesTooltip,
              child: const Icon(Icons.bluetooth_searching, color: Colors.white),
            ),
            Padding(
              padding: const EdgeInsets.only(left: 4),
              child: Text(scannedNumber == null ? "?" : "$scannedNumber", style: TextStyle(color: Colors.white)),
            ),
          ],
        ),
      ),
    );
  }

  Widget _buildIosLayout(BuildContext context, int total, int? scannedNumber){
    return CupertinoBottomBar(
      child: Padding(
        padding: const EdgeInsets.symmetric(horizontal: 8),
        child: Row(
          children: [
            const Icon(
              CupertinoIcons.person_2_fill,
              color: CupertinoColors.activeBlue,
            ),
            Padding(
              padding: const EdgeInsets.only(left: 4),
              child: Text(
                "$total",
                style: TextStyle(color: CupertinoColors.activeBlue),
              ),
            ),
            Expanded(child: Center()),
            const Icon(
              Icons.bluetooth_searching,
              color: CupertinoColors.activeBlue,
            ),
            Padding(
              padding: const EdgeInsets.only(left: 4),
              child: Text(
                scannedNumber == null ? "?" : "$scannedNumber",
                style: TextStyle(color: CupertinoColors.activeBlue),
              ),
            ),
          ],
        ),
      ),
    );
  }
}
