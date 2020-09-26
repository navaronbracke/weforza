import 'package:flutter/cupertino.dart';
import 'package:flutter/material.dart';
import 'package:weforza/generated/l10n.dart';
import 'package:weforza/model/member.dart';
import 'package:weforza/theme/appTheme.dart';
import 'package:weforza/widgets/platform/platformAwareWidget.dart';

class UnresolvedOwnersList extends StatelessWidget {
  UnresolvedOwnersList({
    @required this.items,
    @required this.itemBuilder,
    @required this.onButtonPressed,
  }): assert(
    items != null && items.isNotEmpty && itemBuilder != null
        && onButtonPressed != null
  );

  final List<Member> items;
  final Widget Function(Member member) itemBuilder;
  final void Function() onButtonPressed;

  @override
  Widget build(BuildContext context) {
    return Column(
      children: [
        Expanded(
          child: ListView.builder(
            itemBuilder: (context, index) => itemBuilder(items[index]),
            itemCount: items.length,
          ),
        ),
        Center(child: _buildButton(context)),
      ],
    );
  }

  Widget _buildButton(BuildContext context){
    return PlatformAwareWidget(
      android: () => Padding(
        padding: const EdgeInsets.symmetric(vertical: 10),
        child: FlatButton(
          child: Text(
            S.of(context).RideAttendeeScanningContinue,
            style: TextStyle(color: ApplicationTheme.primaryColor),
          ),
          onPressed: onButtonPressed,
        ),
      ),
      ios: () => Padding(
        padding: const EdgeInsets.only(bottom: 20, top: 10),
        child: CupertinoButton(
          child: Text(
            S.of(context).RideAttendeeScanningContinue,
            style: TextStyle(color: ApplicationTheme.primaryColor),
          ),
          onPressed: onButtonPressed,
        ),
      ),
    );
  }
}
