class DeviceExistsException implements Exception {}

class FileExistsException implements Exception {}

class InvalidFileExtensionError extends ArgumentError {
  InvalidFileExtensionError() : super('Invalid file extension.');
}

class MemberExistsException implements Exception {}

class NoFileChosenError extends ArgumentError {
  NoFileChosenError() : super.notNull('No file was chosen.');
}
