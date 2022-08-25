/// This enum defines the different states for the ride attendee scanning page.
enum RideAttendeeScanningState {
  /// The bluetooth adapter is currently off or unavailable.
  bluetoothDisabled,

  /// The manual selection is being displayed.
  manualSelection,

  /// One or more of the permissions
  /// that were requested in [requestPermissions] were not granted.
  permissionDenied,

  /// The permissions that are needed to scan for devices are being requested.
  requestPermissions,

  /// The device scan is currently running.
  scanning,

  /// The device scan is being prepared but has not started yet.
  startingScan,

  /// The device scan is being stopped.
  stoppingScan,

  /// The devices with unresolved owners are being displayed.
  ///
  /// Any device that was found, with more than one possible owner,
  /// cannot resolve its owner automatically.
  unresolvedOwnersSelection,
}
