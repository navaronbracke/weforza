/// This enum defines the supported file formats for exporting data.
enum ExportFileFormat {
  csv('.csv'),
  json('.json');

  const ExportFileFormat(this.formatExtension);

  /// The file extension for this file format.
  ///
  /// This value includes a leading dot.
  final String formatExtension;
}
