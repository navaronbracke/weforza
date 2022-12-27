import 'package:weforza/file/file_handler.dart';

/// An exception that is thrown when a data source is malformed.
class DataSourceMalformedException extends FormatException {
  const DataSourceMalformedException(this.fileType, super.message);

  /// The file type of the invalid data source.
  final FileExtension fileType;
}

/// An exception that is thrown when a device already exists.
class DeviceExistsException implements Exception {}

/// An exception that is thrown when a [File] already exists.
class FileExistsException implements Exception {}

/// An exception that is thrown when a file is required, but it was not provided.
class FileRequiredException extends ArgumentError {
  FileRequiredException() : super('file');
}

/// An exception that is thrown when a rider already exists.
class RiderExistsException implements Exception {}

/// An exception that is thrown when a [File] was provided,
/// but the given file format is not supported.
class UnsupportedFileFormatError extends ArgumentError {
  UnsupportedFileFormatError() : super('File format not supported');
}
