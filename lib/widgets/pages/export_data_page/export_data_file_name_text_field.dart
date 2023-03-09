import 'package:flutter/cupertino.dart';
import 'package:flutter/material.dart';
import 'package:flutter/services.dart';
import 'package:weforza/generated/l10n.dart';
import 'package:weforza/model/export/export_delegate.dart';
import 'package:weforza/model/export/export_file_format.dart';
import 'package:weforza/widgets/platform/platform_aware_widget.dart';

/// This widget represents the text field for the file name input on the export data page.
class ExportDataFileNameTextField<T> extends StatelessWidget {
  ExportDataFileNameTextField({
    required this.delegate,
    super.key,
  }) : inputFormatters = [
          FilteringTextInputFormatter.allow(RegExp(r'[\w-\.]')),
          LengthLimitingTextInputFormatter(maxLength),
        ];

  /// The maximum length for the file name input field.
  static const int maxLength = 80;

  /// The delegate that handles the export.
  final ExportDelegate<T> delegate;

  /// The input formatters for the text field.
  final List<TextInputFormatter> inputFormatters;

  /// Validate the given [fileName].
  ///
  /// Returns an error message or null if the file name is valid.
  String? _validateFileName(String? fileName, S translator) {
    if (fileName == null || fileName.isEmpty) {
      return translator.fileNameRequired;
    }

    if (fileName.startsWith('.')) {
      return translator.fileNameCantStartWithDot;
    }

    final ExportFileFormat fileFormat = delegate.currentFileFormat;
    final String fileExtension = fileFormat.formatExtension;

    if (!fileName.endsWith(fileExtension)) {
      return translator.fileNameInvalidExtension(
        fileFormat.asUpperCase,
        fileExtension,
      );
    }

    if (delegate.fileExists(fileName)) {
      return translator.fileNameExists;
    }

    return null;
  }

  @override
  Widget build(BuildContext context) {
    final translator = S.of(context);

    return PlatformAwareWidget(
      android: (_) => TextFormField(
        autocorrect: false,
        autovalidateMode: AutovalidateMode.onUserInteraction,
        controller: delegate.fileNameController,
        decoration: InputDecoration(
          contentPadding: const EdgeInsets.symmetric(horizontal: 4),
          labelText: translator.fileName,
          errorMaxLines: 3,
        ),
        inputFormatters: inputFormatters,
        key: delegate.fileNameKey,
        keyboardType: TextInputType.text,
        maxLength: maxLength,
        textInputAction: TextInputAction.done,
        validator: (fileName) => _validateFileName(fileName, translator),
      ),
      ios: (_) => CupertinoTextFormFieldRow(
        autocorrect: false,
        autovalidateMode: AutovalidateMode.onUserInteraction,
        controller: delegate.fileNameController,
        inputFormatters: inputFormatters,
        key: delegate.fileNameKey,
        keyboardType: TextInputType.text,
        maxLength: maxLength,
        placeholder: translator.fileName,
        textInputAction: TextInputAction.done,
        validator: (fileName) => _validateFileName(fileName, translator),
      ),
    );
  }
}
