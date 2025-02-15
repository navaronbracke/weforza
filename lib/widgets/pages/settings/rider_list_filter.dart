import 'dart:collection';

import 'package:flutter/cupertino.dart';
import 'package:flutter/material.dart';
import 'package:weforza/generated/l10n.dart';
import 'package:weforza/model/rider/rider_filter_option.dart';
import 'package:weforza/model/settings/rider_filter_delegate.dart';
import 'package:weforza/widgets/platform/platform_aware_widget.dart';

class RiderListFilter extends StatelessWidget {
  const RiderListFilter({required this.delegate, super.key});

  /// The delegate that manages the value.
  final RiderFilterDelegate delegate;

  @override
  Widget build(BuildContext context) {
    return StreamBuilder<RiderFilterOption>(
      initialData: delegate.currentValue,
      stream: delegate.stream,
      builder: (context, snapshot) {
        final currentFilter = snapshot.data!;

        return PlatformAwareWidget(
          android: (context) {
            final translator = S.of(context);

            return Padding(
              padding: const EdgeInsets.symmetric(vertical: 8),
              child: SegmentedButton<RiderFilterOption>(
                showSelectedIcon: false,
                segments: <ButtonSegment<RiderFilterOption>>[
                  ButtonSegment(
                    icon: const Icon(Icons.people),
                    label: Text(translator.all),
                    value: RiderFilterOption.all,
                  ),
                  ButtonSegment(
                    icon: const Icon(Icons.directions_bike),
                    label: Text(translator.active),
                    value: RiderFilterOption.active,
                  ),
                  ButtonSegment(
                    icon: const Icon(Icons.block),
                    label: Text(translator.inactive),
                    value: RiderFilterOption.inactive,
                  ),
                ],
                selected: <RiderFilterOption>{currentFilter},
                onSelectionChanged: (selectedSegments) {
                  if (selectedSegments.isEmpty) {
                    return;
                  }

                  delegate.onValueChanged(selectedSegments.first);
                },
              ),
            );
          },
          ios: (_) {
            return _CupertinoRiderFilter(
              groupValue: currentFilter,
              onValueChanged: (RiderFilterOption? value) {
                if (value != null) {
                  delegate.onValueChanged(value);
                }
              },
            );
          },
        );
      },
    );
  }
}

class _CupertinoRiderFilter extends StatefulWidget {
  const _CupertinoRiderFilter({required this.groupValue, required this.onValueChanged});

  final RiderFilterOption groupValue;

  final void Function(RiderFilterOption?) onValueChanged;

  @override
  State<_CupertinoRiderFilter> createState() => _CupertinoRiderFilterState();
}

class _CupertinoRiderFilterState extends State<_CupertinoRiderFilter> {
  /// The map of options for the segmented control.
  /// This map preserves its insertion order,
  /// as that order is used to display the options.
  LinkedHashMap<RiderFilterOption, String> _labels = LinkedHashMap();

  /// The text painter that will measure the width of the widest label.
  final TextPainter _textPainter = TextPainter(maxLines: 1, textDirection: TextDirection.ltr);

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

    _labels = LinkedHashMap.from(<RiderFilterOption, String>{
      RiderFilterOption.all: translator.all,
      RiderFilterOption.active: translator.active,
      RiderFilterOption.inactive: translator.inactive,
    });

    _computeWidestLabelWidth(DefaultTextStyle.of(context).style);
  }

  @override
  Widget build(BuildContext context) {
    return CupertinoSlidingSegmentedControl<RiderFilterOption>(
      groupValue: widget.groupValue,
      onValueChanged: widget.onValueChanged,
      children: <RiderFilterOption, Widget>{
        for (final entry in _labels.entries)
          entry.key: SizedBox(width: _widestLabelWidth, child: Center(child: Text(entry.value))),
      },
    );
  }

  @override
  void dispose() {
    _textPainter.dispose();
    super.dispose();
  }
}
