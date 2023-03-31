import 'dart:convert';
import 'dart:io';

import 'package:weforza/exceptions/exceptions.dart';
import 'package:weforza/file/file_handler.dart';
import 'package:weforza/model/async_computation_delegate.dart';
import 'package:weforza/model/rider/serializable_rider.dart';
import 'package:weforza/repository/serialize_riders_repository.dart';

/// This class represents the delegate that handles exporting riders.
class ExportRidersDelegate extends AsyncComputationDelegate<void> {
  ExportRidersDelegate({
    required this.fileHandler,
    required this.serializeRidersRepository,
  });

  /// The file handler that will manage the underlying file.
  final FileHandler fileHandler;

  /// The repository that handles exporting the riders.
  final SerializeRidersRepository serializeRidersRepository;

  /// Save the given [riders] to the given [file].
  ///
  /// If the [fileExtension] is [FileExtension.csv],
  /// the [csvHeader] becomes the first line in the CSV output file.
  Future<void> _saveRidersToFile(
    File file,
    FileExtension fileExtension,
    Iterable<SerializableRider> riders,
    String csvHeader,
  ) {
    switch (fileExtension) {
      case FileExtension.csv:
        final buffer = StringBuffer();

        buffer.writeln(csvHeader);

        for (final rider in riders) {
          buffer.writeln(rider.toCsv());
        }

        return file.writeAsString(buffer.toString());
      case FileExtension.json:
        final data = <String, Object?>{
          'riders': riders.map((r) => r.toJson()).toList(),
        };

        return file.writeAsString(jsonEncode(data));
    }
  }

  /// Export the currently available riders to a file with the given [fileName]
  /// and [fileExtension].
  ///
  /// The [whenComplete] handler is called after the riders have been exported to the file.
  void exportRiders({
    required String csvHeader,
    required FileExtension fileExtension,
    required String fileName,
    required void Function() whenComplete,
  }) async {
    if (!canStartComputation()) {
      return;
    }

    try {
      final file = await fileHandler.createFile(fileName, fileExtension.ext);

      if (file.existsSync()) {
        throw FileExistsException();
      }

      final items = await serializeRidersRepository.getSerializableRiders();

      await _saveRidersToFile(file, fileExtension, items, csvHeader);

      setDone(null);
      whenComplete();
    } catch (error, stackTrace) {
      setError(error, stackTrace);
    }
  }
}
