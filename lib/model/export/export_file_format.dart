/// This enum defines the supported file formats for exporting data.
enum ExportFileFormat {
  /// The CSV export format.
  csv,

  /// The JSON export format.
  json;

  /// Get the file extension for this file format.
  ///
  /// This value includes a leading dot.
  String get formatExtension => '.$name';

  /// Get the name of this file format in uppercase.
  ///
  /// This value does **not** include a leading dot.
  String get asUpperCase => name.toUpperCase();
}
