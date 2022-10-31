import 'package:flutter/cupertino.dart';
import 'package:flutter/material.dart';
import 'package:weforza/file/file_handler.dart';
import 'package:weforza/generated/l10n.dart';
import 'package:weforza/widgets/platform/platform_aware_widget.dart';

class FileExtensionSelection extends StatefulWidget {
  const FileExtensionSelection({
    super.key,
    required this.initialValue,
    required this.onExtensionSelected,
  });

  final FileExtension initialValue;
  final void Function(FileExtension value) onExtensionSelected;

  @override
  FileExtensionSelectionState createState() => FileExtensionSelectionState();
}

class FileExtensionSelectionState extends State<FileExtensionSelection> {
  late FileExtension currentValue;

  @override
  void initState() {
    super.initState();
    currentValue = widget.initialValue;
  }

  @override
  Widget build(BuildContext context) {
    return PlatformAwareWidget(
      android: _buildAndroidWidget,
      ios: _buildIosWidget,
    );
  }

  Widget _buildAndroidWidget(BuildContext context) {
    final translator = S.of(context);

    final primaryColor = Theme.of(context).primaryColor;

    return Row(
      mainAxisAlignment: MainAxisAlignment.center,
      children: [
        Radio<FileExtension>(
          value: FileExtension.csv,
          groupValue: currentValue,
          onChanged: onValueChanged,
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
          onChanged: onValueChanged,
        ),
        Text(
          translator.FileJsonExtension.toUpperCase(),
          style: FileExtension.json == currentValue
              ? TextStyle(color: primaryColor)
              : null,
        )
      ],
    );
  }

  Widget _buildIosWidget(BuildContext context) {
    final translator = S.of(context);

    return CupertinoSlidingSegmentedControl<FileExtension>(
      groupValue: currentValue,
      onValueChanged: onValueChanged,
      children: {
        FileExtension.csv: Text(translator.FileCsvExtension.toUpperCase()),
        FileExtension.json: Text(translator.FileJsonExtension.toUpperCase()),
      },
    );
  }

  void onValueChanged(FileExtension? value) {
    if (value == null) {
      return;
    }

    setState(() {
      currentValue = value;
      widget.onExtensionSelected(currentValue);
    });
  }
}
