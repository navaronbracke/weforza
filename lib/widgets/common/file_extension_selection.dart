import 'package:flutter/cupertino.dart';
import 'package:flutter/material.dart';
import 'package:weforza/file/file_handler.dart';
import 'package:weforza/generated/l10n.dart';
import 'package:weforza/theme/app_theme.dart';
import 'package:weforza/widgets/platform/platform_aware_widget.dart';

class FileExtensionSelection extends StatefulWidget {
  const FileExtensionSelection({
    Key? key,
    required this.initialValue,
    required this.onExtensionSelected,
  }) : super(key: key);

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
    final translator = S.of(context);

    return PlatformAwareWidget(
      android: () => _buildAndroidWidget(translator),
      ios: () => _buildIosWidget(translator),
    );
  }

  Widget _buildAndroidWidget(S translator) {
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
                ? const TextStyle(color: ApplicationTheme.primaryColor)
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
              ? const TextStyle(color: ApplicationTheme.primaryColor)
              : null,
        )
      ],
    );
  }

  Widget _buildIosWidget(S translator) {
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
