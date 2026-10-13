import 'package:file/file.dart' as fs;
import 'package:flutter/foundation.dart' show ValueListenable, ValueNotifier;
import 'package:flutter_riverpod/flutter_riverpod.dart';
import 'package:weforza/exceptions/exceptions.dart';
import 'package:weforza/file/import_riders_csv_reader.dart';
import 'package:weforza/file/import_riders_file_reader.dart';
import 'package:weforza/file/import_riders_json_reader.dart';
import 'package:weforza/model/export/export_file_format.dart';
import 'package:weforza/model/import/import_file_delegate.dart';
import 'package:weforza/model/import/import_riders_state.dart';
import 'package:weforza/model/rider/serializable_rider.dart';
import 'package:weforza/repository/serialize_riders_repository.dart';

/// This class represents the delegate that handles importing riders.
class ImportRidersDelegate {
  ImportRidersDelegate(this._importFileDelegate, this._repository);

  final _notifier = ValueNotifier<AsyncValue<ImportRidersState>>(const AsyncData(ImportRidersState.idle));

  final ImportFileDelegate _importFileDelegate;

  final SerializeRidersRepository _repository;

  bool _isDisposed = false;

  ValueListenable<AsyncValue<ImportRidersState>> get listenable => _notifier;

  Future<Iterable<SerializableRider>> _readFileWithReader<T>(
    fs.File file, {
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
  Future<Iterable<SerializableRider>> _readRidersFromFile(fs.File file) async {
    if (file.path.endsWith(ExportFileFormat.csv.formatExtension)) {
      return _readFileWithReader<String>(file, reader: ImportRidersCsvReader());
    }

    if (file.path.endsWith(ExportFileFormat.json.formatExtension)) {
      return _readFileWithReader<Map<String, Object?>>(file, reader: ImportRidersJsonReader());
    }

    throw UnsupportedFileFormatException();
  }

  /// Import riders from a chosen file.
  ///
  /// The [whenComplete] handler is called
  /// when the riders are imported successfully.
  ///
  /// A [FileRequiredException] is emitted through [listenable] if no file was chosen.
  /// If the chosen file is of an unsupported format,
  /// an [UnsupportedFileFormatException] is emitted through the [listenable].
  ///
  /// If the chosen file is malformed, a [FormatException] is emitted through the [listenable].
  void importRiders({required void Function() whenComplete}) async {
    try {
      _notifier.value = const AsyncData(ImportRidersState.pickingFile);

      final file = await _importFileDelegate.pickImportRidersDataSource();

      if (_isDisposed) {
        return;
      }

      if (file == null) {
        _notifier.value = AsyncError(FileRequiredException(), StackTrace.current);

        return;
      }

      _notifier.value = const AsyncData(ImportRidersState.importing);

      final items = await _readRidersFromFile(file);

      if (_isDisposed) {
        return;
      }

      if (items.isEmpty) {
        _notifier.value = const AsyncData(ImportRidersState.done);

        return;
      }

      await _repository.saveSerializableRiders(items);

      if (!_isDisposed) {
        _notifier.value = const AsyncData(ImportRidersState.done);
      }

      whenComplete();
    } catch (error) {
      if (!_isDisposed) {
        _notifier.value = AsyncError(error, StackTrace.current);
      }
    }
  }

  /// Dispose of this delegate.
  void dispose() {
    if (_isDisposed) {
      return;
    }

    _isDisposed = true;
    _notifier.dispose();
  }
}
