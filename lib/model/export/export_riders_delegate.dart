import 'dart:convert';
import 'dart:io';

import 'package:weforza/model/export/export_delegate.dart';
import 'package:weforza/model/export/export_file_format.dart';
import 'package:weforza/repository/serialize_riders_repository.dart';

/// This class represents the export options for a [ExportRidersDelegate].
class ExportRidersOptions {
  const ExportRidersOptions({required this.csvHeader});

  /// The header that should be written to the file,
  /// if the export format is [ExportFileFormat.csv].
  final String csvHeader;
}

/// This class represents the delegate that handles exporting riders.
class ExportRidersDelegate extends ExportDelegate<ExportRidersOptions> {
  ExportRidersDelegate({
    required super.fileHandler,
    required this.serializeRidersRepository,
  });

  /// The repository that handles exporting the riders.
  final SerializeRidersRepository serializeRidersRepository;

  @override
  Future<void> writeToFile(
    File file,
    ExportFileFormat fileFormat,
    ExportRidersOptions options,
  ) async {
    final riders = await serializeRidersRepository.getSerializableRiders();

    switch (fileFormat) {
      case ExportFileFormat.csv:
        final buffer = StringBuffer();

        buffer.writeln(options.csvHeader);

        for (final rider in riders) {
          buffer.writeln(rider.toCsv());
        }

        await file.writeAsString(buffer.toString());
        break;
      case ExportFileFormat.json:
        final data = <String, Object?>{
          'riders': riders.map((r) => r.toJson()).toList(),
        };

        await file.writeAsString(jsonEncode(data));
        break;
    }
  }
}
