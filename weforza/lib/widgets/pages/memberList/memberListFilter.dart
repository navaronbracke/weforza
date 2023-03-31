import 'package:flutter/material.dart';
import 'package:flutter/cupertino.dart';
import 'package:weforza/generated/l10n.dart';
import 'package:weforza/model/memberFilterOption.dart';
import 'package:weforza/theme/appTheme.dart';
import 'package:weforza/widgets/platform/platformAwareWidget.dart';

/// This class wraps the data for the filter widget.
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
class MemberListFilter extends StatelessWidget {
  MemberListFilter({
    @required this.stream,
    @required this.onFilterChanged,
    @required this.items,
  }): assert(
    stream != null && onFilterChanged != null
        && items != null && items.isNotEmpty
  );

  final Stream<MemberFilterOption> stream;
  final void Function(MemberFilterOption filterOption) onFilterChanged;
  final List<MemberListFilterItem> items;

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
          StreamBuilder<MemberFilterOption>(
            initialData: MemberFilterOption.ALL,
            stream: stream,
            builder: (context, snapshot){
              switch(snapshot.data){
                case MemberFilterOption.ACTIVE: return Text(S.of(context).Active);
                case MemberFilterOption.INACTIVE: return Text(S.of(context).Inactive);
                default: return Text(S.of(context).All);
              }
            },
          ),
        ],
      ),
    );
  }

  Widget _buildAndroidWidget(BuildContext context){
    final options = items.map((item) {
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
            builder: (context) => Column(children: options, mainAxisSize: MainAxisSize.min)
        );

        onFilterChanged(option);
      },
      icon: Icon(Icons.filter_alt, color: ApplicationTheme.primaryColor),
      label: Text(
          S.of(context).Filter,
          style: TextStyle(color: ApplicationTheme.primaryColor)
      ),
    );
  }

  Widget _buildIosWidget(BuildContext context){
    final options = items.map((item) {
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
            actions: options,
            cancelButton: CupertinoActionSheetAction(
              child: Text(S.of(context).Cancel),
              onPressed: () => Navigator.of(context).pop(),
            ),
          );
        });

        onFilterChanged(option);
      },
    );
  }
}