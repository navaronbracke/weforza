/// This interface represents a delegate for saving the application settings.
abstract class SaveSettingsDelegate {
  /// Get the [Future] that represents the save computation.
  Future<void>? get saveSettingsFuture;

  /// Save the current settings.
  void saveSettings();
}
