import 'package:flutter/cupertino.dart';
import 'package:flutter/material.dart';
import 'package:flutter/widgets.dart';
import 'package:weforza/widgets/platform/platformAwareWidget.dart';

/// This widget resembles the toggle switch for the 'active' state of a member.
class MemberActiveToggle extends StatelessWidget {
  MemberActiveToggle({
    @required this.label,
    @required this.stream,
    @required this.onChanged,
    @required this.onErrorBuilder,
    @required this.initialValue
  }): assert(
    label != null && label.isNotEmpty && onChanged != null
        && onErrorBuilder != null && initialValue != null
  );

  final bool initialValue;
  final String label;
  final Stream<bool> stream;
  final void Function(bool value) onChanged;
  final Widget Function() onErrorBuilder;

  @override
  Widget build(BuildContext context) {
    return Row(
      children: [
        Text(label),
        Padding(
          padding: const EdgeInsets.only(left: 5),
          child: StreamBuilder<bool>(
            stream: stream,
            initialData: initialValue,
            builder: (context, snapshot){
              if(snapshot.hasError){
                return onErrorBuilder();
              }

              return PlatformAwareWidget(
                android: () => Switch(
                  value: snapshot.data,
                  onChanged: onChanged,
                ),
                ios: () => CupertinoSwitch(
                  value: snapshot.data,
                  onChanged: onChanged,
                ),
              );
            },
          ),
        ),
      ],
    );
  }
}
