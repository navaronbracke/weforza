import 'dart:io';

import 'package:flutter/widgets.dart';
import 'package:rxdart/subjects.dart';
import 'package:weforza/exceptions/exceptions.dart';
import 'package:weforza/file/file_handler.dart';
import 'package:weforza/model/async_computation_delegate.dart';
import 'package:weforza/model/export_file_format.dart';

/// This class represents a delegate that handles exporting data.
abstract class ExportDelegate<Options> extends AsyncComputationDelegate<void> {
  /// The default constructor.
  ExportDelegate({
    required this.fileHandler,
    required String initialFileName,
  }) : fileNameController = TextEditingController(text: initialFileName);

  /// This controller keeps track of whether a file with a given name already exists.
  final _fileExistsController = BehaviorSubject.seeded(false);

  /// The controller that keeps track of the selected file format.
  ///
  /// By default, [ExportFileFormat.csv] is used as the initial value.
  final _fileFormatController = BehaviorSubject.seeded(ExportFileFormat.csv);

  /// The file handler that will manage the underlying file.
  final FileHandler fileHandler;

  /// The controller that manages the selected file name.
  final TextEditingController fileNameController;

  /// The [Key] for the file name input field.
  final GlobalKey<FormFieldState<String>> fileNameKey = GlobalKey();

  /// Get the currently selected file format.
  ExportFileFormat get currentFileFormat => _fileFormatController.value;

  /// Get the current state of the file exists flag.
  bool get fileExists => _fileExistsController.value;

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

      if (file.existsSync()) {
        if (!_fileExistsController.isClosed) {
          _fileExistsController.add(true);
        }

        throw FileExistsException();
      }

      await writeToFile(file, fileFormat, options);

      setDone(null);
    } catch (error, stackTrace) {
      setError(error, stackTrace);
    }
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
    _fileExistsController.add(false);
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
    _fileExistsController.close();
    _fileFormatController.close();
    fileNameController.dispose();
    super.dispose();
  }
}
