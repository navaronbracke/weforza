import 'package:flutter/cupertino.dart';
import 'package:flutter/material.dart';
import 'package:weforza/file/file_handler.dart';
import 'package:weforza/generated/l10n.dart';
import 'package:weforza/widgets/platform/platform_aware_widget.dart';

/// This widget represents a file extension selection.
class FileExtensionSelection extends StatelessWidget {
  const FileExtensionSelection({
    required this.initialValue,
    required this.onExtensionSelected,
    required this.stream,
    super.key,
  });

  /// The initially selected value.
  final FileExtension initialValue;

  /// The stream that provides updates for the current value.
  final Stream<FileExtension> stream;

  /// The function that handles a change in the selection.
  final void Function(FileExtension? value) onExtensionSelected;

  @override
  Widget build(BuildContext context) {
    return StreamBuilder<FileExtension>(
      initialData: initialValue,
      stream: stream,
      builder: (context, snapshot) {
        final currentValue = snapshot.data!;
        final translator = S.of(context);

        return PlatformAwareWidget(
          android: (context) {
            final primaryColor = Theme.of(context).primaryColor;

            return Row(
              mainAxisAlignment: MainAxisAlignment.center,
              children: [
                Radio<FileExtension>(
                  value: FileExtension.csv,
                  groupValue: currentValue,
                  onChanged: onExtensionSelected,
                ),
                Padding(
                  padding: const EdgeInsets.only(right: 20),
                  child: Text(
                    translator.FileCsvExtension.toUpperCase(),
                    style: FileExtension.csv == currentValue
                        ? TextStyle(color: primaryColor)
                        : null,
                  ),
                ),
                Radio<FileExtension>(
                  value: FileExtension.json,
                  groupValue: currentValue,
                  onChanged: onExtensionSelected,
                ),
                Text(
                  translator.FileJsonExtension.toUpperCase(),
                  style: FileExtension.json == currentValue
                      ? TextStyle(color: primaryColor)
                      : null,
                )
              ],
            );
          },
          ios: (_) => CupertinoSlidingSegmentedControl<FileExtension>(
            groupValue: currentValue,
            onValueChanged: onExtensionSelected,
            children: {
              FileExtension.csv: Text(
                translator.FileCsvExtension.toUpperCase(),
              ),
              FileExtension.json: Text(
                translator.FileJsonExtension.toUpperCase(),
              ),
            },
          ),
        );
      },
    );
  }
}
