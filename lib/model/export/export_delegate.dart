import 'dart:io' show Platform;

import 'package:file/file.dart' as fs;
import 'package:flutter/widgets.dart';
import 'package:path/path.dart';
import 'package:rxdart/subjects.dart';
import 'package:weforza/exceptions/exceptions.dart';
import 'package:weforza/file/file_system.dart';
import 'package:weforza/model/async_computation_delegate.dart';
import 'package:weforza/model/export/export_file_format.dart';
import 'package:weforza/native_service/file_storage_delegate.dart';

/// This class represents a delegate that handles exporting data.
abstract class ExportDelegate<Options> extends AsyncComputationDelegate<void> {
  /// The default constructor.
  ExportDelegate({required this.fileStorageDelegate, required this.fileSystem});

  /// The controller that keeps track of the selected file format.
  ///
  /// By default, [ExportFileFormat.csv] is used as the initial value.
  final _fileFormatController = BehaviorSubject.seeded(ExportFileFormat.csv);

  /// The file storage delegate that will register the document.
  final FileStorageDelegate fileStorageDelegate;

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
      // Sanity-check that the file name.
      // This should have been validated with the form state as well.
      if (fileName.isEmpty) {
        throw ArgumentError.value(fileName, 'fileName', 'The file name should not be empty.');
      }

      if (fileName.startsWith('.')) {
        throw ArgumentError.value(fileName, 'fileName', 'The file name should not be start with a dot.');
      }

      if (!fileName.endsWith(fileFormat.formatExtension)) {
        throw ArgumentError.value(fileName, 'fileName', 'The file name should end with the correct file extension');
      }

      // On iOS, the exported files are saved to the application documents directory.
      // Check if the file does not exist yet, and write to the file.
      if (Platform.isIOS) {
        final fs.Directory directory = fileSystem.documentsDirectory;

        final fs.File file = fileSystem.file(join(directory.path, fileName));

        if (file.existsSync()) {
          throw StateError('The given file $file already exists');
        }

        await writeToFile(file, fileFormat, options);

        setDone(null);

        return;
      }

      if (Platform.isAndroid) {
        final fs.File file;

        if (fileSystem.hasScopedStorage) {
          // When using ScopedStorage, write to a temp file.
          // The file provider will copy this file into the MediaStore, using an output stream from the content resolver.
          file = fileSystem.file(join(fileSystem.tempDirectory.path, fileName));
        } else {
          // When not using ScopedStorage, write to the external public documents directory,
          // but request permission first. Lastly, register the file using the file provider.
          final fs.Directory? directory = fileSystem.topLevelDocumentsDirectory;

          if (directory == null) {
            throw ArgumentError.notNull('directory');
          }

          file = fileSystem.file(join(directory.path, fileName));

          if (file.existsSync()) {
            throw StateError('The given file $file already exists');
          }

          if (!await fileStorageDelegate.requestWriteExternalStoragePermission()) {
            throw ExternalStoragePermissionDeniedException();
          }
        }

        await writeToFile(file, fileFormat, options);

        await fileStorageDelegate.registerDocument(file);

        setDone(null);
        return;
      }

      throw UnsupportedError('Exporting is only supported on Android and iOS.');
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
      final fileNameWithNoExtension = fileName.substring(0, fileName.length - oldFileExtension.length);

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
  Future<void> writeToFile(fs.File file, ExportFileFormat fileFormat, Options options);

  @mustCallSuper
  @override
  void dispose() {
    _fileFormatController.close();
    fileNameController.dispose();
    super.dispose();
  }
}
