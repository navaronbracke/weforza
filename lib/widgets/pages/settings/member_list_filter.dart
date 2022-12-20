import 'dart:collection';

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
    return StreamBuilder<MemberFilterOption>(
      initialData: initialFilter,
      stream: stream,
      builder: (context, snapshot) {
        final currentFilter = snapshot.data!;

        return PlatformAwareWidget(
          android: (context) {
            final translator = S.of(context);

            return Padding(
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
            );
          },
          ios: (_) => _CupertinoMemberFilter(
            groupValue: currentFilter,
            onValueChanged: (MemberFilterOption? value) {
              if (value != null) {
                onChanged(value);
              }
            },
          ),
        );
      },
    );
  }
}

class _CupertinoMemberFilter extends StatefulWidget {
  const _CupertinoMemberFilter({
    required this.groupValue,
    required this.onValueChanged,
  });

  final MemberFilterOption groupValue;

  final void Function(MemberFilterOption?) onValueChanged;

  @override
  State<_CupertinoMemberFilter> createState() => _CupertinoMemberFilterState();
}

class _CupertinoMemberFilterState extends State<_CupertinoMemberFilter> {
  /// The map of options for the segmented control.
  /// This map preserves its insertion order,
  /// as that order is used to display the options.
  LinkedHashMap<MemberFilterOption, String> _labels = LinkedHashMap();

  /// The text painter that will measure the width of the widest label.
  final TextPainter _textPainter = TextPainter(
    maxLines: 1,
    textDirection: TextDirection.ltr,
  );

  /// The width of the widest label.
  double _widestLabelWidth = 0.0;

  void _computeWidestLabelWidth(TextStyle style) {
    double value = 0.0;

    for (final label in _labels.values) {
      if (label.isEmpty) {
        continue;
      }

      _textPainter.text = TextSpan(
        text: label,
        // The selected label has 500 font weight, which adds to the size.
        style: style.copyWith(fontWeight: FontWeight.w500),
      );
      _textPainter.layout();

      if (_textPainter.width > value) {
        value = _textPainter.width;
      }
    }

    _widestLabelWidth = value;
  }

  @override
  void didChangeDependencies() {
    super.didChangeDependencies();
    final translator = S.of(context);

    _labels = LinkedHashMap.from(<MemberFilterOption, String>{
      MemberFilterOption.all: translator.All,
      MemberFilterOption.active: translator.Active,
      MemberFilterOption.inactive: translator.Inactive,
    });

    _computeWidestLabelWidth(DefaultTextStyle.of(context).style);
  }

  @override
  Widget build(BuildContext context) {
    return CupertinoSlidingSegmentedControl<MemberFilterOption>(
      groupValue: widget.groupValue,
      onValueChanged: widget.onValueChanged,
      children: <MemberFilterOption, Widget>{
        for (final entry in _labels.entries)
          entry.key: SizedBox(
            width: _widestLabelWidth,
            child: Center(child: Text(entry.value)),
          ),
      },
    );
  }

  @override
  void dispose() {
    _textPainter.dispose();
    super.dispose();
  }
}
