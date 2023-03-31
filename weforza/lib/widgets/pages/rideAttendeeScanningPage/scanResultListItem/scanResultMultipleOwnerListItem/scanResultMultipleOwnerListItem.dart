
import 'package:flutter/foundation.dart';
import 'package:flutter/material.dart';
import 'package:weforza/model/member.dart';
import 'package:weforza/widgets/pages/rideAttendeeScanningPage/scanResultListItem/scanResultMultipleOwnerListItem/scanResultMultipleOwnerListItemHeader.dart';

class ScanResultMultipleOwnerListItem extends StatefulWidget {
  ScanResultMultipleOwnerListItem({
    @required this.owners,
    @required this.choiceRequired,//TODO emit true/false during onSaveAttendees
    @required this.menuEnabled,
    @required this.menuBuilder
  }): assert(
    owners != null && owners.isNotEmpty && menuBuilder != null
        && choiceRequired != null && menuEnabled != null
  );

  final bool choiceRequired;

  final bool menuEnabled;

  /// These are the choices that the user can make in the expansion menu.
  final List<Member> owners;

  final Widget Function(Animation<double> animation) menuBuilder;

  @override
  _ScanResultMultipleOwnerListItemState createState() => _ScanResultMultipleOwnerListItemState();
}

class _ScanResultMultipleOwnerListItemState extends State<ScanResultMultipleOwnerListItem> with SingleTickerProviderStateMixin {

  /// The owner that was chosen by the user.
  /// Is initially null, since the user starts off with having to make a choice.
  Member owner;

  /// The animation controller that drives the arrow rotation & expansion panel height transition.
  AnimationController _animationController;

  /// The animation for the dropdown arrow.
  Animation<double> _arrowAnimation;

  /// The animation for the dropdown menu.
  /// It is separate, since the arrow doesn't need a curve.
  Animation<double> _menuAnimation;

  @override
  void initState() {
    super.initState();
    _animationController = AnimationController(vsync: this, duration: Duration(milliseconds: 200));
    _arrowAnimation = Tween<double>(begin: 0, end: 1).animate(_animationController);
    _menuAnimation = Tween<double>(begin: 0, end: 1).animate(_animationController);
  }

  @override
  Widget build(BuildContext context) {
    return Column(
      children: [
        _buildHeader(),
        widget.menuBuilder(_menuAnimation),
      ],
    );
  }

  Widget _buildHeader(){
    return ScanResultMultipleOwnerListItemHeader(
      choiceRequired: widget.choiceRequired,
      animation: _arrowAnimation,
      onTap: widget.menuEnabled ? _onHeaderTapped: (){},
      title: getTitle(),
      menuEnabled: widget.menuEnabled,
    );
  }

  String getTitle(){
    if(owner == null) return null;

    if(owner.alias.isEmpty) return "${owner.firstname} ${owner.lastname}";

    return "${owner.firstname} ${owner.alias} ${owner.lastname}";
  }

  /// Opens or closes the choices menu.
  void _onHeaderTapped(){
    if(_animationController.isDismissed){
      _animationController.forward();
    }else if(_animationController.isCompleted){
      _animationController.reverse();
    }
  }

  @override
  void dispose() {
    _animationController.dispose();
    super.dispose();
  }
}
