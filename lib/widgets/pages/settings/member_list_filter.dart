import 'package:flutter/cupertino.dart';
import 'package:flutter/material.dart';
import 'package:weforza/generated/l10n.dart';
import 'package:weforza/model/member_filter_option.dart';
import 'package:weforza/model/member_list_filter_delegate.dart';
import 'package:weforza/theme/app_theme.dart';
import 'package:weforza/widgets/platform/platform_aware_widget.dart';

class MemberListFilter extends StatefulWidget {
  const MemberListFilter({
    Key? key,
    required this.delegate,
  }) : super(key: key);

  final MemberListFilterDelegate delegate;

  @override
  MemberListFilterState createState() => MemberListFilterState();
}

class MemberListFilterState extends State<MemberListFilter> {
  @override
  Widget build(BuildContext context) {
    final translator = S.of(context);
    final currentValue = widget.delegate.memberListFilter;

    return Column(
      crossAxisAlignment: CrossAxisAlignment.start,
      children: [
        Text(
          translator.SettingsRiderFilterHeader,
          style: ApplicationTheme.settingsOptionHeaderStyle,
        ),
        Padding(
          padding: const EdgeInsets.only(
            left: 15,
            right: 15,
            top: 15,
            bottom: 10,
          ),
          child: PlatformAwareWidget(
            android: () => Row(
              children: [
                ChoiceChip(
                  label: Text(translator.All),
                  selected: currentValue == MemberFilterOption.all,
                  onSelected: (selected) {
                    if (selected) {
                      setState(() {
                        widget.delegate.onMemberListFilterChanged(
                          MemberFilterOption.all,
                        );
                      });
                    }
                  },
                ),
                Padding(
                  padding: const EdgeInsets.symmetric(horizontal: 10),
                  child: ChoiceChip(
                    label: Text(translator.Active),
                    selected: currentValue == MemberFilterOption.active,
                    onSelected: (selected) {
                      if (selected) {
                        setState(() {
                          widget.delegate.onMemberListFilterChanged(
                            MemberFilterOption.active,
                          );
                        });
                      }
                    },
                  ),
                ),
                ChoiceChip(
                  label: Text(translator.Inactive),
                  selected: currentValue == MemberFilterOption.inactive,
                  onSelected: (selected) {
                    if (selected) {
                      setState(() {
                        widget.delegate.onMemberListFilterChanged(
                          MemberFilterOption.inactive,
                        );
                      });
                    }
                  },
                ),
              ],
            ),
            ios: () => CupertinoSlidingSegmentedControl<MemberFilterOption>(
              groupValue: currentValue,
              onValueChanged: (MemberFilterOption? value) {
                if (value == null) return;

                setState(() {
                  widget.delegate.onMemberListFilterChanged(value);
                });
              },
              children: {
                MemberFilterOption.all: Text(translator.All.toUpperCase()),
                MemberFilterOption.active: Text(
                  translator.Active.toUpperCase(),
                ),
                MemberFilterOption.inactive: Text(
                  translator.Inactive.toUpperCase(),
                ),
              },
            ),
          ),
        ),
        PlatformAwareWidget(
          android: () => Text(
            translator.SettingsRiderFilterDescription,
            style:
                ApplicationTheme.settingsResetRideCalendarDescriptionTextStyle,
          ),
          ios: () => Text(
            translator.SettingsRiderFilterDescription,
            style: ApplicationTheme
                .settingsResetRideCalendarDescriptionTextStyle
                .copyWith(fontSize: 14),
          ),
        ),
      ],
    );
  }
}
