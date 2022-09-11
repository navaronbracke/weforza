import 'package:flutter/cupertino.dart';
import 'package:flutter/material.dart';
import 'package:weforza/generated/l10n.dart';
import 'package:weforza/model/member_filter_option.dart';
import 'package:weforza/theme/app_theme.dart';
import 'package:weforza/widgets/platform/platform_aware_widget.dart';

class MemberListFilter extends StatelessWidget {
  const MemberListFilter({
    super.key,
    required this.initialFilter,
    required this.onChanged,
    required this.stream,
  });

  final MemberFilterOption initialFilter;

  final void Function(MemberFilterOption value) onChanged;

  final Stream<MemberFilterOption> stream;

  @override
  Widget build(BuildContext context) {
    final translator = S.of(context);

    return Column(
      mainAxisSize: MainAxisSize.min,
      crossAxisAlignment: CrossAxisAlignment.start,
      children: [
        Text(
          translator.SettingsRiderFilterHeader,
          style: ApplicationTheme.settingsOptionHeaderStyle,
        ),
        Padding(
          padding: const EdgeInsets.fromLTRB(12, 12, 12, 8),
          child: StreamBuilder<MemberFilterOption>(
            initialData: initialFilter,
            stream: stream,
            builder: (context, snapshot) {
              final currentFilter = snapshot.data!;

              return PlatformAwareWidget(
                android: () => Row(
                  children: [
                    ChoiceChip(
                      label: Text(translator.All),
                      selected: currentFilter == MemberFilterOption.all,
                      onSelected: (selected) {
                        if (selected) {
                          onChanged(MemberFilterOption.all);
                        }
                      },
                    ),
                    Padding(
                      padding: const EdgeInsets.symmetric(horizontal: 8),
                      child: ChoiceChip(
                        label: Text(translator.Active),
                        selected: currentFilter == MemberFilterOption.active,
                        onSelected: (selected) {
                          if (selected) {
                            onChanged(MemberFilterOption.active);
                          }
                        },
                      ),
                    ),
                    ChoiceChip(
                      label: Text(translator.Inactive),
                      selected: currentFilter == MemberFilterOption.inactive,
                      onSelected: (selected) {
                        if (selected) {
                          onChanged(MemberFilterOption.inactive);
                        }
                      },
                    ),
                  ],
                ),
                ios: () => CupertinoSlidingSegmentedControl<MemberFilterOption>(
                  groupValue: currentFilter,
                  onValueChanged: (MemberFilterOption? value) {
                    if (value != null) {
                      onChanged(value);
                    }
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
              );
            },
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
