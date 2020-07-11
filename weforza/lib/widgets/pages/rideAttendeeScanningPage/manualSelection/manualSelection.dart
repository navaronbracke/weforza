import 'package:flutter/widgets.dart';
import 'package:weforza/blocs/attendeeScanningBloc.dart';
import 'package:weforza/widgets/pages/rideAttendeeScanningPage/manualSelection/manualSelectionListEmpty.dart';
import 'package:weforza/widgets/pages/rideAttendeeScanningPage/manualSelection/manualSelectionListItem.dart';
import 'package:weforza/widgets/pages/rideAttendeeScanningPage/manualSelection/manualSelectionSubmit.dart';

class RideAttendeeManualSelection extends StatelessWidget {
  RideAttendeeManualSelection({
    @required this.bloc,
    @required this.onRefreshAttendees,
  }): assert(bloc != null && onRefreshAttendees != null);

  final AttendeeScanningBloc bloc;
  final void Function() onRefreshAttendees;

  @override
  Widget build(BuildContext context) {
    return Column(
      children: <Widget>[
        Expanded(
          child: _buildManualSelectionList(),
        ),
        ManualSelectionSubmit(
          isSaving: bloc.isSaving,
          onSave: () async => await bloc.saveRideAttendees(false).then((_){
            onRefreshAttendees();
            Navigator.of(context).pop();
          }, onError: (error){
            //do nothing
          }),
        ),
      ],
    );
  }

  Widget _buildManualSelectionList(){
    if(bloc.currentMembersList.isEmpty){
      return Center(
        child: ManualSelectionListEmpty(),
      );
    }else{
      return ListView.builder(
        itemBuilder: (context, index){
          final item = bloc.currentMembersList[index];
          return ManualSelectionListItem(
            profileImageFuture: bloc.loadProfileImageFromDisk(item.profileImageFilePath),
            canSelect: () => !bloc.isSaving.value,
            firstName: item.firstname,
            lastName: item.lastname,
            isSelected: () => bloc.isItemSelected(item),
            onTap: () => bloc.addMember(item),
          );
        },
        itemCount: bloc.currentMembersList.length,
      );
    }
  }
}
