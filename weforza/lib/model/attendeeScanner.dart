///This interface defines a contract for doing bluetooth scans to find Attendees.
abstract class AttendeeScanner {
  void startScan();

  void stopScan();
}