///This class defines a wrapper for application settings.
class Settings {
  Settings({
    this.scanDuration = 20
  }): assert(scanDuration != null && scanDuration > 0);

  ///The duration of a device scan, in seconds.
  ///Defaults to 20 seconds
  final int scanDuration;

  ///The private settings object
  static Settings _instance;

  ///Get the current [Settings].
  static Settings get instance => _instance;

  ///Update the current [Settings].
  static void updateSettings(Settings newSettings) => _instance = newSettings;

  ///Convert this object to a Map.
  Map<String,dynamic> toMap(){
    return {
      "scanDuration": scanDuration
    };
  }

  ///Create a member from a Map and a given uuid.
  static Settings of(Map<String,dynamic> values){
    assert(values != null);
    return Settings(
        scanDuration: values["scanDuration"],
    );
  }
}