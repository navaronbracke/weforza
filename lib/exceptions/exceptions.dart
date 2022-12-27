/// An exception that is thrown when a device already exists.
class DeviceExistsException implements Exception {}

/// An exception that is thrown when a [File] already exists.
class FileExistsException implements Exception {}

/// An exception that is thrown when a file is required, but it was not provided.
class FileRequiredException extends ArgumentError {
  FileRequiredException() : super('file');
}

class InvalidFileExtensionError extends ArgumentError {
  InvalidFileExtensionError() : super('Invalid file extension.');
}

/// An exception that is thrown when a rider already exists.
class RiderExistsException implements Exception {}
