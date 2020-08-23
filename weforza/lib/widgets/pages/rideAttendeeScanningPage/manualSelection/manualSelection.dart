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
    if(bloc.currentMembersList.isEmpty){
      return Center(
        child: ManualSelectionListEmpty(),
      );
    }else{
      return Column(
        children: <Widget>[
          Expanded(
            child: ListView.builder(
              itemBuilder: (context, index){
                final item = bloc.currentMembersList[index];
                return ManualSelectionListItem(
                  profileImageFuture: bloc.loadProfileImageFromDisk(item.profileImageFilePath),
                  firstName: item.firstname,
                  lastName: item.lastname,
                  phone: item.phone,
                  isSelected: () => bloc.isItemSelected(item),
                  onTap: (){
                    if(!bloc.isSaving.value){
                      bloc.onMemberSelected(item);
                    }
                  },
                );
              },
              itemCount: bloc.currentMembersList.length,
            ),
          ),
          ManualSelectionSubmit(
            isSaving: bloc.isSaving,
            onSave: () async => await bloc.saveRideAttendees(false,false).then((_){
              onRefreshAttendees();
              Navigator.of(context).pop();
            }, onError: (error){
              //do nothing
            }),
          ),
        ],
      );
    }
  }
}
