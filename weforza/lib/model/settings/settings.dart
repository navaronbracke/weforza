///This class defines a wrapper for application settings.
class Settings {
  Settings({
    this.scanDuration = 20,
    this.showAllScannedDevices = true
  }): assert(scanDuration != null && scanDuration > 0
      && showAllScannedDevices != null
  );

  ///The duration of a device scan, in seconds.
  ///Defaults to 20 seconds
  final int scanDuration;
  ///Whether we should show all the scanned devices or only the ones we know of.
  ///Defaults to true.
  final bool showAllScannedDevices;

  ///The private settings object
  static Settings _instance;

  ///Get the current [Settings].
  static Settings get instance => _instance;

  ///Update the current [Settings].
  static void updateSettings(Settings newSettings) => _instance = newSettings;

  ///Convert this object to a Map.
  Map<String,dynamic> toMap(){
    return {
      "scanDuration": scanDuration,
      "showAllScannedDevices": showAllScannedDevices,
    };
  }

  ///Create a member from a Map and a given uuid.
  static Settings of(Map<String,dynamic> values){
    assert(values != null);
    return Settings(
        scanDuration: values["scanDuration"],
        showAllScannedDevices: values["showAllScannedDevices"]
    );
  }
}