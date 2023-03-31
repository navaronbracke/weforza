import 'package:weforza/model/settings.dart';

/// This class represents the extended application settings.
class ExtendedSettings {
  ExtendedSettings(this.generalSettings, this.hasRideCalendar);

  /// The generic app settings.
  final Settings generalSettings;

  /// Whether the app has a ride calendar.
  final bool hasRideCalendar;
}
