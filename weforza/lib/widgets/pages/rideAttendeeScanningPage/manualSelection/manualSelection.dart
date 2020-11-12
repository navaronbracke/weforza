import 'package:flutter/widgets.dart';
import 'package:weforza/generated/l10n.dart';
import 'package:weforza/model/member.dart';
import 'package:weforza/widgets/common/genericError.dart';
import 'package:weforza/widgets/pages/rideAttendeeScanningPage/manualSelection/manualSelectionListEmpty.dart';
import 'package:weforza/widgets/platform/platformAwareLoadingIndicator.dart';

class RideAttendeeManualSelection extends StatelessWidget {
  RideAttendeeManualSelection({
    @required this.future,
    @required this.itemBuilder,
    @required this.saveButtonBuilder
  }): assert(
    future != null && itemBuilder != null && saveButtonBuilder != null
  );

  final Future<List<Member>> future;
  final Widget Function(Member item) itemBuilder;
  final Widget Function(BuildContext context) saveButtonBuilder;

  @override
  Widget build(BuildContext context) {
    return FutureBuilder<List<Member>>(
      future: future,
      builder: (context, snapshot){
        if(snapshot.connectionState == ConnectionState.done){
          if(snapshot.hasError){
            return GenericError(text: S.of(context).GenericError);
          }else {
            if(snapshot.data.isEmpty){
              return ManualSelectionListEmpty();
            }

            return Column(
              children: <Widget>[
                Expanded(
                  child: ListView.builder(
                    itemBuilder: (context, index) => itemBuilder(snapshot.data[index]),
                    itemCount: snapshot.data.length,
                  ),
                ),
                saveButtonBuilder(context),
              ],
            );
          }
        }else{
          return Center(child: PlatformAwareLoadingIndicator());
        }
      },
    );
  }
}
