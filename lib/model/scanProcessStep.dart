/// This enum declares the different steps that the bluetooth scan runs through.
enum ScanProcessStep {
  /// The initialize scan phase is used to check if bluetooth is on
  /// and to load the scan settings and members / devices.
  init,

  /// A Bluetooth scan is in progress.
  scan,

  /// The scan itself has stopped. The manual selection phase has started.
  /// In the manual selection phase, members can be manually selected.
  manual,

  /// The scan itself has stopped. The conflict resolution phase has started.
  /// In the conflict resolution phase,
  /// the members of devices that conflicted with each other during the scan,
  /// can be manually selected.
  resolveMultipleOwners,

  /// The scan failed because Bluetooth is off.
  bluetoothDisabled,

  /// The scan is stopping,
  /// either due to manual cancellation or the scan time has been exceeded.
  stoppingScan,

  /// The scan failed because the app didn't
  /// get permission to use the required Bluetooth services.
  permissionDenied,
}
