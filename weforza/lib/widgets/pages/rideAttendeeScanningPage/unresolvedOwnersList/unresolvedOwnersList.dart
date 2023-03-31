import 'package:flutter/cupertino.dart';
import 'package:flutter/material.dart';
import 'package:weforza/generated/l10n.dart';
import 'package:weforza/model/member.dart';
import 'package:weforza/theme/appTheme.dart';
import 'package:weforza/widgets/platform/platformAwareLoadingIndicator.dart';
import 'package:weforza/widgets/platform/platformAwareWidget.dart';

class UnresolvedOwnersList extends StatelessWidget {
  UnresolvedOwnersList({
    @required this.future,
    @required this.itemBuilder,
    @required this.onButtonPressed,
  }): assert(future != null && itemBuilder != null && onButtonPressed != null);

  final Future<List<Member>> future;
  final Widget Function(Member member) itemBuilder;
  final void Function() onButtonPressed;

  @override
  Widget build(BuildContext context) {
    return FutureBuilder<List<Member>>(
      future: future,
      builder: (context, snapshot){
        if(snapshot.connectionState == ConnectionState.done){
          return Column(
            children: [
              Padding(
                padding: const EdgeInsets.only(bottom: 2),
                child: Center(
                  child: Text(
                    S.of(context).RideAttendeeScanningUnresolvedOwnersListTooltip,
                    style: ApplicationTheme.rideAttendeeMultipleOwnersListTooltipStyle,
                    softWrap: true, textAlign: TextAlign.center,
                  )
                ),
              ),
              Expanded(
                child: ListView.builder(
                  itemBuilder: (context, index) => itemBuilder(snapshot.data[index]),
                  itemCount: snapshot.data.length,
                ),
              ),
              Center(child: _buildButton(context)),
            ],
          );
        }else{
          return Center(child: PlatformAwareLoadingIndicator());
        }
      },
    );
  }

  Widget _buildButton(BuildContext context){
    return PlatformAwareWidget(
      android: () => Padding(
        padding: const EdgeInsets.symmetric(vertical: 10),
        child: TextButton(
          child: Text(S.of(context).RideAttendeeScanningContinue),
          onPressed: onButtonPressed,
        ),
      ),
      ios: () => Padding(
        padding: const EdgeInsets.only(bottom: 20, top: 10),
        child: CupertinoButton(
          child: Text(
            S.of(context).RideAttendeeScanningContinue,
            style: TextStyle(color: ApplicationTheme.primaryColor),
          ),
          onPressed: onButtonPressed,
        ),
      ),
    );
  }
}
