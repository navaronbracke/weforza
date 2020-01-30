///This enum declares the display modes for the ride attendee assignment screen.
///[RideAttendeeDisplayMode.IDLE] The list of members will be shown here. A Scan can be started.
///[RideAttendeeDisplayMode.MEMBERS] The members are being loaded.
///[RideAttendeeDisplayMode.SCANNING] A Scan is processing.
///[RideAttendeeDisplayMode.SAVING] The attendees are being saved.
enum RideAttendeeDisplayMode {
  IDLE,
  MEMBERS,
  SCANNING,
  SAVING,
}