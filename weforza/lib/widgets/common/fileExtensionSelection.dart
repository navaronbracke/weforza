import 'package:flutter/material.dart';
import 'package:flutter/cupertino.dart';
import 'package:weforza/file/fileHandler.dart';
import 'package:weforza/generated/l10n.dart';
import 'package:weforza/theme/appTheme.dart';
import 'package:weforza/widgets/platform/platformAwareWidget.dart';

class FileExtensionSelection extends StatefulWidget {
  FileExtensionSelection({
    required this.onExtensionSelected,
    required this.initialValue,
  });

  final void Function(FileExtension value) onExtensionSelected;
  final FileExtension initialValue;

  @override
  _FileExtensionSelectionState createState() => _FileExtensionSelectionState();
}

class _FileExtensionSelectionState extends State<FileExtensionSelection> {
  late FileExtension currentValue;

  @override
  void initState() {
    super.initState();
    currentValue = widget.initialValue;
  }

  @override
  Widget build(BuildContext context) => PlatformAwareWidget(
    android: () => _buildAndroidWidget(context),
    ios: () => _buildIosWidget(context),
  );

  Widget _buildAndroidWidget(BuildContext context){
    return Row(
      mainAxisAlignment: MainAxisAlignment.center,
      children: [
        Radio<FileExtension>(
          value: FileExtension.CSV,
          groupValue: currentValue,
          onChanged: onValueChanged,
        ),
        Padding(
          padding: const EdgeInsets.only(left: 2, right: 20),
          child: Text(
            S.of(context).FileCsvExtension.toUpperCase(),
            style: FileExtension.CSV == currentValue ? TextStyle(color: ApplicationTheme.primaryColor): null,
          ),
        ),
        Radio<FileExtension>(
          value: FileExtension.JSON,
          groupValue: currentValue,
          onChanged: onValueChanged,
        ),
        Padding(
          padding: const EdgeInsets.only(left: 2),
          child: Text(
            S.of(context).FileJsonExtension.toUpperCase(),
            style: FileExtension.JSON == currentValue ? TextStyle(color: ApplicationTheme.primaryColor): null,
          ),
        ),
      ],
    );
  }

  Widget _buildIosWidget(BuildContext context){
    return CupertinoSlidingSegmentedControl<FileExtension>(
      groupValue: currentValue,
      onValueChanged: onValueChanged,
      children: {
        FileExtension.CSV: Text(S.of(context).FileCsvExtension.toUpperCase()),
        FileExtension.JSON: Text(S.of(context).FileJsonExtension.toUpperCase()),
      },
    );
  }

  void onValueChanged(FileExtension? value){
    if(value == null) return; // Should not happen as we have an initial value.

    setState((){
      widget.onExtensionSelected(value);
      currentValue = value;
    });
  }
}