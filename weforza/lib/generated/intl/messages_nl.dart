// DO NOT EDIT. This is code generated via package:intl/generate_localized.dart
// This is a library that provides messages for a nl locale. All the
// messages from the main program should be duplicated here with the same
// function name.

// Ignore issues from commonly used lints in this file.
// ignore_for_file:unnecessary_brace_in_string_interps, unnecessary_new
// ignore_for_file:prefer_single_quotes,comment_references, directives_ordering
// ignore_for_file:annotate_overrides,prefer_generic_function_type_aliases
// ignore_for_file:unused_import, file_names

import 'package:intl/intl.dart';
import 'package:intl/message_lookup_by_library.dart';

final messages = new MessageLookup();

typedef String MessageIfAbsent(String messageStr, List<dynamic> args);

class MessageLookup extends MessageLookupByLibrary {
  String get localeName => 'nl';

  static m0(maxLength) => "Een alias is maximum ${maxLength} letters";

  static m1(buildNumber) => "Build Nummer: ${buildNumber}";

  static m2(version) => "Versie: ${version}";

  static m3(maxLength) => "Naam Toestel is max. ${maxLength} tekens";

  static m4(date) => "rit_${date}";

  static m5(maxLength) => "Een bestandsnaam mag niet langer zijn dan ${maxLength} karakters";

  static m6(maxLength) => "Een voornaam is maximum ${maxLength} letters";

  static m7(maxLength) => "Familienaam kan niet langer zijn dan ${maxLength} letters";

  static m8(amount) => "${amount} renners hebben een toestel met deze naam";

  static m9(value) => "${value} is verplicht";

