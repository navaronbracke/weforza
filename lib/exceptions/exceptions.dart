/// An exception that is thrown when a device already exists.
class DeviceExistsException implements Exception {}

/// An exception that is thrown when a file is required, but it was not provided.
class FileRequiredException implements Exception {}

/// An exception that is thrown when a rider already exists.
class RiderExistsException implements Exception {}

/// An exception that is thrown
/// when the scan results of a Bluetooth device scan could not be saved.
class SaveScanResultsException implements Exception {}

/// An exception that is thrown when a Bluetooth scanner could not be started.
class StartScanException implements Exception {}

/// An exception that is thrown when a Bluetooth scanner could not be stopped.
class StopScanException implements Exception {}

/// An exception that is thrown when a [File] was provided,
/// but the given file format is not supported.
class UnsupportedFileFormatException implements Exception {}

/// An exception that is thrown when permission to write to external storage is denied.
///
/// This permission is typically only used on Android 9 and lower.
class ExternalStoragePermissionDeniedException implements Exception {}
