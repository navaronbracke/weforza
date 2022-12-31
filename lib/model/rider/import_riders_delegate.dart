import 'dart:io';

import 'package:rxdart/rxdart.dart';
import 'package:weforza/exceptions/exceptions.dart';
import 'package:weforza/file/file_handler.dart';
import 'package:weforza/file/import_riders_csv_reader.dart';
import 'package:weforza/file/import_riders_file_reader.dart';
import 'package:weforza/file/import_riders_json_reader.dart';
import 'package:weforza/model/export_file_format.dart';
import 'package:weforza/model/import_riders_state.dart';
import 'package:weforza/model/rider/serializable_rider.dart';
import 'package:weforza/repository/serialize_riders_repository.dart';

/// This class represents the delegate that handles importing riders.
class ImportRidersDelegate {
  ImportRidersDelegate(this.fileHandler, this.repository);

  final _controller = BehaviorSubject.seeded(ImportRidersState.idle);

  final FileHandler fileHandler;

  final SerializeRidersRepository repository;

  ImportRidersState get currentState => _controller.value;

  Stream<ImportRidersState> get stream => _controller;

  Future<Iterable<SerializableRider>> _readFileWithReader<T>(
    File file, {
    required ImportRidersFileReader<T> reader,
  }) async {
    final items = <SerializableRider>[];

    final List<T> chunks = await reader.readFile(file);

    if (chunks.isEmpty) {
      return items;
    }

    // Process the chunks in parallel.
    // If an invalid chunk is encountered, it is skipped.
    // This prevents a single invalid chunk from aborting the entire import.
    await Future.wait<void>(chunks.map((c) => reader.processChunk(c, items)));

    return items;
  }

  /// Read the contents of [file] and extract the [SerializableRider]s.
  ///
  /// Returns the collection of [SerializableRider]s.
  ///
  /// Throws a [FormatException] if the file is malformed.
  Future<Iterable<SerializableRider>> _readRidersFromFile(File file) {
    if (file.path.endsWith(ExportFileFormat.csv.formatExtension)) {
      return _readFileWithReader<String>(
        file,
        reader: ImportRidersCsvReader(),
      );
    }

    if (file.path.endsWith(ExportFileFormat.json.formatExtension)) {
      return _readFileWithReader<Map<String, dynamic>>(
        file,
        reader: ImportRidersJsonReader(),
      );
    }

    return Future.error(UnsupportedFileFormatError());
  }

  /// Import riders from a chosen file.
  ///
  /// The [whenComplete] handler is called
  /// when the riders are imported successfully.
  ///
  /// If no file was chosen a [FileRequiredException] is emitted through [stream].
  /// If the chosen file is of an unsupported format,
  /// an [UnsupportedFileFormatError] is emitted through the [stream].
  ///
  /// If the chosen file is malformed, a [FormatException] is emitted through the [stream].
  void importRiders({required void Function() whenComplete}) async {
    try {
      _controller.add(ImportRidersState.pickingFile);

      final file = await fileHandler.pickImportRidersDataSource();

      if (_controller.isClosed) {
        return;
      }

      if (file == null) {
        _controller.addError(FileRequiredException());

        return;
      }

      _controller.add(ImportRidersState.importing);

      final items = await _readRidersFromFile(file);

      if (_controller.isClosed) {
        return;
      }

      if (items.isEmpty) {
        _controller.add(ImportRidersState.done);

        return;
      }

      await repository.saveSerializableRiders(items);

      if (!_controller.isClosed) {
        _controller.add(ImportRidersState.done);
      }

      whenComplete();
    } catch (error) {
      if (!_controller.isClosed) {
        _controller.addError(error);
      }
    }
  }

  /// Dispose of this delegate.
  void dispose() {
    _controller.close();
  }
}
