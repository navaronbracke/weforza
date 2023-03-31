import 'dart:io';

import 'package:flutter/widgets.dart';

/// This class represents the controller for a [DirectorySelectionFormField].
class DirectorySelectionController extends ChangeNotifier {
  DirectorySelectionController({Directory? initialValue}) : _directory = initialValue;

  Directory? _directory;

  /// The currently selected directory.
  Directory? get directory => _directory;

  set directory(Directory? value) {
    if (_directory != value) {
      _directory = value;
      notifyListeners();
    }
  }
}

/// This class represents a [FormField] for selecting a directory.
///
/// This form field does not support state restoration.
class DirectorySelectionFormField extends FormField<Directory> {
  DirectorySelectionFormField({
    required Widget Function(ValueChanged<Directory> onChanged) builder,
    required this.controller,
    this.buttonFocusNode,
    this.labelFocusNode,
    ValueChanged<Directory>? onChanged,
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
          builder: (FormFieldState<Directory> field) => builder(
            (Directory value) {
              field.didChange(value);
              onChanged?.call(value);
            },
          ),
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
