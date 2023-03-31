/// This enum declares the different steps that the bluetooth scan runs through.
enum ScanProcessStep {
  INIT,//Check bluetooth on, then load settings and members
  SCAN,//scanning
  MANUAL,//scanning results were confirmed and we are in the manual assignment step
  BLUETOOTH_DISABLED,//bluetooth is off
  STOPPING_SCAN,//the scan is stopping
  PERMISSION_DENIED,//the app didn't have the required permission to start scanning.
}