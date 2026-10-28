import 'dart:collection';

import 'package:flutter/cupertino.dart';
import 'package:flutter/material.dart';
import 'package:weforza/generated/l10n.dart';
import 'package:weforza/model/rider/rider_list_display_mode.dart';
import 'package:weforza/model/settings/rider_list_display_mode_delegate.dart';
import 'package:weforza/widgets/platform/platform_aware_widget.dart';

class RiderListDisplayModeOption extends StatelessWidget {
  const new({required this.delegate, super.key});

  /// The delegate that manages the value.
  final RiderListDisplayModeDelegate delegate;

  @override
  Widget build(BuildContext context) {
    return ValueListenableBuilder<RiderListDisplayMode>(
      valueListenable: delegate.listenable,
      builder: (context, currentFilter, _) => PlatformAwareWidget(
        android: (context) {
          final translator = S.of(context);

          return Padding(
            padding: const EdgeInsets.symmetric(vertical: 8),
            child: SegmentedButton<RiderListDisplayMode>(
              showSelectedIcon: false,
              segments: <ButtonSegment<RiderListDisplayMode>>[
                ButtonSegment(icon: const Icon(Icons.people), label: Text(translator.all), value: .all),
                ButtonSegment(icon: const Icon(Icons.directions_bike), label: Text(translator.active), value: .active),
                ButtonSegment(icon: const Icon(Icons.block), label: Text(translator.inactive), value: .inactive),
              ],
              selected: <RiderListDisplayMode>{currentFilter},
              onSelectionChanged: (selectedSegments) {
                if (selectedSegments.isEmpty) {
                  return;
                }

                delegate.onValueChanged(selectedSegments.first);
              },
            ),
          );
        },
        ios: (_) => _CupertinoRiderDisplayMode(
          groupValue: currentFilter,
          onValueChanged: (RiderListDisplayMode? value) {
            if (value != null) {
              delegate.onValueChanged(value);
            }
          },
        ),
      ),
    );
  }
}

class _CupertinoRiderDisplayMode extends StatefulWidget {
  const new({required this.groupValue, required this.onValueChanged});

  final RiderListDisplayMode groupValue;

  final void Function(RiderListDisplayMode?) onValueChanged;

  @override
  State<_CupertinoRiderDisplayMode> createState() => _CupertinoRiderDisplayModeState();
}

class _CupertinoRiderDisplayModeState extends State<_CupertinoRiderDisplayMode> {
  /// The map of options for the segmented control.
  /// This map preserves its insertion order,
  /// as that order is used to display the options.
  LinkedHashMap<RiderListDisplayMode, String> _labels = LinkedHashMap();

  /// The text painter that will measure the width of the widest label.
  final TextPainter _textPainter = TextPainter(maxLines: 1, textDirection: .ltr);

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
        style: style.copyWith(fontWeight: .w500),
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

    _labels = LinkedHashMap.from(<RiderListDisplayMode, String>{
      .all: translator.all,
      .active: translator.active,
      .inactive: translator.inactive,
    });

    _computeWidestLabelWidth(DefaultTextStyle.of(context).style);
  }

  @override
  Widget build(BuildContext context) {
    return CupertinoSlidingSegmentedControl<RiderListDisplayMode>(
      groupValue: widget.groupValue,
      onValueChanged: widget.onValueChanged,
      children: <RiderListDisplayMode, Widget>{
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
