import 'dart:convert';
import 'dart:io';

import 'package:weforza/model/export/export_delegate.dart';
import 'package:weforza/model/export_file_format.dart';
import 'package:weforza/repository/export_rides_repository.dart';

/// This class represents the export options for a [ExportRidesDelegate].
class ExportRidesOptions {
  ExportRidesOptions({this.ride});

  /// The timestamp of the single ride that should be exported.
  ///
  /// If this is null, all the available rides should be exported.
  final DateTime? ride;
}

/// This class represents the delegate that handles exporting rides.
class ExportRidesDelegate extends ExportDelegate<ExportRidesOptions> {
  ExportRidesDelegate({
    required super.fileHandler,
    required super.initialFileName,
    required this.repository,
  });

  final ExportRidesRepository repository;

  @override
  Future<void> writeToFile(
    File file,
    ExportFileFormat fileFormat,
    ExportRidesOptions options,
  ) async {
    final rides = await repository.getRides(options.ride);

    switch (fileFormat) {
      case ExportFileFormat.csv:
        final buffer = StringBuffer();

        for (final ride in rides) {
          ride.toCsv(buffer);
        }

        await file.writeAsString(buffer.toString());
        break;
      case ExportFileFormat.json:
        final Map<String, Object?> data = {
          'rides': rides.map((r) => r.toJson()).toList()
        };

        await file.writeAsString(jsonEncode(data));
        break;
    }
  }
}
