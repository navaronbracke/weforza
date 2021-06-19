// DO NOT EDIT. This is code generated via package:intl/generate_localized.dart
// This is a library that provides messages for a nl locale. All the
// messages from the main program should be duplicated here with the same
// function name.

// Ignore issues from commonly used lints in this file.
// ignore_for_file:unnecessary_brace_in_string_interps, unnecessary_new
// ignore_for_file:prefer_single_quotes,comment_references, directives_ordering
// ignore_for_file:annotate_overrides,prefer_generic_function_type_aliases
// ignore_for_file:unused_import, file_names, avoid_escaping_inner_quotes

import 'package:intl/intl.dart';
import 'package:intl/message_lookup_by_library.dart';

final messages = new MessageLookup();

typedef String MessageIfAbsent(String messageStr, List<dynamic> args);

class MessageLookup extends MessageLookupByLibrary {
  String get localeName => 'nl';

  static String m0(maxLength) => "Een alias is maximum ${maxLength} letters";

  static String m1(version) => "Versie: ${version}";

  static String m2(maxLength) => "Naam Toestel is max. ${maxLength} tekens";

  static String m3(date) => "rit_${date}";

  static String m4(maxLength) =>
      "Een bestandsnaam mag niet langer zijn dan ${maxLength} karakters";

  static String m5(maxLength) => "Een voornaam is maximum ${maxLength} letters";

  static String m6(maxLength) =>
      "Familienaam kan niet langer zijn dan ${maxLength} letters";

  static String m7(amount) =>
      "${amount} renners hebben een toestel met deze naam";

  static String m8(amount) => "Renners (${amount})";

  static String m9(value) => "${value} is verplicht";

