import 'dart:convert';
import 'dart:io';

import 'package:flutter/widgets.dart';
import 'package:rxdart/subjects.dart';
import 'package:weforza/exceptions/exceptions.dart';
import 'package:weforza/file/file_handler.dart';
import 'package:weforza/model/async_computation_delegate.dart';
import 'package:weforza/model/export_file_format.dart';
import 'package:weforza/model/rider/serializable_rider.dart';
import 'package:weforza/repository/serialize_riders_repository.dart';

/// This class represents the delegate that handles exporting riders.
class ExportRidersDelegate extends AsyncComputationDelegate<void> {
  ExportRidersDelegate({
    required this.fileHandler,
    required String initialFileName,
    required this.serializeRidersRepository,
  }) : fileNameController = TextEditingController(text: initialFileName);

  /// This controller keeps track of whether a file with a given name already exists.
  final _fileExistsController = BehaviorSubject.seeded(false);

  /// The controller that keeps track of the selected file format.
  final _fileFormatController = BehaviorSubject.seeded(ExportFileFormat.csv);

  /// The file handler that will manage the underlying file.
  final FileHandler fileHandler;

  /// The controller that manages the selected file name.
  final TextEditingController fileNameController;

  /// The [Key] for the file name input field.
  final GlobalKey<FormFieldState<String>> fileNameKey = GlobalKey();

  /// The repository that handles exporting the riders.
  final SerializeRidersRepository serializeRidersRepository;

  /// Get the currently selected file format.
  ExportFileFormat get currentFileFormat => _fileFormatController.value;

  /// Get the current state of the file exists flag.
  bool get fileExists => _fileExistsController.value;

  /// Get the [Stream] of file exists changes.
  Stream<bool> get fileExistsStream => _fileExistsController;

  /// Get the [Stream] of file format selection changes.
  Stream<ExportFileFormat> get fileFormatStream => _fileFormatController;

  /// Save the given [riders] to the given [file].
  ///
  /// If the [fileFormat] is [ExportFileFormat.csv],
  /// the [csvHeader] becomes the first line in the CSV output file.
  Future<void> _saveRidersToFile(
    File file,
    ExportFileFormat fileFormat,
    Iterable<SerializableRider> riders,
    String csvHeader,
  ) {
    switch (fileFormat) {
      case ExportFileFormat.csv:
        final buffer = StringBuffer();

        buffer.writeln(csvHeader);

        for (final rider in riders) {
          buffer.writeln(rider.toCsv());
        }

        return file.writeAsString(buffer.toString());
      case ExportFileFormat.json:
        final data = <String, Object?>{
          'riders': riders.map((r) => r.toJson()).toList(),
        };

        return file.writeAsString(jsonEncode(data));
    }
  }

  /// Export the currently available riders to a file.
  void exportRiders({required String csvHeader}) async {
    final formState = fileNameKey.currentState;

    if (formState == null || !formState.validate() || !canStartComputation()) {
      return;
    }

    final fileFormat = _fileFormatController.value;

    final fileName = '${fileNameController.text}${fileFormat.formatExtension}';

    try {
      final file = await fileHandler.getFile(fileName);

      if (file.existsSync()) {
        if (!_fileExistsController.isClosed) {
          _fileExistsController.add(true);
        }

        throw FileExistsException();
      }

      final items = await serializeRidersRepository.getSerializableRiders();

      await _saveRidersToFile(file, fileFormat, items, csvHeader);

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

    // Reset the file name field error message if a new file format was selected.
    fileNameKey.currentState?.reset();
    _fileExistsController.add(false);
    _fileFormatController.add(value);
  }

  @override
  void dispose() {
    _fileExistsController.close();
    _fileFormatController.close();
    fileNameController.dispose();
    super.dispose();
  }
}
