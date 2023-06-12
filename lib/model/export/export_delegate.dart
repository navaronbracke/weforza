import 'dart:io';

import 'package:flutter/widgets.dart';
import 'package:rxdart/subjects.dart';
import 'package:weforza/file/file_system.dart';
import 'package:weforza/model/async_computation_delegate.dart';
import 'package:weforza/model/export/export_file_format.dart';

/// This class represents a delegate that handles exporting data.
abstract class ExportDelegate<Options> extends AsyncComputationDelegate<void> {
  /// The default constructor.
  ExportDelegate({required this.fileSystem});

  /// The controller that keeps track of the selected file format.
  ///
  /// By default, [ExportFileFormat.csv] is used as the initial value.
  final _fileFormatController = BehaviorSubject.seeded(ExportFileFormat.csv);

  /// The file system that will provide directories.
  final FileSystem fileSystem;

  /// The controller that manages the selected file name.
  final TextEditingController fileNameController = TextEditingController();

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

      final File file;

      if (Platform.isIOS) {
        file = File(fileHandler.documentsDirectory.path + Platform.pathSeparator + fileName);

        // Sanity-check that the file does not exist.
        // This should have been validated with the form state as well.
        if (file.existsSync()) {
          throw StateError('The given file $file already exists');
        }
      } else if (Platform.isAndroid) {
        file = File(fileHandler.tempDirectory.path + Platform.pathSeparator + fileName);

        // On Android, set up a handle to a file in the temp directory.
        // Clean up the previous file handle, since it will get overwritten anyway.
        if (file.existsSync()) {
          await file.delete();
        }
      } else {
        throw UnsupportedError('Exporting is only supported on Android and iOS.');
      }

      // Write the export document to the target file.
      await writeToFile(file, fileFormat, options);

      // Register the document with the MediaStore on Android.
      // This will create a new document in the MediaStore and copy the temp file into it.
      if (Platform.isAndroid) {
        await registerDocument(file);
      }

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
    _fileFormatController.close();
    fileNameController.dispose();
    super.dispose();
  }
}
