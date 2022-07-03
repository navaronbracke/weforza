import 'package:flutter/material.dart';
import 'package:weforza/theme/app_theme.dart';
import 'package:weforza/widgets/common/member_name_and_alias.dart';

class UnresolvedOwnersListItem extends StatefulWidget {
  const UnresolvedOwnersListItem({
    Key? key,
    required this.isSelected,
    required this.onTap,
    required this.firstName,
    required this.lastName,
    required this.alias,
  }) : super(key: key);

  final bool Function() isSelected;
  final VoidCallback onTap;
  final String firstName;
  final String lastName;
  final String alias;

  @override
  UnresolvedOwnerListItemState createState() => UnresolvedOwnerListItemState();
}

class UnresolvedOwnerListItemState extends State<UnresolvedOwnersListItem> {
  late Color itemDecorationBackgroundColor;
  late TextStyle firstNameStyle;
  late TextStyle lastNameStyle;

  @override
  void initState() {
    super.initState();
    _setColors();
  }

  @override
  Widget build(BuildContext context) {
    return GestureDetector(
      behavior: HitTestBehavior.opaque,
      onTap: () {
        if (mounted) {
          widget.onTap();
          setState(() => _setColors());
        }
      },
      child: DecoratedBox(
        decoration: BoxDecoration(color: itemDecorationBackgroundColor),
        child: Padding(
          padding: const EdgeInsets.symmetric(horizontal: 10, vertical: 5),
          child: MemberNameAndAlias(
            firstNameStyle: firstNameStyle,
            lastNameStyle: lastNameStyle,
            firstName: widget.firstName,
            lastName: widget.lastName,
            alias: widget.alias,
          ),
        ),
      ),
    );
  }

  void _setColors() {
    if (widget.isSelected()) {
      itemDecorationBackgroundColor =
          ApplicationTheme.rideAttendeeSelectedBackgroundColor;
      firstNameStyle = ApplicationTheme.memberListItemFirstNameTextStyle
          .copyWith(color: Colors.white);
      lastNameStyle = ApplicationTheme.memberListItemLastNameTextStyle
          .copyWith(color: Colors.white);
    } else {
      itemDecorationBackgroundColor =
          ApplicationTheme.rideAttendeeUnSelectedBackgroundColor;
      firstNameStyle = ApplicationTheme.memberListItemFirstNameTextStyle;
      lastNameStyle = ApplicationTheme.memberListItemLastNameTextStyle;
    }
  }
}
