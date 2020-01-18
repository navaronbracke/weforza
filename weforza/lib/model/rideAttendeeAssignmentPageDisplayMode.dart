///This enum declares the different display states for [RideAttendeeAssignmentPage].
///[RideAttendeeAssignmentPageDisplayMode.IDLE] There is no loading or scanning, the screen is idle.
///This is where a person could manually assign attendees.
///[RideAttendeeAssignmentPageDisplayMode.LOADING] The page is loading the members,
///that will be available to pick from in [RideAttendeeAssignmentPageDisplayMode.IDLE] mode.
///[RideAttendeeAssignmentPageDisplayMode.SCANNING] There is a bluetooth scan going on.
///[RideAttendeeAssignmentPageDisplayMode.LOADING_ERROR] During loading of the members the loading has failed.
///[RideAttendeeAssignmentPageDisplayMode.SCANNING_ERROR] During scanning something went wrong.
enum RideAttendeeAssignmentPageDisplayMode {
  IDLE,
  LOADING,
  SCANNING,
  LOADING_ERROR,
  SCANNING_ERROR
}