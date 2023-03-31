import 'package:flutter/cupertino.dart';
import 'package:flutter/material.dart';
import 'package:rxdart/rxdart.dart';
import 'package:weforza/generated/l10n.dart';
import 'package:weforza/theme/app_theme.dart';
import 'package:weforza/widgets/common/validation_label.dart';
import 'package:weforza/widgets/platform/platform_aware_widget.dart';

class FileNameInputField extends StatelessWidget {
  FileNameInputField({
    super.key,
    required this.controller,
    required this.errorController,
    this.padding = const EdgeInsets.symmetric(horizontal: 20),
  });

  /// The controller for the text field.
  final TextEditingController controller;

  /// The error controller for the text field.
  final BehaviorSubject<String> errorController;

  /// The regex for the filename.
  final RegExp filenamePattern = RegExp(r'^[\w\s-_]{1,80}$');

  /// The max length for the filename.
  final int maxLength = 80;

  /// The padding for the input field.
  final EdgeInsets padding;

  String? _validateFileName(
    String? filename, {
    required String fileNameIsRequired,
    required String isWhitespaceMessage,
    required String filenameNameMaxLengthMessage,
    required String invalidFilenameMessage,
  }) {
    if (filename == null || filename.isEmpty) {
      return fileNameIsRequired;
    }
    if (filename.trim().isEmpty) {
      return isWhitespaceMessage;
    }
    if (maxLength < filename.length) {
      return filenameNameMaxLengthMessage;
    }
    if (!filenamePattern.hasMatch(filename)) {
      return invalidFilenameMessage;
    }

    return null;
  }

  @override
  Widget build(BuildContext context) {
    final translator = S.of(context);

    return Padding(
      padding: padding,
      child: Column(
        mainAxisSize: MainAxisSize.min,
        children: [
          PlatformAwareWidget(
            android: () => TextFormField(
              textInputAction: TextInputAction.done,
              keyboardType: TextInputType.text,
              autocorrect: false,
              controller: controller,
              validator: (value) {
                // Clear the file exists message.
                errorController.add('');

                return _validateFileName(
                  value,
                  fileNameIsRequired: translator.FilenameRequired,
                  isWhitespaceMessage: translator.FilenameWhitespace,
                  filenameNameMaxLengthMessage: translator.FilenameMaxLength(
                    maxLength,
                  ),
                  invalidFilenameMessage: translator.InvalidFilename,
                );
              },
              decoration: InputDecoration(
                contentPadding: const EdgeInsets.symmetric(horizontal: 4),
                labelText: translator.Filename,
                helperText: ' ',
              ),
              autovalidateMode: AutovalidateMode.onUserInteraction,
            ),
            ios: () => CupertinoTextField(
              textInputAction: TextInputAction.done,
              keyboardType: TextInputType.text,
              placeholder: translator.Filename,
              autocorrect: false,
              controller: controller,
              onChanged: (value) {
                final validationError = _validateFileName(
                  value,
                  fileNameIsRequired: translator.FilenameRequired,
                  isWhitespaceMessage: translator.FilenameWhitespace,
                  filenameNameMaxLengthMessage: translator.FilenameMaxLength(
                    maxLength,
                  ),
                  invalidFilenameMessage: translator.InvalidFilename,
                );

                errorController.add(validationError ?? '');
              },
            ),
          ),
          PlatformAwareWidget(
            android: () => ValidationLabel(
              stream: errorController,
              style: ApplicationTheme.androidFormErrorStyle,
            ),
            ios: () => ValidationLabel(
              stream: errorController,
              style: ApplicationTheme.iosFormErrorStyle,
            ),
          ),
        ],
      ),
    );
  }
}
