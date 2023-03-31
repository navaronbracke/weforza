///This class defines a wrapper for application settings.
class Settings {
  Settings({
    this.scanDuration = 20,
    this.exportUrl = "",
    this.importUrl = "",
  }): assert(scanDuration != null && scanDuration > 0);

  ///The duration of a device scan, in seconds.
  ///Defaults to 20 seconds
  final int scanDuration;

  final String exportUrl;
  final String importUrl;

  ///Convert this object to a Map.
  Map<String,dynamic> toMap(){
    return {
      "scanDuration": scanDuration,
      "exportUrl": exportUrl,
      "importUrl": importUrl,
    };
  }

  ///Create a member from a Map and a given uuid.
  static Settings of(Map<String,dynamic> values){
    assert(values != null);
    return Settings(
      scanDuration: values["scanDuration"] ?? 20,
      exportUrl: values["exportUrl"] ?? "",
      importUrl: values["importUrl"] ?? "",
    );
  }
}