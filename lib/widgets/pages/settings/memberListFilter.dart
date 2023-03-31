
import 'package:flutter/cupertino.dart';
import 'package:flutter/material.dart';
import 'package:weforza/generated/l10n.dart';
import 'package:weforza/model/memberFilterOption.dart';
import 'package:weforza/theme/appTheme.dart';
import 'package:weforza/widgets/platform/platformAwareWidget.dart';

class MemberListFilter extends StatefulWidget {
  MemberListFilter({
    required this.getValue,
    required this.onChanged,
  });

  final void Function(MemberFilterOption value) onChanged;
  final MemberFilterOption Function() getValue;

  @override
  _MemberListFilterState createState() => _MemberListFilterState();
}

class _MemberListFilterState extends State<MemberListFilter> {

  @override
  Widget build(BuildContext context) {
    final currentValue = widget.getValue();

    return Column(
      crossAxisAlignment: CrossAxisAlignment.start,
      children: [
        Text(
          S.of(context).SettingsRiderFilterHeader,
          style: ApplicationTheme.settingsOptionHeaderStyle,
        ),
        Padding(
          padding: const EdgeInsets.only(
            left: 15, right: 15, top: 15, bottom: 10,
          ),
          child: PlatformAwareWidget(
            android: () => Row(
              children: [
                ChoiceChip(
                  label: Text(S.of(context).All),
                  selected: currentValue == MemberFilterOption.ALL,
                  onSelected: (selected){
                    if(selected){
                      setState(() {
                        widget.onChanged(MemberFilterOption.ALL);
                      });
                    }
                  },
                ),
                Padding(
                  padding: const EdgeInsets.symmetric(horizontal: 10),
                  child: ChoiceChip(
                    label: Text(S.of(context).Active),
                    selected: currentValue == MemberFilterOption.ACTIVE,
                    onSelected: (selected){
                      if(selected){
                        setState(() {
                          widget.onChanged(MemberFilterOption.ACTIVE);
                        });
                      }
                    },
                  ),
                ),
                ChoiceChip(
                  label: Text(S.of(context).Inactive),
                  selected: currentValue == MemberFilterOption.INACTIVE,
                  onSelected: (selected){
                    if(selected){
                      setState(() {
                        widget.onChanged(MemberFilterOption.INACTIVE);
                      });
                    }
                  },
                ),
              ],
            ),
            ios: () => CupertinoSlidingSegmentedControl<MemberFilterOption>(
              groupValue: currentValue,
              onValueChanged: (MemberFilterOption? value){
                // Should not happen as we have an initial value.
                if(value == null) return;

                setState((){
                  widget.onChanged(value);
                });
              },
              children: {
                MemberFilterOption.ALL: Text(S.of(context).All.toUpperCase()),
                MemberFilterOption.ACTIVE: Text(S.of(context).Active.toUpperCase()),
                MemberFilterOption.INACTIVE: Text(S.of(context).Inactive.toUpperCase()),
              },
            ),
          ),
        ),
        PlatformAwareWidget(
          android: () => Text(
            S.of(context).SettingsRiderFilterDescription,
            style: ApplicationTheme.settingsResetRideCalendarDescriptionTextStyle,
          ),
          ios: () => Text(
            S.of(context).SettingsRiderFilterDescription,
            style: ApplicationTheme.settingsResetRideCalendarDescriptionTextStyle.copyWith(fontSize: 14),
          ),
        ),
      ],
    );
  }
}
