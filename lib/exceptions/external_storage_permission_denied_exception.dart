/// An exception that is thrown when permission to read or write to external storage is denied.
///
/// This permission is only used on Android 9 and lower.
/// This permission is not used on other platforms.
final class ExternalStoragePermissionDeniedException implements Exception {}
