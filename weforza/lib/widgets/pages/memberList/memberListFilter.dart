import 'package:flutter/material.dart';
import 'package:flutter/cupertino.dart';
import 'package:weforza/generated/l10n.dart';
import 'package:weforza/widgets/platform/platformAwareWidget.dart';

/// This widget represents the filter at the top of the member list.
/// This filter allows selecting between active, inactive & all members.
class MemberListFilter extends StatefulWidget {
  MemberListFilter({
    @required this.onOptionSelected
  }): assert(onOptionSelected != null);

  final void Function(int option) onOptionSelected;

  @override
  _MemberListFilterState createState() => _MemberListFilterState();
}

class _MemberListFilterState extends State<MemberListFilter> with SingleTickerProviderStateMixin {

  /// The current selected option.
  int currentValue = 0;
  /// The tab controller for the material widget.
  TabController _tabController;

  @override
  void initState() {
    super.initState();
    _tabController = TabController(length: 3, vsync: this, initialIndex: currentValue);
  }

  @override
  Widget build(BuildContext context) {
    return PlatformAwareWidget(
      android: () => _buildAndroidWidget(context),
      ios: () => _buildIosWidget(context),
    );
  }

  Widget _buildAndroidWidget(BuildContext context){
    return TabBar(
      tabs: <Widget>[
        Text(S.of(context).MemberListFilterAll),
        Text(S.of(context).MemberListFilterActive),
        Text(S.of(context).MemberListFilterInactive),
      ],
      onTap: (int option){
        setState(() {
          currentValue = option;
          widget.onOptionSelected(currentValue);
        });
      },
      controller: _tabController,
    );
  }

  Widget _buildIosWidget(BuildContext context){
    return CupertinoSlidingSegmentedControl<int>(
      onValueChanged: (int option){
        setState(() {
          currentValue = option;
          widget.onOptionSelected(currentValue);
        });
      },
      children: {
        0: Text(S.of(context).MemberListFilterAll),
        1: Text(S.of(context).MemberListFilterActive),
        2: Text(S.of(context).MemberListFilterInactive)
      },
      groupValue: currentValue,
    );
  }

  @override
  void dispose() {
    _tabController.dispose();
    super.dispose();
  }
}

