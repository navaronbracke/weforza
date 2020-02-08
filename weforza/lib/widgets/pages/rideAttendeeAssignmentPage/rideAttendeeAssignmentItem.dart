
import 'package:flutter/material.dart';
import 'package:flutter/widgets.dart';
import 'package:weforza/blocs/rideAttendeeAssignmentItemBloc.dart';
import 'package:weforza/theme/appTheme.dart';
import 'package:weforza/widgets/custom/profileImage/profileImage.dart';
import 'package:weforza/widgets/platform/platformAwareWidget.dart';

class RideAttendeeAssignmentItem extends StatefulWidget {
  RideAttendeeAssignmentItem(this.bloc): assert(bloc != null);

  final RideAttendeeAssignmentItemBloc bloc;

  @override
  _RideAttendeeAssignmentItemState createState() => _RideAttendeeAssignmentItemState();
}

class _RideAttendeeAssignmentItemState extends State<RideAttendeeAssignmentItem> {

  @override
  Widget build(BuildContext context) => PlatformAwareWidget(
    android: () => _buildAndroidWidget(context),
    ios: () => _buildIosWidget(context),
  );

  Widget _buildAndroidWidget(BuildContext context) {
    return GestureDetector(
      onTap: (){
        setState(() {
          widget.bloc.onSelected();
        });
      },
      child: Card(
        color: widget.bloc.selected ? ApplicationTheme.rideAttendeeSelectedBackgroundColor : ApplicationTheme.rideAttendeeUnSelectedBackgroundColor,
        elevation: 2,
        child: Container(
          child: Padding(
            padding: EdgeInsets.all(10),
            child: Row(
              children: <Widget>[
                ProfileImage(
                    widget.bloc.image,
                    ApplicationTheme.profileImagePlaceholderIconColor,
                    widget.bloc.selected ? ApplicationTheme.rideAttendeeSelectedPlaceholderBackgroundColor : ApplicationTheme.rideAttendeeUnselectedPlaceholderBackgroundColor,
                    Icons.person,
                    40
                ),
                SizedBox(width: 5),
                Column(
                  crossAxisAlignment: CrossAxisAlignment.start,
                  children: <Widget>[
                    Text(
                        widget.bloc.firstName,
                        style: ApplicationTheme.memberListItemFirstNameTextStyle.copyWith(
                            color: widget.bloc.selected ? ApplicationTheme.rideAttendeeSelectedFontColor : ApplicationTheme.rideAttendeeUnSelectedFontColor),
                        overflow: TextOverflow.ellipsis
                    ),
                    SizedBox(height: 4),
                    Text(widget.bloc.lastName,
                        style: ApplicationTheme.memberListItemFirstNameTextStyle.copyWith(
                            color: widget.bloc.selected ? ApplicationTheme.rideAttendeeSelectedFontColor : ApplicationTheme.rideAttendeeUnSelectedFontColor),
                        overflow: TextOverflow.ellipsis
                    ),
                  ],
                ),
              ],
            ),
          ),
        ),
      ),
    );
  }


  Widget _buildIosWidget(BuildContext context) {
    return GestureDetector(
      onTap: (){
        setState(() {
          widget.bloc.onSelected();
        });
      },
      child: Padding(
        padding: const EdgeInsets.symmetric(vertical: 2),
        child: Container(
          decoration: BoxDecoration(
            color: widget.bloc.selected ? ApplicationTheme.rideAttendeeSelectedBackgroundColor : ApplicationTheme.rideAttendeeUnSelectedBackgroundColor,
          ),
          child: Padding(
            padding: EdgeInsets.all(10),
            child: Row(
              children: <Widget>[
                ProfileImage(
                    widget.bloc.image,
                    ApplicationTheme.profileImagePlaceholderIconColor,
                    widget.bloc.selected ? ApplicationTheme.rideAttendeeSelectedPlaceholderBackgroundColor : ApplicationTheme.rideAttendeeUnselectedPlaceholderBackgroundColor,
                    Icons.person,
                    40
                ),
                SizedBox(width: 5),
                Column(
                  crossAxisAlignment: CrossAxisAlignment.start,
                  children: <Widget>[
                    Text(
                        widget.bloc.firstName,
                        style: ApplicationTheme.memberListItemFirstNameTextStyle.copyWith(
                            color: widget.bloc.selected ? ApplicationTheme.rideAttendeeSelectedFontColor : ApplicationTheme.rideAttendeeUnSelectedFontColor),
                        overflow: TextOverflow.ellipsis
                    ),
                    SizedBox(height: 4),
                    Text(widget.bloc.lastName,
                        style: ApplicationTheme.memberListItemFirstNameTextStyle.copyWith(
                            color: widget.bloc.selected ? ApplicationTheme.rideAttendeeSelectedFontColor : ApplicationTheme.rideAttendeeUnSelectedFontColor),
                        overflow: TextOverflow.ellipsis
                    ),
                  ],
                ),
              ],
            ),
          ),
        ),
      ),
    );
  }
}
