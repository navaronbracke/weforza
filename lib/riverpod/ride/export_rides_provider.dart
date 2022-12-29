import 'dart:convert';
import 'dart:io';

import 'package:flutter_riverpod/flutter_riverpod.dart';
import 'package:weforza/exceptions/exceptions.dart';
import 'package:weforza/file/file_handler.dart';
import 'package:weforza/model/export_file_format.dart';
import 'package:weforza/model/exportable_ride.dart';
import 'package:weforza/repository/export_rides_repository.dart';
import 'package:weforza/riverpod/file_handler_provider.dart';
import 'package:weforza/riverpod/repository/export_rides_repository_provider.dart';

final exportRidesProvider = Provider((ref) {
  return ExportRidesProvider(
    ref.read(exportRidesRepositoryProvider),
    ref.read(fileHandlerProvider),
  );
});

class ExportRidesProvider {
  ExportRidesProvider(this.exportRidesRepository, this.fileHandler);

  final ExportRidesRepository exportRidesRepository;

  final FileHandler fileHandler;

  // TODO: use export file format enum instead of string for extension

  /// Save the given [ExportableRide]s to the given file.
  /// The [formatExtension] determines how the data is structured inside the file.
  Future<void> _saveRidesToFile(
    File file,
    String formatExtension,
    Iterable<ExportableRide> rides,
  ) async {
    if (formatExtension == ExportFileFormat.csv.formatExtension) {
      final buffer = StringBuffer();

      for (final exportedRide in rides) {
        exportedRide.toCsv(buffer);
      }

      await file.writeAsString(buffer.toString());

      return;
    }

    if (formatExtension == ExportFileFormat.json.formatExtension) {
      final Map<String, Object?> data = {
        'rides': rides.map((e) => e.toJson()).toList()
      };

      await file.writeAsString(jsonEncode(data));

      return;
    }

    return Future.error(UnsupportedFileFormatError());
  }

  /// Export the rides and their attendees.
  ///
  /// If [ride] is not null, only this ride is exported.
  Future<void> exportRidesWithAttendees({
    required String fileName,
    required String fileFormatExtension,
    DateTime? ride,
  }) async {
    final rides = await exportRidesRepository.getRides(ride);

    final file = await fileHandler.getFile('$fileName$fileFormatExtension');

    if (file.existsSync()) {
      return Future.error(FileExistsException());
    }

    await _saveRidesToFile(file, fileFormatExtension, rides);
  }
}
