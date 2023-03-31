import 'package:flutter/cupertino.dart';
import 'package:flutter/material.dart';
import 'package:weforza/file/file_handler.dart';
import 'package:weforza/generated/l10n.dart';
import 'package:weforza/theme/app_theme.dart';
import 'package:weforza/widgets/platform/platform_aware_widget.dart';

class FileExtensionSelection extends StatelessWidget {
  const FileExtensionSelection({
    Key? key,
    this.enabled = true,
    required this.onExtensionSelected,
    required this.value,
  }) : super(key: key);

  final bool enabled;
  final void Function(FileExtension? value) onExtensionSelected;
  final FileExtension value;

  Widget _buildAndroidWidget(S translator) {
    return Row(
      mainAxisAlignment: MainAxisAlignment.center,
      children: [
        Radio<FileExtension>(
          value: FileExtension.csv,
          groupValue: value,
          onChanged: enabled ? onExtensionSelected : null,
        ),
        Padding(
          padding: const EdgeInsets.only(right: 20),
          child: Text(
            translator.FileCsvExtension.toUpperCase(),
            style: FileExtension.csv == value
                ? const TextStyle(color: ApplicationTheme.primaryColor)
                : null,
          ),
        ),
        Radio<FileExtension>(
          value: FileExtension.json,
          groupValue: value,
          onChanged: enabled ? onExtensionSelected : null,
        ),
        Text(
          translator.FileJsonExtension.toUpperCase(),
          style: FileExtension.json == value
              ? const TextStyle(color: ApplicationTheme.primaryColor)
              : null,
        )
      ],
    );
  }

  Widget _buildIosWidget(S translator) {
    return CupertinoSlidingSegmentedControl<FileExtension>(
      groupValue: value,
      onValueChanged: onExtensionSelected,
      children: {
        FileExtension.csv: Text(translator.FileCsvExtension.toUpperCase()),
        FileExtension.json: Text(translator.FileJsonExtension.toUpperCase()),
      },
    );
  }

  @override
  Widget build(BuildContext context) {
    final translator = S.of(context);

    return PlatformAwareWidget(
      android: () => _buildAndroidWidget(translator),
      ios: () => _buildIosWidget(translator),
    );
  }
}
