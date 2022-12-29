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
            final primaryColor = Theme.of(context).primaryColor;

            return Row(
              mainAxisAlignment: MainAxisAlignment.center,
              children: [
                Radio<ExportFileFormat>(
                  value: ExportFileFormat.csv,
                  groupValue: currentValue,
                  onChanged: onFormatSelected,
                ),
                Padding(
                  padding: const EdgeInsets.only(right: 20),
                  child: Text(
                    'CSV',
                    style: ExportFileFormat.csv == currentValue
                        ? TextStyle(color: primaryColor)
                        : null,
                  ),
                ),
                Radio<ExportFileFormat>(
                  value: ExportFileFormat.json,
                  groupValue: currentValue,
                  onChanged: onFormatSelected,
                ),
                Text(
                  'JSON',
                  style: ExportFileFormat.json == currentValue
                      ? TextStyle(color: primaryColor)
                      : null,
                )
              ],
            );
          },
          ios: (_) => CupertinoSlidingSegmentedControl<ExportFileFormat>(
            groupValue: currentValue,
            onValueChanged: onFormatSelected,
            children: const {
              ExportFileFormat.csv: Text('CSV'),
              ExportFileFormat.json: Text('JSON'),
            },
          ),
        );
      },
    );
  }
}
