/// This enum declares the different steps that the bluetooth scan runs through.
enum ScanProcessStep {
  INIT,//Check bluetooth on, then load settings and members
  SCAN,//scanning
  MANUAL,//the manual selection, where all the members can be selected
  RESOLVE_MULTIPLE_OWNERS,//a variant of MANUAL, where owners (of devices with multiple possible owners) act as the items
  BLUETOOTH_DISABLED,//bluetooth is off
  STOPPING_SCAN,//the scan is stopping
  PERMISSION_DENIED,//the app didn't have the required permission to start scanning.
}