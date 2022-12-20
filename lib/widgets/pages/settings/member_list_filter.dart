import 'package:flutter/cupertino.dart';
import 'package:flutter/material.dart';
import 'package:weforza/generated/l10n.dart';
import 'package:weforza/model/member_filter_option.dart';
import 'package:weforza/widgets/platform/platform_aware_widget.dart';

class MemberListFilter extends StatelessWidget {
  const MemberListFilter({
    required this.initialFilter,
    required this.onChanged,
    required this.stream,
    super.key,
  });

  final MemberFilterOption initialFilter;

  final void Function(MemberFilterOption value) onChanged;

  final Stream<MemberFilterOption> stream;

  @override
  Widget build(BuildContext context) {
    final translator = S.of(context);

    return StreamBuilder<MemberFilterOption>(
      initialData: initialFilter,
      stream: stream,
      builder: (context, snapshot) {
        final currentFilter = snapshot.data!;

        return PlatformAwareWidget(
          android: (_) => Padding(
            padding: const EdgeInsets.symmetric(vertical: 8),
            child: SegmentedButton<MemberFilterOption>(
              showSelectedIcon: false,
              segments: <ButtonSegment<MemberFilterOption>>[
                ButtonSegment(
                  icon: const Icon(Icons.people),
                  label: Text(translator.All),
                  value: MemberFilterOption.all,
                ),
                ButtonSegment(
                  icon: const Icon(Icons.directions_bike),
                  label: Text(translator.Active),
                  value: MemberFilterOption.active,
                ),
                ButtonSegment(
                  icon: const Icon(Icons.block),
                  label: Text(translator.Inactive),
                  value: MemberFilterOption.inactive,
                ),
              ],
              selected: <MemberFilterOption>{currentFilter},
              onSelectionChanged: (selectedSegments) {
                if (selectedSegments.isEmpty) {
                  return;
                }

                onChanged(selectedSegments.first);
              },
            ),
          ),
          ios: (_) => CupertinoSlidingSegmentedControl<MemberFilterOption>(
            groupValue: currentFilter,
            onValueChanged: (MemberFilterOption? value) {
              if (value != null) {
                onChanged(value);
              }
            },
            children: {
              MemberFilterOption.all: SizedBox(
                width: 88,
                child: Center(child: Text(translator.All)),
              ),
              MemberFilterOption.active: SizedBox(
                width: 88,
                child: Center(child: Text(translator.Active)),
              ),
              MemberFilterOption.inactive: SizedBox(
                width: 88,
                child: Center(child: Text(translator.Inactive)),
              ),
            },
          ),
        );
      },
    );
  }
}