  final messages = _notInlinedMessages(_notInlinedMessages);
  static Map<String, Function> _notInlinedMessages(_) => <String, Function>{
        "Active": MessageLookupByLibrary.simpleMessage("Actief"),
        "AddDeviceSubmit":
            MessageLookupByLibrary.simpleMessage("Toestel toevoegen"),
        "AddDeviceTitle":
            MessageLookupByLibrary.simpleMessage("Toestel Toevoegen"),
        "AddMemberSubmit":
            MessageLookupByLibrary.simpleMessage("Voeg renner toe"),
        "AddMemberTitle": MessageLookupByLibrary.simpleMessage("Nieuwe Renner"),
        "AddRideColorLegendCurrentSelection":
            MessageLookupByLibrary.simpleMessage("Huidige Selectie"),
        "AddRideColorLegendFutureRide":
            MessageLookupByLibrary.simpleMessage("Toekomstige Rit"),
        "AddRideColorLegendPastDay":
            MessageLookupByLibrary.simpleMessage("Gepasseerde Dag Zonder Rit"),
        "AddRideColorLegendPastRide":
            MessageLookupByLibrary.simpleMessage("Gepasseerde Dag Met Rit"),
        "AddRideEmptySelection": MessageLookupByLibrary.simpleMessage(
            "Gelieve minimum één datum te kiezen"),
        "AddRideSubmit":
            MessageLookupByLibrary.simpleMessage("Selectie Toevoegen"),
        "AddRideTitle": MessageLookupByLibrary.simpleMessage("Nieuwe Rit"),
        "AliasBlank": MessageLookupByLibrary.simpleMessage(
            "Een alias mag niet enkel witruimte zijn"),
        "AliasIllegalCharacters": MessageLookupByLibrary.simpleMessage(
            "Een alias mag enkel letters, spaties of \' - bevatten"),
        "AliasMaxLength": m0,
        "All": MessageLookupByLibrary.simpleMessage("Alle"),
        "AppVersionNumber": m1,
        "Cancel": MessageLookupByLibrary.simpleMessage("Annuleren"),
        "Delete": MessageLookupByLibrary.simpleMessage("Verwijderen"),
        "DeleteDeviceDescription": MessageLookupByLibrary.simpleMessage(
            "Bent u zeker dat u dit toestel wil verwijderen?"),
        "DeleteDeviceTitle":
            MessageLookupByLibrary.simpleMessage("Verwijder Toestel"),
        "Details": MessageLookupByLibrary.simpleMessage("Details"),
        "DeviceCadenceMeter":
            MessageLookupByLibrary.simpleMessage("Cadansmeter"),
        "DeviceExists": MessageLookupByLibrary.simpleMessage(
            "Deze persoon heeft reeds een toestel met deze naam"),
        "DeviceGPS": MessageLookupByLibrary.simpleMessage("GPS"),
        "DeviceHeadset": MessageLookupByLibrary.simpleMessage("Koptelefoon"),
        "DeviceNameBlank": MessageLookupByLibrary.simpleMessage(
            "De naam van een toestel mag niet leeg zijn"),
        "DeviceNameCannotContainComma": MessageLookupByLibrary.simpleMessage(
            "De naam van een toestel mag geen , bevatten"),
        "DeviceNameLabel": MessageLookupByLibrary.simpleMessage("Naam Toestel"),
        "DeviceNameMaxLength": m2,
        "DevicePhone": MessageLookupByLibrary.simpleMessage("Telefoon"),
        "DevicePowerMeter": MessageLookupByLibrary.simpleMessage("Krachtmeter"),
        "DevicePulseMonitor":
            MessageLookupByLibrary.simpleMessage("Hartslagmeter"),
        "DeviceUnknown": MessageLookupByLibrary.simpleMessage("Onbekend"),
        "DeviceWatch": MessageLookupByLibrary.simpleMessage("Horloge"),
        "Devices": MessageLookupByLibrary.simpleMessage("Toestellen"),
        "DevicesListNoDevices":
            MessageLookupByLibrary.simpleMessage("Geen toestellen om te tonen"),
        "EditDeviceTitle":
            MessageLookupByLibrary.simpleMessage("Toestel Bewerken"),
        "EditMemberTitle":
            MessageLookupByLibrary.simpleMessage("Renner Bewerken"),
        "Export": MessageLookupByLibrary.simpleMessage("Exporteren"),
        "ExportMembersCsvHeader": MessageLookupByLibrary.simpleMessage(
            "voornaam,achternaam,alias,actief,laatste_update,toestellen"),
        "ExportMembersTitle":
            MessageLookupByLibrary.simpleMessage("Renners Exporteren"),
        "ExportRideExportingToFile":
            MessageLookupByLibrary.simpleMessage("Rit exporteren naar bestand"),
        "ExportRideFileNamePlaceholder": m3,
        "ExportRideTitle":
            MessageLookupByLibrary.simpleMessage("Rit Exporteren"),
        "ExportRidesTitle":
            MessageLookupByLibrary.simpleMessage("Ritten Exporteren"),
        "ExportingMembersDescription": MessageLookupByLibrary.simpleMessage(
            "Renners en toestellen exporteren"),
        "ExportingRidesDescription": MessageLookupByLibrary.simpleMessage(
            "Ritten en aanwezigen exporteren"),
        "FileCsvExtension": MessageLookupByLibrary.simpleMessage("csv"),
        "FileExists":
            MessageLookupByLibrary.simpleMessage("Dit bestand bestaat al"),
        "FileJsonExtension": MessageLookupByLibrary.simpleMessage("json"),
        "Filename": MessageLookupByLibrary.simpleMessage("Bestandsnaam"),
        "FilenameMaxLength": m4,
        "FilenameWhitespace": MessageLookupByLibrary.simpleMessage(
            "Een bestandsnaam mag niet enkel witruimte zijn"),
        "Filter": MessageLookupByLibrary.simpleMessage("Filter"),
        "FirstNameBlank": MessageLookupByLibrary.simpleMessage(
            "Voornaam mag niet enkel witruimte zijn"),
        "FirstNameIllegalCharacters": MessageLookupByLibrary.simpleMessage(
            "Voornaam mag enkel letters, spaties of \' - bevatten"),
        "FirstNameMaxLength": m5,
        "FridayPrefix": MessageLookupByLibrary.simpleMessage("Vr"),
        "GenericError":
            MessageLookupByLibrary.simpleMessage("Er liep iets fout"),
        "GoBack": MessageLookupByLibrary.simpleMessage("Keer Terug"),
        "ImportMembersCsvHeaderExampleDescription":
            MessageLookupByLibrary.simpleMessage(
                "Een mogelijke csv hoofding ziet er zo uit:"),
        "ImportMembersCsvHeaderRegex": MessageLookupByLibrary.simpleMessage(
            "(voornaam),(achternaam),(alias),(actief),(laatste_update),(toestellen)(.*)"),
        "ImportMembersCsvHeaderRequired": MessageLookupByLibrary.simpleMessage(
            "Bij .csv bestanden is een hoofding verplicht."),
        "ImportMembersImporting":
            MessageLookupByLibrary.simpleMessage("Renners Importeren"),
        "ImportMembersIncompatibleFileJsonContents":
            MessageLookupByLibrary.simpleMessage(
                "Het gekozen .json bestand is incompatibel."),
        "ImportMembersInvalidFileExtension":
            MessageLookupByLibrary.simpleMessage(
                "Enkel .csv of .json bestanden zijn toegelaten"),
        "ImportMembersPageTitle":
            MessageLookupByLibrary.simpleMessage("Importeer Renners"),
        "ImportMembersPickFile":
            MessageLookupByLibrary.simpleMessage("Kies Bestand"),
        "ImportMembersPickFileWarning": MessageLookupByLibrary.simpleMessage(
            "Een bestand is vereist om renners te importeren"),
        "Inactive": MessageLookupByLibrary.simpleMessage("Inactief"),
        "InvalidFilename":
            MessageLookupByLibrary.simpleMessage("Ongeldige bestandsnaam"),
        "LastNameBlank": MessageLookupByLibrary.simpleMessage(
            "Familienaam mag niet enkel witruimte zijn"),
        "LastNameIllegalCharacters": MessageLookupByLibrary.simpleMessage(
            "Familienaam mag enkel letters,spaties of \' - bevatten"),
        "LastNameMaxLength": m6,
        "ListEmpty":
            MessageLookupByLibrary.simpleMessage("Er is niets om te tonen"),
        "MemberAlreadyExists":
            MessageLookupByLibrary.simpleMessage("Deze renner bestaat al"),
        "MemberDeleteDialogDescription": MessageLookupByLibrary.simpleMessage(
            "Bent u zeker dat u deze renner wil verwijderen?"),
        "MemberDeleteDialogTitle":
            MessageLookupByLibrary.simpleMessage("Verwijder Renner"),
        "MemberDetailsNoDevices": MessageLookupByLibrary.simpleMessage(
            "Deze renner heeft nog geen toestellen"),
        "MondayPrefix": MessageLookupByLibrary.simpleMessage("Ma"),
        "Ok": MessageLookupByLibrary.simpleMessage("Ok"),
        "PersonAliasLabel": MessageLookupByLibrary.simpleMessage("Alias"),
        "PersonFirstNameLabel":
            MessageLookupByLibrary.simpleMessage("Voornaam"),
        "PersonLastNameLabel":
            MessageLookupByLibrary.simpleMessage("Familienaam"),
        "RideAttendeeScanningBluetoothDisabled":
            MessageLookupByLibrary.simpleMessage(
                "Scan geannuleerd, Bluetooth staat uit"),
        "RideAttendeeScanningContinue":
            MessageLookupByLibrary.simpleMessage("Doorgaan"),
        "RideAttendeeScanningDeviceWithMultiplePossibleOwnersLabel": m7,
        "RideAttendeeScanningGoBackToDetailPage":
            MessageLookupByLibrary.simpleMessage("Terug naar detailpagina"),
        "RideAttendeeScanningGoToSettings":
            MessageLookupByLibrary.simpleMessage("Naar Instellingen"),
        "RideAttendeeScanningManualSelectionEmptyList":
            MessageLookupByLibrary.simpleMessage(
                "Er zijn geen renners om uit te kiezen"),
        "RideAttendeeScanningNoMembers": MessageLookupByLibrary.simpleMessage(
            "Kan niet beginnen scannen, er zijn geen renners"),
        "RideAttendeeScanningPermissionDenied":
            MessageLookupByLibrary.simpleMessage(
                "Scan geannuleerd, toestemming werd geweigerd."),
        "RideAttendeeScanningPermissionDeniedDescription":
            MessageLookupByLibrary.simpleMessage(
                "Scannen vereist toegang tot je locatie."),
        "RideAttendeeScanningPreparingScan":
            MessageLookupByLibrary.simpleMessage("Scan Voorbereiden"),
        "RideAttendeeScanningProcessAddMembersLabel":
            MessageLookupByLibrary.simpleMessage("Manueel"),
        "RideAttendeeScanningProcessScanLabel":
            MessageLookupByLibrary.simpleMessage("Scannen"),
        "RideAttendeeScanningRetryScan":
            MessageLookupByLibrary.simpleMessage("Opnieuw Scannen"),
        "RideAttendeeScanningSkipScan":
            MessageLookupByLibrary.simpleMessage("Scan Overslaan"),
        "RideAttendeeScanningUnresolvedOwnersListTooltip":
            MessageLookupByLibrary.simpleMessage(
                "Sommige gescande apparaten hebben meerdere mogelijke eigenaars. Je kan de aanwezige eigenaars hier selecteren."),
        "RideDeleteDialogDescription": MessageLookupByLibrary.simpleMessage(
            "Bent u zeker dat u deze rit wil verwijderen?"),
        "RideDeleteDialogTitle":
            MessageLookupByLibrary.simpleMessage("Verwijder Rit"),
        "RideDetailsNoAttendees": MessageLookupByLibrary.simpleMessage(
            "Deze rit heeft geen aanwezigen"),
        "RideDetailsScannedAttendeesTooltip":
            MessageLookupByLibrary.simpleMessage("Gescand"),
        "RideDetailsTotalAttendeesTooltip":
            MessageLookupByLibrary.simpleMessage("Totaal"),
        "RiderSearchFilterInputLabel":
            MessageLookupByLibrary.simpleMessage("Renners zoeken"),
        "RiderSearchFilterNoResults": MessageLookupByLibrary.simpleMessage(
            "Geen resultaten voor de opgegeven zoekterm"),
        "Riders": MessageLookupByLibrary.simpleMessage("Renners"),
        "RidersListTitle": m8,
        "Rides": MessageLookupByLibrary.simpleMessage("Ritten"),
        "SaturdayPrefix": MessageLookupByLibrary.simpleMessage("Za"),
        "Save": MessageLookupByLibrary.simpleMessage("Opslaan"),
        "SaveChanges": MessageLookupByLibrary.simpleMessage("Opslaan"),
        "Settings": MessageLookupByLibrary.simpleMessage("Instellingen"),
        "SettingsLoading":
            MessageLookupByLibrary.simpleMessage("Instellingen Laden"),
        "SettingsResetRideCalendarButtonLabel":
            MessageLookupByLibrary.simpleMessage("Kalender Resetten"),
        "SettingsResetRideCalendarDescription":
            MessageLookupByLibrary.simpleMessage(
                "Dit zal alle ritten verwijderen.\nDe aanwezigheden worden terug op nul gezet."),
        "SettingsResetRideCalendarDialogConfirm":
            MessageLookupByLibrary.simpleMessage("Resetten"),
        "SettingsResetRideCalendarDialogDescription":
            MessageLookupByLibrary.simpleMessage(
                "Bent u zeker dat u alle ritten wil verwijderen?"),
        "SettingsResetRideCalendarDialogTitle":
            MessageLookupByLibrary.simpleMessage("Kalender Resetten"),
        "SettingsResetRideCalendarErrorMessage":
            MessageLookupByLibrary.simpleMessage(
                "Kon de rittenkalender niet verwijderen."),
        "SettingsRiderFilterDescription": MessageLookupByLibrary.simpleMessage(
            "Filter renners in de rennerslijst, op basis van hun status"),
        "SettingsRiderFilterHeader":
            MessageLookupByLibrary.simpleMessage("Rennerslijst Filter"),
        "SettingsScanSliderHeader": MessageLookupByLibrary.simpleMessage(
            "Duur van een scan (in seconden)"),
        "SundayPrefix": MessageLookupByLibrary.simpleMessage("Zo"),
        "ThursdayPrefix": MessageLookupByLibrary.simpleMessage("Do"),
        "TuesdayPrefix": MessageLookupByLibrary.simpleMessage("Di"),
        "ValueIsRequired": m9,
        "WednesdayPrefix": MessageLookupByLibrary.simpleMessage("Wo")
      };
}
