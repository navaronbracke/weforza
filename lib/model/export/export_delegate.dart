import 'dart:io';

import 'package:flutter/widgets.dart';
import 'package:rxdart/subjects.dart';
import 'package:weforza/exceptions/exceptions.dart';
import 'package:weforza/file/file_handler.dart';
import 'package:weforza/model/async_computation_delegate.dart';
import 'package:weforza/model/export/export_file_format.dart';

/// This class represents a delegate that handles exporting data.
abstract class ExportDelegate<Options> extends AsyncComputationDelegate<void> {
  /// The default constructor.
  ExportDelegate({
    required this.fileHandler,
    required String initialFileName,
  }) : fileNameController = TextEditingController(text: initialFileName);

  /// The controller that keeps track of the selected file format.
  ///
  /// By default, [ExportFileFormat.csv] is used as the initial value.
  final _fileFormatController = BehaviorSubject.seeded(ExportFileFormat.csv);

  /// The name of the last file that is known to exist.
  ///
  /// When the [File.existsSync] method determines that a given file name already exists,
  /// then this field is set to that file name.
  ///
  /// When the file name is validated using the relevant validator function,
  /// it invokes [fileExists] with the current file name,
  /// which checks equality against this field.
  ///
  /// If a new file format is set using [setFileFormat],
  /// then this field is reset, since the old value is no longer valid
  /// because the extension in the file name has changed.
  String? _lastExistingFileName;

  /// The file handler that will manage the underlying file.
  final FileHandler fileHandler;

  /// The controller that manages the selected file name.
  final TextEditingController fileNameController;

  /// The [Key] for the file name input field.
  final GlobalKey<FormFieldState<String>> fileNameKey = GlobalKey();

  /// Get the currently selected file format.
  ExportFileFormat get currentFileFormat => _fileFormatController.value;

  /// Get the [Stream] of file format selection changes.
  Stream<ExportFileFormat> get fileFormatStream => _fileFormatController;

  /// Export the currently available data to a file.
  ///
  /// See [writeToFile].
  void exportDataToFile(Options options) async {
    final formState = fileNameKey.currentState;

    if (formState == null || !formState.validate() || !canStartComputation()) {
      return;
    }

    final fileFormat = _fileFormatController.value;
    final fileName = fileNameController.text;

    try {
      // Sanity-check that the file name ends with the correct extension.
      // This should have been validated with the form state as well.
      if (!fileName.endsWith(fileFormat.formatExtension)) {
        throw ArgumentError.value(
          fileName,
          'fileName',
          'The file name should end with the correct file extension',
        );
      }

      final file = await fileHandler.getFile(fileName);

      // If the file exists, set the last file name
      // of which it is known that it exists,
      // and revalidate the form to trigger the validation message.
      if (file.existsSync()) {
        _lastExistingFileName = fileName;
        fileNameKey.currentState?.validate();

        throw FileExistsException();
      }

      await writeToFile(file, fileFormat, options);

      setDone(null);
    } catch (error, stackTrace) {
      setError(error, stackTrace);
    }
  }

  /// Returns whether the given [fileName] matches the [_lastExistingFileName].
  bool fileExists(String fileName) {
    if (_lastExistingFileName == null) {
      return false;
    }

    return _lastExistingFileName == fileName;
  }

  /// Set the selected file format to [value].
  ///
  /// Does nothing if [value] is null.
  void setFileFormat(ExportFileFormat? value) {
    if (value == null || _fileFormatController.value == value) {
      return;
    }

    final oldFileExtension = _fileFormatController.value.formatExtension;
    final fileName = fileNameController.text;

    // If a new file format is selected,
    // and the current filename ends with the old file extension,
    // then replace the old file extension in the file name with the new one.
    if (fileName.endsWith(oldFileExtension)) {
      final fileNameWithNoExtension = fileName.substring(
        0,
        fileName.length - oldFileExtension.length,
      );

      final newFileName = fileNameWithNoExtension + value.formatExtension;

      fileNameController.value = TextEditingValue(
        text: newFileName,
        selection: TextSelection.collapsed(offset: newFileName.length),
      );
    }

    // If a new file format was selected,
    // the `File Exists` message may be outdated.
    _lastExistingFileName = null;
    fileNameKey.currentState?.validate();

    _fileFormatController.add(value);
  }

  /// Write the export data to the given [file], using the given [fileFormat].
  Future<void> writeToFile(
    File file,
    ExportFileFormat fileFormat,
    Options options,
  );

  @mustCallSuper
  @override
  void dispose() {
    _fileFormatController.close();
    fileNameController.dispose();
    super.dispose();
  }
}
