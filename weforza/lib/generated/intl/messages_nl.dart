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

  static m0(maxLength) => "Naam Toestel is max. ${maxLength} tekens";

  static m1(maxLength) => "Een adres mag niet langer zijn dan ${maxLength} karakters";

  static m2(maxDistance) => "De afstand van een rit mag niet groter zijn dan ${maxDistance} Km";

  static m3(maxLength) => "Een titel mag niet langer zijn dan ${maxLength} karakters";

  static m4(maxLength) => "Voornaam kan niet langer zijn dan ${maxLength} letters";

  static m5(maxLength) => "Familienaam kan niet langer zijn dan ${maxLength} letters";

  static m6(maxLength) => "Een telefoonnummer is maximum ${maxLength} cijfers lang";

  static m7(minLength) => "Een telefoonnummer is minimum ${minLength} cijfers lang";

  static m8(value) => "${value} is verplicht";

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
    "AppName" : MessageLookupByLibrary.simpleMessage("WeForza"),
    "DeleteDeviceDescription" : MessageLookupByLibrary.simpleMessage("Bent u zeker dat u dit toestel wil verwijderen?"),
    "DeleteDeviceErrorDescription" : MessageLookupByLibrary.simpleMessage("Kon toestel niet verwijderen"),
    "DeleteDeviceTitle" : MessageLookupByLibrary.simpleMessage("Verwijder Toestel"),
    "DeviceAlreadyExists" : MessageLookupByLibrary.simpleMessage("Dit toestel bestaat al"),
    "DeviceGPS" : MessageLookupByLibrary.simpleMessage("GPS"),
    "DeviceHeadset" : MessageLookupByLibrary.simpleMessage("Koptelefoon"),
    "DeviceNameCannotContainComma" : MessageLookupByLibrary.simpleMessage("De naam van een toestel mag geen , bevatten"),
    "DeviceNameLabel" : MessageLookupByLibrary.simpleMessage("Naam Toestel"),
    "DeviceNameMaxLength" : m0,
    "DevicePhone" : MessageLookupByLibrary.simpleMessage("Telefoon"),
    "DevicePulseMonitor" : MessageLookupByLibrary.simpleMessage("Hartslagmeter"),
    "DeviceTablet" : MessageLookupByLibrary.simpleMessage("Tablet"),
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
    "EditRideAddressMaxLength" : m1,
    "EditRideAddressWhitespace" : MessageLookupByLibrary.simpleMessage("Een adres mag niet enkel witruimte zijn"),
    "EditRideDepartureLabel" : MessageLookupByLibrary.simpleMessage("Vertrek"),
    "EditRideDestinationLabel" : MessageLookupByLibrary.simpleMessage("Bestemming"),
    "EditRideDistanceInvalid" : MessageLookupByLibrary.simpleMessage("Gelieve een geldige afstand in te geven"),
    "EditRideDistanceLabel" : MessageLookupByLibrary.simpleMessage("Afstand"),
    "EditRideDistanceMaximum" : m2,
    "EditRideDistancePositive" : MessageLookupByLibrary.simpleMessage("Een afstand moet groter zijn dan nul"),
    "EditRidePageTitle" : MessageLookupByLibrary.simpleMessage("Rit Bewerken"),
    "EditRideSubmit" : MessageLookupByLibrary.simpleMessage("Wijzigingen Opslaan"),
    "EditRideSubmitError" : MessageLookupByLibrary.simpleMessage("Kon de wijzigingen niet opslaan"),
    "EditRideTitleLabel" : MessageLookupByLibrary.simpleMessage("Titel"),
    "EditRideTitleMaxLength" : m3,
    "EditRideTitleWhitespace" : MessageLookupByLibrary.simpleMessage("Een titel mag niet enkel witruimte zijn"),
    "FirstNameBlank" : MessageLookupByLibrary.simpleMessage("Voornaam mag niet enkel witruimte zijn"),
    "FirstNameIllegalCharacters" : MessageLookupByLibrary.simpleMessage("Voornaam mag enkel letters, spaties of \' - bevatten"),
    "FirstNameMaxLength" : m4,
    "FridayPrefix" : MessageLookupByLibrary.simpleMessage("Vr"),
    "GenericError" : MessageLookupByLibrary.simpleMessage("Er liep iets fout"),
    "GoBack" : MessageLookupByLibrary.simpleMessage("Keer Terug"),
    "HomePageMembersTab" : MessageLookupByLibrary.simpleMessage("Leden"),
    "HomePageRidesTab" : MessageLookupByLibrary.simpleMessage("Ritten"),
    "HomePageSettingsTab" : MessageLookupByLibrary.simpleMessage("Instellingen"),
    "ImportMembersCsvHeaderRegex" : MessageLookupByLibrary.simpleMessage("(voornaam)\\,(achternaam|familienaam),(telefoon|telefoonnummer|gsm)\\,(toestellen|apparaten)"),
    "ImportMembersHeaderStrippedMessage" : MessageLookupByLibrary.simpleMessage("Als er een hoofding aanwezig is wordt deze verwijderd"),
    "ImportMembersImporting" : MessageLookupByLibrary.simpleMessage("Leden Importeren"),
    "ImportMembersInvalidFileFormat" : MessageLookupByLibrary.simpleMessage("Enkel CSV bestanden zijn toegelaten"),
    "ImportMembersPageTitle" : MessageLookupByLibrary.simpleMessage("Importeer Leden"),
    "ImportMembersPickFile" : MessageLookupByLibrary.simpleMessage("Kies Bestand"),
    "ImportMembersPickFileWarning" : MessageLookupByLibrary.simpleMessage("Een bestand is vereist om leden te importeren"),
    "LastNameBlank" : MessageLookupByLibrary.simpleMessage("Familienaam mag niet enkel witruimte zijn"),
    "LastNameIllegalCharacters" : MessageLookupByLibrary.simpleMessage("Familienaam mag enkel letters,spaties of \' - bevatten"),
    "LastNameMaxLength" : m5,
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
    "PersonFirstNameLabel" : MessageLookupByLibrary.simpleMessage("Voornaam"),
    "PersonLastNameLabel" : MessageLookupByLibrary.simpleMessage("Familienaam"),
    "PersonTelephoneLabel" : MessageLookupByLibrary.simpleMessage("Telefoon"),
    "PhoneIllegalCharacters" : MessageLookupByLibrary.simpleMessage("Een telefoonnummer bestaat enkel uit cijfers"),
    "PhoneMaxLength" : m6,
    "PhoneMinLength" : m7,
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
    "RideAttendeeScanningScanResultDeviceOwnedByLabel" : MessageLookupByLibrary.simpleMessage("Eigendom Van:"),
    "RideAttendeeScanningScanResultOwnerTelephoneLabel" : MessageLookupByLibrary.simpleMessage("tel: "),
    "RideAttendeeScanningSkipScan" : MessageLookupByLibrary.simpleMessage("Scan Overslaan"),
    "RideDeleteDialogDescription" : MessageLookupByLibrary.simpleMessage("Bent u zeker dat u deze rit wil verwijderen?"),
    "RideDeleteDialogErrorDescription" : MessageLookupByLibrary.simpleMessage("Kon rit niet verwijderen"),
    "RideDeleteDialogTitle" : MessageLookupByLibrary.simpleMessage("Verwijder Rit"),
    "RideDestination" : MessageLookupByLibrary.simpleMessage("Bestemming"),
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
    "ValueIsRequired" : m8,
    "WednesdayPrefix" : MessageLookupByLibrary.simpleMessage("Wo")
  };
}
