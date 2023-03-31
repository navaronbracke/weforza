import 'package:meta/meta.dart';

/// This class wraps the state for exporting data.
class ExportDataOrError {
  ExportDataOrError({
    @required this.exporting,
    @required this.success,
  }): assert(exporting != null && success != null);

  /// Whether we are currently exporting.
  final bool exporting;
  /// Whether the exporting succeeded.
  final bool success;

  ExportDataOrError.idle(): this(success: false, exporting: false);

  ExportDataOrError.exporting(): this(success: false, exporting: true);

  ExportDataOrError.success(): this(success: true, exporting: false);
}