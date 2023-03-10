import 'dart:io';

import 'package:flutter/widgets.dart';
import 'package:rxdart/subjects.dart';
import 'package:weforza/exceptions/exceptions.dart';
import 'package:weforza/file/file_handler.dart';
import 'package:weforza/model/async_computation_delegate.dart';
import 'package:weforza/model/export/export_file_format.dart';
import 'package:weforza/widgets/custom/directory_selection_form_field.dart';

/// This class represents a delegate that handles exporting data.
abstract class ExportDelegate<Options> extends AsyncComputationDelegate<void> {
  /// The default constructor.
  ExportDelegate({
    required this.fileHandler,
    Directory? initialDirectory,
  })  : fileNameController = TextEditingController(),
        _selectDirectoryController = BehaviorSubject.seeded(AsyncData(initialDirectory));

  /// The controller that keeps track of the selected file format.
  ///
  /// By default, [ExportFileFormat.csv] is used as the initial value.
  final _fileFormatController = BehaviorSubject.seeded(ExportFileFormat.csv);

  /// The directory that manages the selected directory.
  final DirectorySelectionController directoryController;

  /// The file handler that will provide directories.
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
  void exportDataToFile(BuildContext context, Options options) async {
    final FormState? formState = Form.maybeOf(context);

    if (formState == null || !formState.validate() || !canStartComputation()) {
      return;
    }

    final fileFormat = _fileFormatController.value;
    final fileName = fileNameController.text;
    final directory = directoryController.directory;

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

      if (directory == null) {
        throw ArgumentError.notNull('directory');
      }

      if (!directory.existsSync()) {
        throw StateError('The given directory $directory does not exist');
      }

      final file = File(directory.path + Platform.pathSeparator + fileName);

      // If the file exists, revalidate the form to trigger the validation message for the file exists case.
      if (file.existsSync()) {
        fileNameKey.currentState?.validate();

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

    _fileFormatController.add(value);

    // If a new file format was selected,
    // the `File Exists` message may be outdated.
    fileNameKey.currentState?.validate();
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
    directoryController.removeListener(_onDirectoryChanged);
    directoryController.dispose();
    _fileFormatController.close();
    fileNameController.dispose();
    super.dispose();
  }
}
