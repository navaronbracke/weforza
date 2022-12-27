/// An exception that is thrown when a device already exists.
class DeviceExistsException implements Exception {}

/// An exception that is thrown when a [File] already exists.
class FileExistsException implements Exception {}

class InvalidFileExtensionError extends ArgumentError {
  InvalidFileExtensionError() : super('Invalid file extension.');
}

class NoFileChosenError extends ArgumentError {
  NoFileChosenError() : super.notNull('No file was chosen.');
}

/// An exception that is thrown when a rider already exists.
class RiderExistsException implements Exception {}
