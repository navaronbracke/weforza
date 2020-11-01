import 'package:flutter/material.dart';
import 'package:flutter/cupertino.dart';
import 'package:weforza/generated/l10n.dart';
import 'package:weforza/model/memberFilterOption.dart';
import 'package:weforza/theme/appTheme.dart';
import 'package:weforza/widgets/platform/platformAwareWidget.dart';

class MemberListFilterItem {
  MemberListFilterItem({
    @required this.value,
    @required this.label,
    @required this.icon
  }): assert(
    label != null && label.isNotEmpty && value != null && icon != null
  );

  final MemberFilterOption value;
  final String label;
  final IconData icon;
}

/// This widget represents the filter at the top of the member list.
/// This filter allows selecting between active, inactive & all members.
class MemberListFilter extends StatefulWidget {
  MemberListFilter({
    @required this.onOptionSelected,
    @required this.items
  }): assert(onOptionSelected != null && items != null && items.isNotEmpty);

  final void Function(int option) onOptionSelected;
  final List<MemberListFilterItem> items;

  @override
  _MemberListFilterState createState() => _MemberListFilterState();
}

class _MemberListFilterState extends State<MemberListFilter> {

  /// The current selected option.
  int currentValue = 0;

  void _onOptionSelected(MemberFilterOption option){
    if(option == null || option.index == currentValue){
      return;
    }else {
      setState(() {
        currentValue = option.index;
        widget.onOptionSelected(currentValue);
      });
    }
  }

  @override
  Widget build(BuildContext context) {
    return Padding(
      padding: const EdgeInsets.symmetric(horizontal: 5),
      child: Row(
        children: [
          PlatformAwareWidget(
            android: () => _buildAndroidWidget(context),
            ios: () => _buildIosWidget(context),
          ),
          Expanded(child: Center()),
          Text(widget.items[currentValue].label)
        ],
      ),
    );
  }

  Widget _buildAndroidWidget(BuildContext context){
    final items = widget.items.map((item) {
      return ListTile(
          title: Text(item.label),
          leading: Icon(item.icon),
          onTap: () => Navigator.of(context).pop(item.value)
      );
    }).toList();

    return FlatButton.icon(
      onPressed: () async {
          final option = await showModalBottomSheet<MemberFilterOption>(
              context: context,
              builder: (context) => Column(children: items, mainAxisSize: MainAxisSize.min)
          );

          _onOptionSelected(option);
      },
      icon: Icon(Icons.filter_alt, color: ApplicationTheme.primaryColor),
      label: Text(
          S.of(context).Filter,
          style: TextStyle(color: ApplicationTheme.primaryColor)
      ),
    );
  }

  Widget _buildIosWidget(BuildContext context){
    final items = widget.items.map((item) {
      return CupertinoActionSheetAction(
        child: Row(
          mainAxisSize: MainAxisSize.min,
          children: [
            Padding(
              padding: const EdgeInsets.only(right: 5),
              child: Icon(item.icon),
            ),
            Text(item.label),
          ],
        ),
        onPressed: () => Navigator.of(context).pop(item.value),
      );
    }).toList();

    return CupertinoButton(
      child: Row(
        mainAxisSize: MainAxisSize.min,
        children: [
          Padding(
            padding: const EdgeInsets.only(right: 5),
            child: Icon(Icons.filter_alt),
          ),
          Text(S.of(context).Filter),
        ],
      ),
      onPressed: () async {
        final option = await showCupertinoModalPopup<MemberFilterOption>(context: context, builder: (context){
          return CupertinoActionSheet(
            actions: items,
            cancelButton: CupertinoActionSheetAction(
              child: Text(S.of(context).Cancel),
              onPressed: () => Navigator.of(context).pop(),
            ),
          );
        });

        _onOptionSelected(option);
      },
    );
  }
}