import 'dart:io';

import 'package:flutter/widgets.dart';
import 'package:flutter_riverpod/flutter_riverpod.dart';
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
    Directory? initialDirectory,
  })  : fileNameController = TextEditingController(),
        _selectDirectoryController = BehaviorSubject.seeded(AsyncData(initialDirectory));

  /// The controller that keeps track of the selected file format.
  ///
  /// By default, [ExportFileFormat.csv] is used as the initial value.
  final _fileFormatController = BehaviorSubject.seeded(ExportFileFormat.csv);

  /// The controller that manages the selected directory.
  final BehaviorSubject<AsyncValue<Directory?>> _selectDirectoryController;

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

  /// Get the selected export directory.
  AsyncValue<Directory?> get selectedDirectory => _selectDirectoryController.value;

  /// Get the stream of selected directory changes.
  Stream<AsyncValue<Directory?>> get selectedDirectoryStream => _selectDirectoryController;

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
    final directory = _selectDirectoryController.valueOrNull?.value;

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
        throw DirectoryRequiredException();
      }

      if (!directory.existsSync()) {
        throw DirectoryNotFoundException();
      }

      final file = File(directory.path + Platform.pathSeparator + fileName);

      // If the file exists, revalidate the form to trigger the validation message.
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

  /// Select a new directory as the parent folder of the export file.
  void selectDirectory() async {
    final Directory? oldDirectory = _selectDirectoryController.valueOrNull?.value;

    try {
      final Directory? directory = await fileHandler.pickDirectory();

      if (!mounted) {
        return;
      }

      // Revert to the previous directory if none was selected.
      if (directory == null) {
        _selectDirectoryController.add(AsyncData(oldDirectory));

        return;
      }

      _selectDirectoryController.add(AsyncData(directory));

      // If a new directory was selected,
      // the `File Exists` message may be outdated.
      fileNameKey.currentState?.validate();
    } catch (error, stackTrace) {
      if (!mounted) {
        return;
      }

      // Amend the `AsyncValue.value` so that the old directory path is preserved.
      _selectDirectoryController.add(
        AsyncError<Directory?>(error, stackTrace).copyWithPrevious(AsyncData(oldDirectory)),
      );
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
    _selectDirectoryController.close();
    _fileFormatController.close();
    fileNameController.dispose();
    super.dispose();
  }
}
