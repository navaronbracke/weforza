import 'package:flutter/material.dart';
import 'package:weforza/generated/l10n.dart';
import 'package:weforza/theme/appTheme.dart';

class ScanResultMultipleOwnerListItemHeader extends StatelessWidget {
  ScanResultMultipleOwnerListItemHeader({
    @required this.onTap,
    @required this.choiceRequired,
    @required this.animation,
    @required this.title
  }): assert(
    onTap != null && choiceRequired != null && animation != null
  );

  /// The on tap function for tapping the header.
  final void Function() onTap;

  final bool choiceRequired;

  /// Is null when no owner is selected.
  final String title;

  final Animation<double> animation;

  @override
  Widget build(BuildContext context) {
    return GestureDetector(
      onTap: onTap,
      child: Container(
        decoration: BoxDecoration(
            color: choiceRequired ? ApplicationTheme.rideAttendeeScanResultOwnerChoiceRequiredBackgroundColor: null
        ),
        child: Padding(
          padding: const EdgeInsets.all(5),
          child: Row(
            children: [
              Expanded(
                child: _buildTitle(context),
              ),
              Padding(
                padding: const EdgeInsets.only(left: 5),
                child: SizedBox(
                  width: 30,
                  height: 30,
                  child: Center(
                    child: _buildHeaderIcon(choiceRequired),
                  ),
                ),
              ),
            ],
          ),
        ),
      )
    );
  }

  Widget _buildHeaderIcon(bool required){
    return RotationTransition(
      turns: animation,
      child: Icon(
          Icons.keyboard_arrow_down,
          color: required ? ApplicationTheme.rideAttendeeScanResultOwnerChoiceRequiredBackgroundColor : null,
      ),
    );
  }

  Widget _buildTitle(BuildContext context){
    if(title == null){
      return Text(
        S.of(context).RideAttendeeScanningScanResultMultipleOwnersPickAChoiceLabel,
        style: ApplicationTheme.rideAttendeeScanResultMultipleOwnerChoiceLabelStyle.copyWith(
          color: choiceRequired ? ApplicationTheme.rideAttendeeScanResultOwnerChoiceRequiredFontColor : null
        ),
      );
    }else{
      return Text(title);
    }
  }
}