  final messages = _notInlinedMessages(_notInlinedMessages);
  static _notInlinedMessages(_) => <String, Function> {
    "Active" : MessageLookupByLibrary.simpleMessage("Actief"),
    "AddDeviceSubmit" : MessageLookupByLibrary.simpleMessage("Toestel toevoegen"),
    "AddDeviceTitle" : MessageLookupByLibrary.simpleMessage("Toestel Toevoegen"),
    "AddMemberSubmit" : MessageLookupByLibrary.simpleMessage("Voeg renner toe"),
    "AddMemberTitle" : MessageLookupByLibrary.simpleMessage("Nieuwe Renner"),
    "AddRideColorLegendCurrentSelection" : MessageLookupByLibrary.simpleMessage("Huidige Selectie"),
    "AddRideColorLegendFutureRide" : MessageLookupByLibrary.simpleMessage("Toekomstige Rit"),
    "AddRideColorLegendPastDay" : MessageLookupByLibrary.simpleMessage("Gepasseerde Dag Zonder Rit"),
    "AddRideColorLegendPastRide" : MessageLookupByLibrary.simpleMessage("Gepasseerde Dag Met Rit"),
    "AddRideEmptySelection" : MessageLookupByLibrary.simpleMessage("Gelieve minimum één datum te kiezen"),
    "AddRideSubmit" : MessageLookupByLibrary.simpleMessage("Selectie Toevoegen"),
    "AddRideTitle" : MessageLookupByLibrary.simpleMessage("Nieuwe Rit"),
    "AliasBlank" : MessageLookupByLibrary.simpleMessage("Een alias mag niet enkel witruimte zijn"),
    "AliasIllegalCharacters" : MessageLookupByLibrary.simpleMessage("Een alias mag enkel letters, spaties of \' - bevatten"),
    "AliasMaxLength" : m0,
    "All" : MessageLookupByLibrary.simpleMessage("Alle"),
    "AppVersionBuildNumber" : m1,
    "AppVersionNumber" : m2,
    "Attendees" : MessageLookupByLibrary.simpleMessage("Aanwezigen"),
    "Cancel" : MessageLookupByLibrary.simpleMessage("Annuleren"),
    "Delete" : MessageLookupByLibrary.simpleMessage("Verwijderen"),
    "DeleteDeviceDescription" : MessageLookupByLibrary.simpleMessage("Bent u zeker dat u dit toestel wil verwijderen?"),
    "DeleteDeviceTitle" : MessageLookupByLibrary.simpleMessage("Verwijder Toestel"),
    "Details" : MessageLookupByLibrary.simpleMessage("Details"),
    "DeviceCadenceMeter" : MessageLookupByLibrary.simpleMessage("Cadansmeter"),
    "DeviceExists" : MessageLookupByLibrary.simpleMessage("Deze persoon heeft reeds een toestel met deze naam"),
    "DeviceGPS" : MessageLookupByLibrary.simpleMessage("GPS"),
    "DeviceHeadset" : MessageLookupByLibrary.simpleMessage("Koptelefoon"),
    "DeviceNameBlank" : MessageLookupByLibrary.simpleMessage("De naam van een toestel mag niet leeg zijn"),
    "DeviceNameCannotContainComma" : MessageLookupByLibrary.simpleMessage("De naam van een toestel mag geen , bevatten"),
    "DeviceNameLabel" : MessageLookupByLibrary.simpleMessage("Naam Toestel"),
    "DeviceNameMaxLength" : m3,
    "DevicePhone" : MessageLookupByLibrary.simpleMessage("Telefoon"),
    "DevicePowerMeter" : MessageLookupByLibrary.simpleMessage("Krachtmeter"),
    "DevicePulseMonitor" : MessageLookupByLibrary.simpleMessage("Hartslagmeter"),
    "DeviceUnknown" : MessageLookupByLibrary.simpleMessage("Onbekend"),
    "DeviceWatch" : MessageLookupByLibrary.simpleMessage("Horloge"),
    "Devices" : MessageLookupByLibrary.simpleMessage("Toestellen"),
    "DevicesListNoDevices" : MessageLookupByLibrary.simpleMessage("Geen toestellen om te tonen"),
    "EditDeviceTitle" : MessageLookupByLibrary.simpleMessage("Toestel Bewerken"),
    "EditMemberTitle" : MessageLookupByLibrary.simpleMessage("Renner Bewerken"),
    "Export" : MessageLookupByLibrary.simpleMessage("Exporteren"),
    "ExportMembersCsvHeader" : MessageLookupByLibrary.simpleMessage("voornaam,familienaam,alias,toestellen"),
    "ExportMembersTitle" : MessageLookupByLibrary.simpleMessage("Renners Exporteren"),
    "ExportRideExportingToFile" : MessageLookupByLibrary.simpleMessage("Rit exporteren naar bestand"),
    "ExportRideFileNamePlaceholder" : m4,
    "ExportRideTitle" : MessageLookupByLibrary.simpleMessage("Rit Exporteren"),
    "ExportRidesTitle" : MessageLookupByLibrary.simpleMessage("Ritten Exporteren"),
    "ExportingMembersDescription" : MessageLookupByLibrary.simpleMessage("Renners en toestellen exporteren"),
    "ExportingRidesDescription" : MessageLookupByLibrary.simpleMessage("Ritten en aanwezigen exporteren"),
    "FileCsvExtension" : MessageLookupByLibrary.simpleMessage("csv"),
    "FileExists" : MessageLookupByLibrary.simpleMessage("Dit bestand bestaat al"),
    "FileJsonExtension" : MessageLookupByLibrary.simpleMessage("json"),
    "Filename" : MessageLookupByLibrary.simpleMessage("Bestandsnaam"),
    "FilenameMaxLength" : m5,
    "FilenameWhitespace" : MessageLookupByLibrary.simpleMessage("Een bestandsnaam mag niet enkel witruimte zijn"),
    "Filter" : MessageLookupByLibrary.simpleMessage("Filter"),
    "FirstNameBlank" : MessageLookupByLibrary.simpleMessage("Voornaam mag niet enkel witruimte zijn"),
    "FirstNameIllegalCharacters" : MessageLookupByLibrary.simpleMessage("Voornaam mag enkel letters, spaties of \' - bevatten"),
    "FirstNameMaxLength" : m6,
    "FridayPrefix" : MessageLookupByLibrary.simpleMessage("Vr"),
    "GenericError" : MessageLookupByLibrary.simpleMessage("Er liep iets fout"),
    "GoBack" : MessageLookupByLibrary.simpleMessage("Keer Terug"),
    "ImportMembersCsvHeaderExample" : MessageLookupByLibrary.simpleMessage("voornaam,familienaam,alias,toestellen"),
    "ImportMembersCsvHeaderExampleDescription" : MessageLookupByLibrary.simpleMessage("Een mogelijke csv hoofding ziet er zo uit:"),
    "ImportMembersCsvHeaderRegex" : MessageLookupByLibrary.simpleMessage("(voornaam),(achternaam|familienaam),(alias|bijnaam),(actief),(toestellen|apparaten)(.*)"),
    "ImportMembersCsvHeaderRequired" : MessageLookupByLibrary.simpleMessage("Bij .csv bestanden is een hoofding verplicht."),
    "ImportMembersImporting" : MessageLookupByLibrary.simpleMessage("Renners Importeren"),
    "ImportMembersIncompatibleFileJsonContents" : MessageLookupByLibrary.simpleMessage("Het gekozen .json bestand is incompatibel."),
    "ImportMembersInvalidFileExtension" : MessageLookupByLibrary.simpleMessage("Enkel .csv of .json bestanden zijn toegelaten"),
    "ImportMembersPageTitle" : MessageLookupByLibrary.simpleMessage("Importeer Renners"),
    "ImportMembersPickFile" : MessageLookupByLibrary.simpleMessage("Kies Bestand"),
    "ImportMembersPickFileWarning" : MessageLookupByLibrary.simpleMessage("Een bestand is vereist om renners te importeren"),
    "Inactive" : MessageLookupByLibrary.simpleMessage("Inactief"),
    "InvalidFilename" : MessageLookupByLibrary.simpleMessage("Ongeldige bestandsnaam"),
    "LastNameBlank" : MessageLookupByLibrary.simpleMessage("Familienaam mag niet enkel witruimte zijn"),
    "LastNameIllegalCharacters" : MessageLookupByLibrary.simpleMessage("Familienaam mag enkel letters,spaties of \' - bevatten"),
    "LastNameMaxLength" : m7,
    "ListEmpty" : MessageLookupByLibrary.simpleMessage("Er is niets om te tonen"),
    "MemberAlreadyExists" : MessageLookupByLibrary.simpleMessage("Deze renner bestaat al"),
    "MemberDeleteDialogDescription" : MessageLookupByLibrary.simpleMessage("Bent u zeker dat u deze renner wil verwijderen?"),
    "MemberDeleteDialogTitle" : MessageLookupByLibrary.simpleMessage("Verwijder Renner"),
    "MemberDetailsNoDevices" : MessageLookupByLibrary.simpleMessage("Deze renner heeft nog geen toestellen"),
    "MondayPrefix" : MessageLookupByLibrary.simpleMessage("Ma"),
    "Ok" : MessageLookupByLibrary.simpleMessage("Ok"),
    "PersonAliasLabel" : MessageLookupByLibrary.simpleMessage("Alias"),
    "PersonFirstNameLabel" : MessageLookupByLibrary.simpleMessage("Voornaam"),
    "PersonLastNameLabel" : MessageLookupByLibrary.simpleMessage("Familienaam"),
    "RideAttendeeScanningBluetoothDisabled" : MessageLookupByLibrary.simpleMessage("Scan geannuleerd, Bluetooth staat uit"),
    "RideAttendeeScanningContinue" : MessageLookupByLibrary.simpleMessage("Doorgaan naar volgende stap"),
    "RideAttendeeScanningDeviceWithMultiplePossibleOwnersLabel" : m8,
    "RideAttendeeScanningGoBackToDetailPage" : MessageLookupByLibrary.simpleMessage("Terug naar detailpagina"),
    "RideAttendeeScanningGoToSettings" : MessageLookupByLibrary.simpleMessage("Naar Instellingen"),
    "RideAttendeeScanningManualSelectionEmptyList" : MessageLookupByLibrary.simpleMessage("Er zijn geen renners om uit te kiezen"),
    "RideAttendeeScanningNoMembers" : MessageLookupByLibrary.simpleMessage("Kan niet beginnen scannen, er zijn geen renners"),
    "RideAttendeeScanningPermissionDenied" : MessageLookupByLibrary.simpleMessage("Scan geannuleerd, toestemming werd geweigerd."),
    "RideAttendeeScanningPermissionDeniedDescription" : MessageLookupByLibrary.simpleMessage("Scannen vereist toegang tot je locatie."),
    "RideAttendeeScanningPreparingScan" : MessageLookupByLibrary.simpleMessage("Scan Voorbereiden"),
    "RideAttendeeScanningProcessAddMembersLabel" : MessageLookupByLibrary.simpleMessage("Manueel"),
    "RideAttendeeScanningProcessScanLabel" : MessageLookupByLibrary.simpleMessage("Scannen"),
    "RideAttendeeScanningRetryScan" : MessageLookupByLibrary.simpleMessage("Opnieuw Scannen"),
    "RideAttendeeScanningSkipScan" : MessageLookupByLibrary.simpleMessage("Scan Overslaan"),
    "RideAttendeeScanningUnresolvedOwnersListTooltip" : MessageLookupByLibrary.simpleMessage("Sommige gescande apparaten hebben meerdere mogelijke eigenaars. Je kan de aanwezige eigenaars hier selecteren."),
    "RideDeleteDialogDescription" : MessageLookupByLibrary.simpleMessage("Bent u zeker dat u deze rit wil verwijderen?"),
    "RideDeleteDialogTitle" : MessageLookupByLibrary.simpleMessage("Verwijder Rit"),
    "RideDetailsNoAttendees" : MessageLookupByLibrary.simpleMessage("Deze rit heeft geen aanwezigen"),
    "Riders" : MessageLookupByLibrary.simpleMessage("Renners"),
    "Rides" : MessageLookupByLibrary.simpleMessage("Ritten"),
    "SaturdayPrefix" : MessageLookupByLibrary.simpleMessage("Za"),
    "Save" : MessageLookupByLibrary.simpleMessage("Opslaan"),
    "SaveChanges" : MessageLookupByLibrary.simpleMessage("Save changes"),
    "Settings" : MessageLookupByLibrary.simpleMessage("Instellingen"),
    "SettingsLoading" : MessageLookupByLibrary.simpleMessage("Instellingen Laden"),
    "SettingsResetRideCalendarButtonLabel" : MessageLookupByLibrary.simpleMessage("Rittenkalender Resetten"),
    "SettingsResetRideCalendarDescription" : MessageLookupByLibrary.simpleMessage("Dit zal alle ritten verwijderen. De aanwezigheden worden terug op nul gezet."),
    "SettingsResetRideCalendarDialogConfirm" : MessageLookupByLibrary.simpleMessage("Kalender Leegmaken"),
    "SettingsResetRideCalendarDialogDescription" : MessageLookupByLibrary.simpleMessage("Bent u zeker dat u alle ritten wil verwijderen?"),
    "SettingsResetRideCalendarDialogTitle" : MessageLookupByLibrary.simpleMessage("Kalender Resetten"),
    "SettingsResetRideCalendarErrorMessage" : MessageLookupByLibrary.simpleMessage("Kon de rittenkalender niet verwijderen."),
    "SettingsScanSliderHeader" : MessageLookupByLibrary.simpleMessage("Duur van een scan (in seconden)"),
    "SundayPrefix" : MessageLookupByLibrary.simpleMessage("Zo"),
    "ThursdayPrefix" : MessageLookupByLibrary.simpleMessage("Do"),
    "TuesdayPrefix" : MessageLookupByLibrary.simpleMessage("Di"),
    "ValueIsRequired" : m9,
    "WednesdayPrefix" : MessageLookupByLibrary.simpleMessage("Wo")
  };
}
