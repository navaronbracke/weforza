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

  static m4(maxLength) => "Een adres mag niet langer zijn dan ${maxLength} karakters";

  static m5(maxDistance) => "De afstand van een rit mag niet groter zijn dan ${maxDistance} Km";

  static m6(maxLength) => "Een titel mag niet langer zijn dan ${maxLength} karakters";

  static m7(path) => "Rit opgeslagen op ${path}";

  static m8(date) => "rit_${date}";

  static m9(maxLength) => "Een bestandsnaam mag niet langer zijn dan ${maxLength} karakters";

  static m10(maxLength) => "Een voornaam is maximum ${maxLength} letters";

  static m11(maxLength) => "Familienaam kan niet langer zijn dan ${maxLength} letters";

  static m12(firstName, alias, lastName) => "Eigendom van:  ${firstName} \'${alias}\' ${lastName}";

  static m13(value) => "${value} is verplicht";

  final messages = _notInlinedMessages(_notInlinedMessages);
  static _notInlinedMessages(_) => <String, Function> {
    "AddDeviceError" : MessageLookupByLibrary.simpleMessage("Kon toestel niet toevoegen"),
    "AddDeviceSubmit" : MessageLookupByLibrary.simpleMessage("Toestel Aanmaken"),
    "AddDeviceTitle" : MessageLookupByLibrary.simpleMessage("Toestel Toevoegen"),
    "AddMemberError" : MessageLookupByLibrary.simpleMessage("Kon lid niet toevoegen"),
    "AddMemberSubmit" : MessageLookupByLibrary.simpleMessage("Voeg nieuw lid toe"),
    "AddMemberTitle" : MessageLookupByLibrary.simpleMessage("Nieuw lid"),
    "AddRideColorLegendCurrentSelection" : MessageLookupByLibrary.simpleMessage("Huidige Selectie"),
    "AddRideColorLegendFutureRide" : MessageLookupByLibrary.simpleMessage("Toekomstige Rit"),
    "AddRideColorLegendPastDay" : MessageLookupByLibrary.simpleMessage("Gepasseerde Dag Zonder Rit"),
    "AddRideColorLegendPastRide" : MessageLookupByLibrary.simpleMessage("Gepasseerde Dag Met Rit"),
    "AddRideEmptySelection" : MessageLookupByLibrary.simpleMessage("Gelieve minimum één datum te kiezen"),
    "AddRideError" : MessageLookupByLibrary.simpleMessage("Kon ritten niet toevoegen"),
    "AddRideLoadingFailed" : MessageLookupByLibrary.simpleMessage("Kon de kalender niet laden"),
    "AddRideSubmit" : MessageLookupByLibrary.simpleMessage("Selectie Toevoegen"),
    "AddRideTitle" : MessageLookupByLibrary.simpleMessage("Nieuwe Rit"),
    "AliasBlank" : MessageLookupByLibrary.simpleMessage("Een alias mag niet enkel witruimte zijn"),
    "AliasIllegalCharacters" : MessageLookupByLibrary.simpleMessage("Een alias mag enkel letters, spaties of \' - bevatten"),
    "AliasMaxLength" : m0,
    "AppName" : MessageLookupByLibrary.simpleMessage("WeForza"),
    "AppVersionBuildNumber" : m1,
    "AppVersionNumber" : m2,
    "DeleteDeviceDescription" : MessageLookupByLibrary.simpleMessage("Bent u zeker dat u dit toestel wil verwijderen?"),
    "DeleteDeviceErrorDescription" : MessageLookupByLibrary.simpleMessage("Kon toestel niet verwijderen"),
    "DeleteDeviceTitle" : MessageLookupByLibrary.simpleMessage("Verwijder Toestel"),
    "DeviceAlreadyExists" : MessageLookupByLibrary.simpleMessage("Dit toestel bestaat al"),
    "DeviceCadenceMeter" : MessageLookupByLibrary.simpleMessage("Cadansmeter"),
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
    "DevicesListHeader" : MessageLookupByLibrary.simpleMessage("Toestellen"),
    "DevicesListNoDevices" : MessageLookupByLibrary.simpleMessage("Geen toestellen om te tonen"),
    "DialogCancel" : MessageLookupByLibrary.simpleMessage("Annuleren"),
    "DialogDelete" : MessageLookupByLibrary.simpleMessage("Verwijderen"),
    "DialogDismiss" : MessageLookupByLibrary.simpleMessage("Ok"),
    "DistanceKm" : MessageLookupByLibrary.simpleMessage("Km"),
    "EditDeviceError" : MessageLookupByLibrary.simpleMessage("Kon toestel niet bewerken"),
    "EditDeviceSubmit" : MessageLookupByLibrary.simpleMessage("Wijzigingen Opslaan"),
    "EditDeviceTitle" : MessageLookupByLibrary.simpleMessage("Toestel Bewerken"),
    "EditMemberError" : MessageLookupByLibrary.simpleMessage("Kon de wijzigingen niet opslaan"),
    "EditMemberSubmit" : MessageLookupByLibrary.simpleMessage("Wijzigingen Opslaan"),
    "EditMemberTitle" : MessageLookupByLibrary.simpleMessage("Lid Bewerken"),
    "EditRideAddressInvalid" : MessageLookupByLibrary.simpleMessage("Een adres mag enkel letters, nummers, spaties of # , ; : \' & / ° . ( ) - bevatten"),
    "EditRideAddressMaxLength" : m4,
    "EditRideAddressWhitespace" : MessageLookupByLibrary.simpleMessage("Een adres mag niet enkel witruimte zijn"),
    "EditRideDepartureLabel" : MessageLookupByLibrary.simpleMessage("Vertrek"),
    "EditRideDestinationLabel" : MessageLookupByLibrary.simpleMessage("Bestemming"),
    "EditRideDistanceInvalid" : MessageLookupByLibrary.simpleMessage("Gelieve een geldige afstand in te geven"),
    "EditRideDistanceLabel" : MessageLookupByLibrary.simpleMessage("Afstand"),
    "EditRideDistanceMaximum" : m5,
    "EditRideDistancePositive" : MessageLookupByLibrary.simpleMessage("Een afstand moet groter zijn dan nul"),
    "EditRidePageTitle" : MessageLookupByLibrary.simpleMessage("Rit Bewerken"),
    "EditRideSubmit" : MessageLookupByLibrary.simpleMessage("Wijzigingen Opslaan"),
    "EditRideSubmitError" : MessageLookupByLibrary.simpleMessage("Kon de wijzigingen niet opslaan"),
    "EditRideTitleLabel" : MessageLookupByLibrary.simpleMessage("Titel"),
    "EditRideTitleMaxLength" : m6,
    "EditRideTitleWhitespace" : MessageLookupByLibrary.simpleMessage("Een titel mag niet enkel witruimte zijn"),
    "Export" : MessageLookupByLibrary.simpleMessage("Exporteren"),
    "ExportRideExportedToPathMessage" : m7,
    "ExportRideExportingToFile" : MessageLookupByLibrary.simpleMessage("Rit exporteren naar bestand"),
    "ExportRideFileNamePlaceholder" : m8,
    "ExportRideTitle" : MessageLookupByLibrary.simpleMessage("Rit Exporteren"),
    "ExportRidesTitle" : MessageLookupByLibrary.simpleMessage("Ritten Exporteren"),
    "ExportingRidesDescription" : MessageLookupByLibrary.simpleMessage("Ritten en aanwezigen exporteren"),
    "FileCsvExtension" : MessageLookupByLibrary.simpleMessage("csv"),
    "FileExists" : MessageLookupByLibrary.simpleMessage("Dit bestand bestaat al"),
    "FileJsonExtension" : MessageLookupByLibrary.simpleMessage("json"),
    "Filename" : MessageLookupByLibrary.simpleMessage("Bestandsnaam"),
    "FilenameMaxLength" : m9,
    "FilenameWhitespace" : MessageLookupByLibrary.simpleMessage("Een bestandsnaam mag niet enkel witruimte zijn"),
    "FirstNameBlank" : MessageLookupByLibrary.simpleMessage("Voornaam mag niet enkel witruimte zijn"),
    "FirstNameIllegalCharacters" : MessageLookupByLibrary.simpleMessage("Voornaam mag enkel letters, spaties of \' - bevatten"),
    "FirstNameMaxLength" : m10,
    "FridayPrefix" : MessageLookupByLibrary.simpleMessage("Vr"),
    "GenericError" : MessageLookupByLibrary.simpleMessage("Er liep iets fout"),
    "GoBack" : MessageLookupByLibrary.simpleMessage("Keer Terug"),
    "HomePageMembersTab" : MessageLookupByLibrary.simpleMessage("Leden"),
    "HomePageRidesTab" : MessageLookupByLibrary.simpleMessage("Ritten"),
    "HomePageSettingsTab" : MessageLookupByLibrary.simpleMessage("Instellingen"),
    "ImportMembersCsvHeaderExample" : MessageLookupByLibrary.simpleMessage("voornaam,familienaam,alias,toestellen"),
    "ImportMembersCsvHeaderExampleDescription" : MessageLookupByLibrary.simpleMessage("Een mogelijke csv hoofding ziet er zo uit:"),
    "ImportMembersCsvHeaderRegex" : MessageLookupByLibrary.simpleMessage("(voornaam)\\,(achternaam|familienaam),(alias|bijnaam)\\,(toestellen|apparaten)(.*)"),
    "ImportMembersHeaderStrippedMessage" : MessageLookupByLibrary.simpleMessage("Als er een hoofding aanwezig is wordt deze verwijderd"),
    "ImportMembersImporting" : MessageLookupByLibrary.simpleMessage("Leden Importeren"),
    "ImportMembersInvalidFileFormat" : MessageLookupByLibrary.simpleMessage("Enkel CSV bestanden zijn toegelaten"),
    "ImportMembersPageTitle" : MessageLookupByLibrary.simpleMessage("Importeer Leden"),
    "ImportMembersPickFile" : MessageLookupByLibrary.simpleMessage("Kies Bestand"),
    "ImportMembersPickFileWarning" : MessageLookupByLibrary.simpleMessage("Een bestand is vereist om leden te importeren"),
    "InvalidFilename" : MessageLookupByLibrary.simpleMessage("Ongeldige bestandsnaam"),
    "LastNameBlank" : MessageLookupByLibrary.simpleMessage("Familienaam mag niet enkel witruimte zijn"),
    "LastNameIllegalCharacters" : MessageLookupByLibrary.simpleMessage("Familienaam mag enkel letters,spaties of \' - bevatten"),
    "LastNameMaxLength" : m11,
    "MemberAlreadyExists" : MessageLookupByLibrary.simpleMessage("Dit lid bestaat al"),
    "MemberDeleteDialogDescription" : MessageLookupByLibrary.simpleMessage("Bent u zeker dat u dit lid wil verwijderen?"),
    "MemberDeleteDialogErrorDescription" : MessageLookupByLibrary.simpleMessage("Kon lid niet verwijderen"),
    "MemberDeleteDialogTitle" : MessageLookupByLibrary.simpleMessage("Verwijder Lid"),
    "MemberDetailsLoadDevicesError" : MessageLookupByLibrary.simpleMessage("Kon toestellen niet laden"),
    "MemberDetailsLoadPictureError" : MessageLookupByLibrary.simpleMessage("Kon profielfoto niet laden"),
    "MemberDetailsNoDevices" : MessageLookupByLibrary.simpleMessage("Dit lid heeft nog geen toestellen"),
    "MemberDetailsNoDevicesAddDevice" : MessageLookupByLibrary.simpleMessage("Voeg een toestel toe"),
    "MemberDetailsTitle" : MessageLookupByLibrary.simpleMessage("Details"),
    "MemberListAddMemberInstruction" : MessageLookupByLibrary.simpleMessage("Voeg leden toe via het menu hierboven"),
    "MemberListLoadingFailed" : MessageLookupByLibrary.simpleMessage("Kon leden niet laden"),
    "MemberListNoItems" : MessageLookupByLibrary.simpleMessage("Er zijn geen leden om te tonen"),
    "MemberListTitle" : MessageLookupByLibrary.simpleMessage("Leden"),
    "MemberPickImageError" : MessageLookupByLibrary.simpleMessage("Kon afbeelding niet laden"),
    "MondayPrefix" : MessageLookupByLibrary.simpleMessage("Ma"),
    "PersonAliasLabel" : MessageLookupByLibrary.simpleMessage("Alias"),
    "PersonFirstNameLabel" : MessageLookupByLibrary.simpleMessage("Voornaam"),
    "PersonLastNameLabel" : MessageLookupByLibrary.simpleMessage("Familienaam"),
    "RideAttendeeScanningBluetoothDisabled" : MessageLookupByLibrary.simpleMessage("Scan geannuleerd, Bluetooth staat uit"),
    "RideAttendeeScanningGoBackToDetailPage" : MessageLookupByLibrary.simpleMessage("Terug naar detailpagina"),
    "RideAttendeeScanningGoToSettings" : MessageLookupByLibrary.simpleMessage("Naar Instellingen"),
    "RideAttendeeScanningManualSelectionEmptyList" : MessageLookupByLibrary.simpleMessage("Er zijn geen leden om uit te kiezen"),
    "RideAttendeeScanningNoMembers" : MessageLookupByLibrary.simpleMessage("Kan niet beginnen scannen, er zijn geen leden"),
    "RideAttendeeScanningPermissionDenied" : MessageLookupByLibrary.simpleMessage("Scan geannuleerd, toestemming werd geweigerd"),
    "RideAttendeeScanningPermissionDescription" : MessageLookupByLibrary.simpleMessage("Scannen vereist toegang tot je locatie"),
    "RideAttendeeScanningPreparingScan" : MessageLookupByLibrary.simpleMessage("Scan Voorbereiden"),
    "RideAttendeeScanningProcessAddMembersLabel" : MessageLookupByLibrary.simpleMessage("Manueel"),
    "RideAttendeeScanningProcessScanLabel" : MessageLookupByLibrary.simpleMessage("Scannen"),
    "RideAttendeeScanningRetryScan" : MessageLookupByLibrary.simpleMessage("Opnieuw Scannen"),
    "RideAttendeeScanningSaveManualResults" : MessageLookupByLibrary.simpleMessage("Selectie Opslaan"),
    "RideAttendeeScanningSaveScanResults" : MessageLookupByLibrary.simpleMessage("Scan Resultaten Opslaan"),
    "RideAttendeeScanningScanResultDeviceOwnedByLabel" : m12,
    "RideAttendeeScanningSkipScan" : MessageLookupByLibrary.simpleMessage("Scan Overslaan"),
    "RideDeleteDialogDescription" : MessageLookupByLibrary.simpleMessage("Bent u zeker dat u deze rit wil verwijderen?"),
    "RideDeleteDialogErrorDescription" : MessageLookupByLibrary.simpleMessage("Kon rit niet verwijderen"),
    "RideDeleteDialogTitle" : MessageLookupByLibrary.simpleMessage("Verwijder Rit"),
    "RideDestination" : MessageLookupByLibrary.simpleMessage("Bestemming"),
    "RideDetailsDeleteOption" : MessageLookupByLibrary.simpleMessage("Verwijderen"),
    "RideDetailsEditOption" : MessageLookupByLibrary.simpleMessage("Bewerken"),
    "RideDetailsExportOption" : MessageLookupByLibrary.simpleMessage("Exporteren"),
    "RideDetailsLoadAttendeesError" : MessageLookupByLibrary.simpleMessage("Kon de aanwezigen niet laden"),
    "RideDetailsNoAttendees" : MessageLookupByLibrary.simpleMessage("Deze rit heeft geen aanwezigen"),
    "RideListAddRideInstruction" : MessageLookupByLibrary.simpleMessage("Voeg ritten toe via het menu hierboven"),
    "RideListLoadingRidesError" : MessageLookupByLibrary.simpleMessage("Kon ritten niet laden"),
    "RideListNoRides" : MessageLookupByLibrary.simpleMessage("Er zijn geen ritten"),
    "RideListRidesHeader" : MessageLookupByLibrary.simpleMessage("Ritten"),
    "RideStart" : MessageLookupByLibrary.simpleMessage("Vertrek"),
    "SaturdayPrefix" : MessageLookupByLibrary.simpleMessage("Za"),
    "SettingsLoading" : MessageLookupByLibrary.simpleMessage("Instellingen Laden"),
    "SettingsLoadingError" : MessageLookupByLibrary.simpleMessage("Kon de instellingen niet laden"),
    "SettingsScanSliderHeader" : MessageLookupByLibrary.simpleMessage("Duur van een scan (in seconden)"),
    "SettingsSubmitError" : MessageLookupByLibrary.simpleMessage("Kon de instellingen niet opslaan"),
    "SettingsTitle" : MessageLookupByLibrary.simpleMessage("Instellingen"),
    "SundayPrefix" : MessageLookupByLibrary.simpleMessage("Zo"),
    "ThursdayPrefix" : MessageLookupByLibrary.simpleMessage("Do"),
    "TuesdayPrefix" : MessageLookupByLibrary.simpleMessage("Di"),
    "UnknownDate" : MessageLookupByLibrary.simpleMessage("Onbekende Datum"),
    "ValueIsRequired" : m13,
    "WednesdayPrefix" : MessageLookupByLibrary.simpleMessage("Wo")
  };
}
