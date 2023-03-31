import 'package:flutter/cupertino.dart';
import 'package:flutter/material.dart';

import 'package:weforza/model/export_file_format.dart';
import 'package:weforza/widgets/platform/platform_aware_widget.dart';

/// This widget represents an export file format selection.
class ExportFileFormatSelection extends StatelessWidget {
  const ExportFileFormatSelection({
    required this.initialValue,
    required this.onFormatSelected,
    required this.stream,
    super.key,
  });

  /// The initially selected value.
  final ExportFileFormat initialValue;

  /// The function that handles a change in the selection.
  final void Function(ExportFileFormat? value) onFormatSelected;

  /// The stream that provides updates for the current value.
  final Stream<ExportFileFormat> stream;

  @override
  Widget build(BuildContext context) {
    return StreamBuilder<ExportFileFormat>(
      initialData: initialValue,
      stream: stream,
      builder: (context, snapshot) {
        final currentValue = snapshot.data!;

        return PlatformAwareWidget(
          android: (context) {
            return SegmentedButton<ExportFileFormat>(
              showSelectedIcon: false,
              segments: <ButtonSegment<ExportFileFormat>>[
                ButtonSegment(
                  label: Text(ExportFileFormat.csv.asUpperCase),
                  value: ExportFileFormat.csv,
                ),
                ButtonSegment(
                  label: Text(ExportFileFormat.json.asUpperCase),
                  value: ExportFileFormat.json,
                ),
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
          ios: (_) => CupertinoSlidingSegmentedControl<ExportFileFormat>(
            groupValue: currentValue,
            onValueChanged: onFormatSelected,
            children: {
              ExportFileFormat.csv: Text(ExportFileFormat.csv.asUpperCase),
              ExportFileFormat.json: Text(ExportFileFormat.json.asUpperCase),
            },
          ),
        );
      },
    );
  }
}
