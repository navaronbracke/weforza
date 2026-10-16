import 'package:flutter/cupertino.dart';
import 'package:flutter/foundation.dart' show ValueListenable;
import 'package:flutter/material.dart';
import 'package:weforza/model/export/export_file_format.dart';
import 'package:weforza/widgets/platform/platform_aware_widget.dart';

/// This widget represents an export file format selection.
class ExportFileFormatSelection extends StatelessWidget {
  const ExportFileFormatSelection({required this.onFormatSelected, required this.listenable, super.key});

  /// The function that handles a change in the selection.
  final void Function(ExportFileFormat? value) onFormatSelected;

  /// The [ValueListenable] that provides updates for the current [ExportFileFormat].
  final ValueListenable<ExportFileFormat> listenable;

  @override
  Widget build(BuildContext context) {
    return ValueListenableBuilder<ExportFileFormat>(
      valueListenable: listenable,
      builder: (context, currentValue, _) {
        return PlatformAwareWidget(
          android: (context) {
            return SegmentedButton<ExportFileFormat>(
              showSelectedIcon: false,
              segments: <ButtonSegment<ExportFileFormat>>[
                ButtonSegment(label: Text(ExportFileFormat.csv.asUpperCase), value: ExportFileFormat.csv),
                ButtonSegment(label: Text(ExportFileFormat.json.asUpperCase), value: ExportFileFormat.json),
              ],
              selected: <ExportFileFormat>{currentValue},
              onSelectionChanged: (selectedSegments) {
                if (selectedSegments.isEmpty) {
                  return;
                }

                onFormatSelected(selectedSegments.first);
              },
            );
          },
          ios: (_) {
            return CupertinoSlidingSegmentedControl<ExportFileFormat>(
              groupValue: currentValue,
              onValueChanged: onFormatSelected,
              children: {
                ExportFileFormat.csv: Text(ExportFileFormat.csv.asUpperCase),
                ExportFileFormat.json: Text(ExportFileFormat.json.asUpperCase),
              },
            );
          },
        );
      },
    );
  }
}
