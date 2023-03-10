import 'dart:io';

import 'package:flutter/cupertino.dart';
import 'package:flutter/material.dart';
import 'package:weforza/file/file_handler.dart';
import 'package:weforza/generated/l10n.dart';
import 'package:weforza/widgets/platform/platform_aware_widget.dart';

/// This class represents the controller for a [DirectorySelectionFormField].
class DirectorySelectionController extends ChangeNotifier {
  DirectorySelectionController({
    required FileHandler fileHandler,
    Directory? initialValue,
  })  : _directory = initialValue,
        _fileHandler = fileHandler;

  final FileHandler _fileHandler;

  Directory? _directory;

  /// The currently selected directory.
  Directory? get directory => _directory;

  set directory(Directory? value) {
    if (_directory != value) {
      _directory = value;
      notifyListeners();
    }
  }

  /// Open a directory picker.
  Future<Directory?> openDirectoryPicker() => _fileHandler.pickDirectory();
}

/// This class represents a [FormField] for selecting a directory.
///
/// This form field does not support state restoration.
class DirectorySelectionFormField extends FormField<Directory> {
  DirectorySelectionFormField({
    required this.controller,
    this.buttonFocusNode,
    this.labelFocusNode,
    ValueChanged<Directory?>? onChanged,
    this.maxLines = 1,
    AutovalidateMode? autovalidateMode,
    super.onSaved,
    super.validator,
    super.key,
  })  : assert(maxLines == null || maxLines > 0, 'Max lines should be null or greater than zero'),
        super(
          initialValue: controller.directory,
          autovalidateMode: autovalidateMode ?? AutovalidateMode.disabled,
          enabled: true,
          builder: (FormFieldState<Directory> field) {
            return _DirectorySelectionFormFieldWidget(
              directoryPath: field.value?.path,
              errorMessage: field.errorText,
              selectDirectory: () async {
                // If the directory picking operation failed, it returns null instead of an error.
                final Directory? directory = await controller.openDirectoryPicker();

                // If no directory was selected, do not overwrite the old directory.
                if (!field.mounted || directory == null) {
                  return;
                }

                field.didChange(directory);
                onChanged?.call(directory);
              },
            );
          },
        );

  /// The focus node for the select directory button.
  final FocusNode? buttonFocusNode;

  /// The controller for the directory selection field.
  final DirectorySelectionController controller;

  /// The focus node for the selected directory label.
  final FocusNode? labelFocusNode;

  /// The maximum lines for the directory path label.
  final int? maxLines;

  @override
  FormFieldState<Directory> createState() => _DirectorySelectionFormFieldState();
}

class _DirectorySelectionFormFieldState extends FormFieldState<Directory> {
  DirectorySelectionFormField get _directorySelectionFormField => super.widget as DirectorySelectionFormField;

  @override
  void initState() {
    super.initState();
    _directorySelectionFormField.controller.addListener(_handleControllerChanged);
  }

  @override
  void didUpdateWidget(DirectorySelectionFormField oldWidget) {
    super.didUpdateWidget(oldWidget);
    if (_directorySelectionFormField.controller != oldWidget.controller) {
      oldWidget.controller.removeListener(_handleControllerChanged);
      _directorySelectionFormField.controller.addListener(_handleControllerChanged);
      setValue(_directorySelectionFormField.controller.directory);
    }
  }

  @override
  void dispose() {
    _directorySelectionFormField.controller.removeListener(_handleControllerChanged);
    super.dispose();
  }

  @override
  void didChange(Directory? value) {
    super.didChange(value);

    if (_directorySelectionFormField.controller.directory != value) {
      _directorySelectionFormField.controller.directory = value;
    }
  }

  @override
  void reset() {
    // setState will be called in the superclass, so even though state is being
    // manipulated, no setState call is needed here.
    _directorySelectionFormField.controller.directory = widget.initialValue;
    super.reset();
  }

  void _handleControllerChanged() {
    // Suppress changes that originated from within this class.
    //
    // In the case where a controller has been passed in to this widget, we
    // register this change listener. In these cases, we'll also receive change
    // notifications for changes originating from within this class -- for
    // example, the reset() method. In such cases, the FormField value will
    // already have been set.
    if (_directorySelectionFormField.controller.directory != value) {
      didChange(_directorySelectionFormField.controller.directory);
    }
  }
}

class _DirectorySelectionFormFieldWidget extends StatelessWidget {
  const _DirectorySelectionFormFieldWidget({
    required this.selectDirectory,
    this.directoryPath,
    this.errorMessage,
  });

  /// The path to the picked directory.
  final String? directoryPath;

  /// The validation error message that is displayed below the [directoryPath].
  final String? errorMessage;

  /// The function that opens a directory picker.
  final void Function() selectDirectory;

  @override
  Widget build(BuildContext context) {
    return PlatformAwareWidget(
      android: (context) {
        final translator = S.of(context);

        final Widget child = directoryPath == null
            ? Center(child: TextButton(onPressed: selectDirectory, child: Text(translator.selectDirectory)))
            : Text(directoryPath!, maxLines: 1, overflow: TextOverflow.ellipsis);

        return Column(
          mainAxisSize: MainAxisSize.min,
          crossAxisAlignment: CrossAxisAlignment.start,
          children: [
            Row(
              children: [
                Padding(padding: const EdgeInsets.only(right: 16), child: Text(translator.directory)),
                Flexible(child: child),
              ],
            ),
            if (errorMessage != null)
              Flexible(
                child: Padding(
                  padding: const EdgeInsets.only(top: 4),
                  child: Text(errorMessage!, style: Theme.of(context).inputDecorationTheme.errorStyle),
                ),
              ),
            if (directoryPath != null)
              Center(
                child: Padding(
                  padding: const EdgeInsets.only(top: 16),
                  child: TextButton(onPressed: selectDirectory, child: Text(translator.selectDirectory)),
                ),
              ),
          ],
        );
      },
      ios: (context) {
        final translator = S.of(context);

        final Widget child = directoryPath == null
            ? CupertinoButton(onPressed: selectDirectory, child: Text(translator.selectDirectory))
            : Text(directoryPath!, maxLines: 3, overflow: TextOverflow.ellipsis, style: const TextStyle(fontSize: 14));

        final padding = directoryPath == null
            ? const EdgeInsetsDirectional.fromSTEB(20, 16, 6, 16)
            : const EdgeInsetsDirectional.fromSTEB(20, 16, 6, 0);

        return CupertinoFormRow(
          padding: padding,
          prefix: Padding(padding: const EdgeInsets.only(right: 16), child: Text(translator.directory)),
          error: errorMessage != null ? Text(errorMessage!) : null,
          helper: directoryPath != null
              ? Center(
                  child: Padding(
                    padding: const EdgeInsets.only(top: 16),
                    child: CupertinoButton(onPressed: selectDirectory, child: Text(translator.selectDirectory)),
                  ),
                )
              : null,
          child: child,
        );
      },
    );
  }
}
