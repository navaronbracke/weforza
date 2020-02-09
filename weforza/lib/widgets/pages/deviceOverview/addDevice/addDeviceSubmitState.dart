///This enum declares the different states for the Add Device input.
///[AddDeviceSubmitState.IDLE] There is no addition taking place.
///[AddDeviceSubmitState.SUBMIT] A device is being added.
///[AddDeviceSubmitState.DEVICE_EXISTS] A device already exists.
///[AddDeviceSubmitState.ERROR] Something went wrong during the submit.
enum AddDeviceSubmitState {
  IDLE, SUBMIT, DEVICE_EXISTS, ERROR
}