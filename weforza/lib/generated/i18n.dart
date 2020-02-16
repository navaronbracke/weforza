import 'dart:async';

import 'package:flutter/foundation.dart';
import 'package:flutter/material.dart';

// ignore_for_file: non_constant_identifier_names
// ignore_for_file: camel_case_types
// ignore_for_file: prefer_single_quotes

// This file is automatically generated. DO NOT EDIT, all your changes would be lost.
class S implements WidgetsLocalizations {
  const S();

  static S current;

  static const GeneratedLocalizationsDelegate delegate =
    GeneratedLocalizationsDelegate();

  static S of(BuildContext context) => Localizations.of<S>(context, S);

  @override
  TextDirection get textDirection => TextDirection.ltr;

  String get AddDeviceError => "Could not add device";
  String get AddDeviceGenericError => "Something went wrong";
  String get AddDeviceSubmit => "Add Device";
  String get AddMemberError => "Could not add member";
  String get AddMemberSubmit => "Create New Member";
  String get AddMemberTitle => "New Member";
  String get AddRideColorLegendCurrentSelection => "Current Selection";
  String get AddRideColorLegendFutureRide => "Future Ride";
  String get AddRideColorLegendPastDay => "Past Day Without Ride";
  String get AddRideColorLegendPastRide => "Past Day With Ride";
  String get AddRideEmptySelection => "Please select at least one date";
  String get AddRideError => "Could not add rides";
  String get AddRideLoadingFailed => "Could not load Calendar";
  String get AddRideSubmit => "Add Selection";
  String get AddRideTitle => "New Ride";
  String get AppName => "WeForza";
  String get DeviceAlreadyExists => "This device already exists";
  String get DeviceGPS => "GPS";
  String get DeviceHeadset => "Headset";
  String get DeviceNameLabel => "Device Name";
  String get DeviceOverviewNoDevices => "No Devices";
  String get DeviceOverviewTitle => "Manage Devices";
  String get DevicePhone => "Phone";
  String get DevicePulseMonitor => "Pulse Monitor";
  String get DeviceTablet => "Tablet";
  String get DeviceTypeLabel => "Device Type";
  String get DeviceUnknown => "Unknown";
  String get DeviceWatch => "Watch";
  String get DevicesHeader => "Devices";
  String get DialogCancel => "Cancel";
  String get DialogDelete => "Delete";
  String get DialogOk => "Ok";
  String get DistanceKm => "Km";
  String get EditMemberError => "Failed to save the changes";
  String get EditMemberSubmit => "Save Changes";
  String get EditMemberTitle => "Edit Member";
  String get EditRideAddressInvalid => "An address can only contain letters, numbers, spaces and # , ; : ' & / ° . ( ) -";
  String get EditRideAddressWhitespace => "An address cannot be only whitespace";
  String get EditRideDepartureLabel => "Departure";
  String get EditRideDestinationLabel => "Destination";
  String get EditRideDistanceInvalid => "Please enter a valid distance";
  String get EditRideDistanceLabel => "Distance";
  String get EditRideDistancePositive => "Distance must be greater than zero";
  String get EditRidePageTitle => "Edit Ride";
  String get EditRideSubmit => "Save Changes";
  String get EditRideSubmitError => "Failed to save the changes";
  String get EditRideTitleLabel => "Title";
  String get EditRideTitleWhitespace => "A title can't be only whitespace";
  String get FirstNameBlank => "First Name can't be just whitespace";
  String get FirstNameIllegalCharacters => "First Name can only contain letters, spaces or ' -";
  String get FridayPrefix => "Fri";
  String get HomePageMembersTab => "Members";
  String get HomePageRidesTab => "Rides";
  String get LastNameBlank => "Last Name can't be just whitespace";
  String get LastNameIllegalCharacters => "Last Name can only contain letters, spaces or ' -";
  String get MemberAlreadyExists => "This member already exists";
  String get MemberDeleteDialogDescription => "Are you sure that you want to delete this member?";
  String get MemberDeleteDialogErrorDescription => "Could not delete member";
  String get MemberDeleteDialogTitle => "Delete Member";
  String get MemberDetailsLoadDevicesError => "Could not load devices";
  String get MemberDetailsLoadPictureError => "Could not load profile picture";
  String get MemberDetailsNoDevices => "This member has no devices yet";
  String get MemberDetailsNoDevicesAddDevice => "Add a device";
  String get MemberDetailsTitle => "Details";
  String get MemberListAddMemberInstruction => "Add members by using the menu above";
  String get MemberListLoadingFailed => "Could not load members";
  String get MemberListNoItems => "There are no members to display";
  String get MemberListTitle => "Members";
  String get MemberPickImageError => "Could not load image";
  String get MondayPrefix => "Mon";
  String get PersonFirstNameLabel => "First Name";
  String get PersonLastNameLabel => "Last Name";
  String get PersonTelephoneLabel => "Telephone";
  String get PhoneIllegalCharacters => "A phone number can only contain digits";
  String get RideAttendeeAssignmentAlreadyScanning => "The previous scan wasn't finished";
  String get RideAttendeeAssignmentError => "Something went wrong";
  String get RideAttendeeAssignmentLoadingDevices => "Loading all known devices";
  String get RideAttendeeAssignmentLoadingMembers => "Loading members for assignment";
  String get RideAttendeeAssignmentProcessingScanResult => "Processing Scan Results";
  String get RideAttendeeAssignmentReturnToList => "Return to the list";
  String get RideAttendeeAssignmentScanningFailed => "The scan failed";
  String get RideAttendeeAssignmentScanningTitle => "Scanning for attendees";
  String get RideAttendeeAssignmentStopScan => "Stop Scan";
  String get RideAttendeeAssignmentSubmitError => "Could not save attendees";
  String get RideAttendeeAssignmentSubmitting => "Saving Attendees";
  String get RideDeleteDialogDescription => "Are you sure that you want to delete this ride?";
  String get RideDeleteDialogErrorDescription => "Could not delete ride";
  String get RideDeleteDialogTitle => "Delete Ride";
  String get RideDestination => "Destination";
  String get RideDetailsLoadAttendeesError => "Could not load attendees";
  String get RideDetailsNoAttendees => "This ride has no attendees";
  String get RideListAddRideInstruction => "Add rides by using the menu above";
  String get RideListLoadingRidesError => "Could not load rides";
  String get RideListNoRides => "There are no rides";
  String get RideListRidesHeader => "Rides";
  String get RideStart => "Start";
  String get SaturdayPrefix => "Sat";
  String get SundayPrefix => "Sun";
  String get ThursdayPrefix => "Thu";
  String get TuesdayPrefix => "Tue";
  String get UnknownDate => "Unknown Date";
  String get WednesdayPrefix => "Wed";
  String DeviceNameMaxLength(String maxLength) => "Device name is max. $maxLength characters";
  String EditRideAddressMaxLength(String maxLength) => "An address can't be longer than $maxLength characters";
  String EditRideDistanceMaximum(String maxDistance) => "A ride cannot have a distance that exceeds $maxDistance Km";
  String EditRideTitleMaxLength(String maxLength) => "A title can't be longer than $maxLength characters";
  String FirstNameMaxLength(String maxLength) => "First Name can't be longer than $maxLength characters";
  String LastNameMaxLength(String maxLength) => "Last Name can't be longer than $maxLength characters";
  String PhoneMaxLength(String maxLength) => "A phone number is maximum $maxLength digits long";
  String PhoneMinLength(String minLength) => "A phone number is minimum $minLength digits long";
  String RideAttendeeAssignmentTitle(String date) => "Attendees $date";
  String ValueIsRequired(String value) => "$value is required";
}

class $en extends S {
  const $en();
}

class $nl extends S {
  const $nl();

  @override
  TextDirection get textDirection => TextDirection.ltr;

  @override
  String get DeviceOverviewNoDevices => "Er zijn geen toestellen";
  @override
  String get EditRidePageTitle => "Rit Bewerken";
  @override
  String get EditRideTitleLabel => "Titel";
  @override
  String get DeviceWatch => "Horloge";
  @override
  String get RideAttendeeAssignmentSubmitError => "Kon aanwezigen niet opslaan";
  @override
  String get DevicePhone => "Telefoon";
  @override
  String get DeviceNameLabel => "Naam Toestel";
  @override
  String get DeviceUnknown => "Onbekend";
  @override
  String get AddMemberError => "Kon lid niet toevoegen";
  @override
  String get MemberDetailsTitle => "Details";
  @override
  String get MemberDetailsLoadDevicesError => "Kon toestellen niet laden";
  @override
  String get UnknownDate => "Onbekende Datum";
  @override
  String get RideListNoRides => "Er zijn geen ritten";
  @override
  String get MondayPrefix => "Ma";
  @override
  String get AddRideColorLegendFutureRide => "Toekomstige Rit";
  @override
  String get EditMemberTitle => "Lid Bewerken";
  @override
  String get EditRideDistanceLabel => "Afstand";
  @override
  String get RideAttendeeAssignmentStopScan => "Stop Scan";
  @override
  String get SundayPrefix => "Zo";
  @override
  String get AddDeviceSubmit => "Toestel Toevoegen";
  @override
  String get RideDetailsNoAttendees => "Deze rit heeft geen aanwezigen";
  @override
  String get RideAttendeeAssignmentScanningFailed => "De scan is mislukt";
  @override
  String get PersonFirstNameLabel => "Voornaam";
  @override
  String get RideDeleteDialogErrorDescription => "Kon rit niet verwijderen";
  @override
  String get RideListAddRideInstruction => "Voeg ritten toe via het menu hierboven";
  @override
  String get AddRideSubmit => "Selectie Toevoegen";
  @override
  String get PersonLastNameLabel => "Familienaam";
  @override
  String get AddMemberSubmit => "Voeg nieuw lid toe";
  @override
  String get AddRideColorLegendCurrentSelection => "Huidige Selectie";
  @override
  String get FirstNameBlank => "Voornaam mag niet enkel witruimte zijn";
  @override
  String get MemberListAddMemberInstruction => "Voeg leden toe via het menu hierboven";
  @override
  String get AddRideTitle => "Nieuwe Rit";
  @override
  String get MemberDeleteDialogErrorDescription => "Kon lid niet verwijderen";
  @override
  String get RideAttendeeAssignmentReturnToList => "Terug naar de lijst";
  @override
  String get AddRideColorLegendPastDay => "Gepasseerde Dag Zonder Rit";
  @override
  String get MemberDetailsNoDevicesAddDevice => "Voeg een toestel toe";
  @override
  String get PersonTelephoneLabel => "Telefoon";
  @override
  String get RideAttendeeAssignmentLoadingDevices => "Bekende toestellen laden";
  @override
  String get TuesdayPrefix => "Di";
  @override
  String get EditRideAddressWhitespace => "Een adres mag niet enkel witruimte zijn";
  @override
  String get DeviceTablet => "Tablet";
  @override
  String get AddRideEmptySelection => "Gelieve minimum één datum te kiezen";
  @override
  String get RideDestination => "Bestemming";
  @override
  String get EditRideDepartureLabel => "Vertrek";
  @override
  String get DevicesHeader => "Toestellen";
  @override
  String get DeviceAlreadyExists => "Dit toestel bestaat al";
  @override
  String get LastNameIllegalCharacters => "Familienaam mag enkel letters,spaties of ' - bevatten";
  @override
  String get RideAttendeeAssignmentScanningTitle => "Scannen naar aanwezigen";
  @override
  String get EditRideSubmitError => "Kon de wijzigingen niet opslaan";
  @override
  String get DeviceHeadset => "Koptelefoon";
  @override
  String get HomePageMembersTab => "Leden";
  @override
  String get EditMemberError => "Kon de wijzigingen niet opslaan";
  @override
  String get RideStart => "Vertrek";
  @override
  String get EditMemberSubmit => "Wijzigingen Opslaan";
  @override
  String get EditRideTitleWhitespace => "Een titel mag niet enkel witruimte zijn";
  @override
  String get EditRideDistanceInvalid => "Gelieve een geldige afstand in te geven";
  @override
  String get DistanceKm => "Km";
  @override
  String get MemberDetailsLoadPictureError => "Kon profielfoto niet laden";
  @override
  String get DialogDelete => "Verwijderen";
  @override
  String get RideListRidesHeader => "Ritten";
  @override
  String get AddDeviceGenericError => "Er liep iets fout";
  @override
  String get DialogOk => "Ok";
  @override
  String get HomePageRidesTab => "Ritten";
  @override
  String get FridayPrefix => "Vr";
  @override
  String get MemberDeleteDialogDescription => "Bent u zeker dat u dit lid wil verwijderen?";
  @override
  String get RideAttendeeAssignmentSubmitting => "Aanwezigheden Opslaan";
  @override
  String get AddRideColorLegendPastRide => "Gepasseerde Dag Met Rit";
  @override
  String get DeviceOverviewTitle => "Toestellen Beheren";
  @override
  String get RideAttendeeAssignmentAlreadyScanning => "Er is nog een scan bezig";
  @override
  String get EditRideDistancePositive => "Een afstand moet groter zijn dan nul";
  @override
  String get DeviceGPS => "GPS";
  @override
  String get RideListLoadingRidesError => "Kon ritten niet laden";
  @override
  String get PhoneIllegalCharacters => "Een telefoonnummer bestaat enkel uit cijfers";
  @override
  String get MemberAlreadyExists => "Dit lid bestaat al";
  @override
  String get AddMemberTitle => "Nieuw lid";
  @override
  String get EditRideAddressInvalid => "Een adres mag enkel letters, nummers, spaties of # , ; : ' & / ° . ( ) - bevatten";
  @override
  String get MemberListNoItems => "Er zijn geen leden om te tonen";
  @override
  String get DeviceTypeLabel => "Type Toestel";
  @override
  String get RideDeleteDialogDescription => "Bent u zeker dat u deze rit wil verwijderen?";
  @override
  String get AddRideLoadingFailed => "Kon de kalender niet laden";
  @override
  String get MemberDetailsNoDevices => "Dit lid heeft nog geen toestellen";
  @override
  String get WednesdayPrefix => "Wo";
  @override
  String get MemberPickImageError => "Kon afbeelding niet laden";
  @override
  String get RideAttendeeAssignmentLoadingMembers => "Leden ophalen voor aanwezigheidslijst";
  @override
  String get AppName => "WeForza";
  @override
  String get RideDetailsLoadAttendeesError => "Kon de aanwezigen niet laden";
  @override
  String get DialogCancel => "Annuleren";
  @override
  String get SaturdayPrefix => "Za";
  @override
  String get MemberListTitle => "Leden";
  @override
  String get RideAttendeeAssignmentError => "Er liep iets fout";
  @override
  String get AddRideError => "Kon ritten niet toevoegen";
  @override
  String get RideAttendeeAssignmentProcessingScanResult => "Scanresultaten verwerken";
  @override
  String get EditRideDestinationLabel => "Bestemming";
  @override
  String get LastNameBlank => "Familienaam mag niet enkel witruimte zijn";
  @override
  String get RideDeleteDialogTitle => "Verwijder Rit";
  @override
  String get EditRideSubmit => "Wijzigingen Opslaan";
  @override
  String get DevicePulseMonitor => "Hartslagmeter";
  @override
  String get ThursdayPrefix => "Do";
  @override
  String get FirstNameIllegalCharacters => "Voornaam mag enkel letters, spaties of ' - bevatten";
  @override
  String get AddDeviceError => "Kon toestel niet toevoegen";
  @override
  String get MemberListLoadingFailed => "Kon leden niet laden";
  @override
  String get MemberDeleteDialogTitle => "Verwijder Lid";
  @override
  String PhoneMinLength(String minLength) => "Een telefoonnummer is minimum $minLength cijfers lang";
  @override
  String FirstNameMaxLength(String maxLength) => "Voornaam kan niet langer zijn dan $maxLength letters";
  @override
  String RideAttendeeAssignmentTitle(String date) => "Aanwezigen $date";
  @override
  String EditRideAddressMaxLength(String maxLength) => "Een adres mag niet langer zijn dan $maxLength karakters";
  @override
  String EditRideDistanceMaximum(String maxDistance) => "De afstand van een rit mag niet groter zijn dan $maxDistance Km";
  @override
  String DeviceNameMaxLength(String maxLength) => "Naam Toestel is max. $maxLength tekens";
  @override
  String ValueIsRequired(String value) => "$value is verplicht";
  @override
  String LastNameMaxLength(String maxLength) => "Familienaam kan niet langer zijn dan $maxLength letters";
  @override
  String PhoneMaxLength(String maxLength) => "Een telefoonnummer is maximum $maxLength cijfers lang";
  @override
  String EditRideTitleMaxLength(String maxLength) => "Een titel mag niet langer zijn dan $maxLength karakters";
}

class GeneratedLocalizationsDelegate extends LocalizationsDelegate<S> {
  const GeneratedLocalizationsDelegate();

  List<Locale> get supportedLocales {
    return const <Locale>[
      Locale("en", ""),
      Locale("nl", ""),
    ];
  }

  LocaleListResolutionCallback listResolution({Locale fallback, bool withCountry = true}) {
    return (List<Locale> locales, Iterable<Locale> supported) {
      if (locales == null || locales.isEmpty) {
        return fallback ?? supported.first;
      } else {
        return _resolve(locales.first, fallback, supported, withCountry);
      }
    };
  }

  LocaleResolutionCallback resolution({Locale fallback, bool withCountry = true}) {
    return (Locale locale, Iterable<Locale> supported) {
      return _resolve(locale, fallback, supported, withCountry);
    };
  }

  @override
  Future<S> load(Locale locale) {
    final String lang = getLang(locale);
    if (lang != null) {
      switch (lang) {
        case "en":
          S.current = const $en();
          return SynchronousFuture<S>(S.current);
        case "nl":
          S.current = const $nl();
          return SynchronousFuture<S>(S.current);
        default:
          // NO-OP.
      }
    }
    S.current = const S();
    return SynchronousFuture<S>(S.current);
  }

  @override
  bool isSupported(Locale locale) => _isSupported(locale, true);

  @override
  bool shouldReload(GeneratedLocalizationsDelegate old) => false;

  ///
  /// Internal method to resolve a locale from a list of locales.
  ///
  Locale _resolve(Locale locale, Locale fallback, Iterable<Locale> supported, bool withCountry) {
    if (locale == null || !_isSupported(locale, withCountry)) {
      return fallback ?? supported.first;
    }

    final Locale languageLocale = Locale(locale.languageCode, "");
    if (supported.contains(locale)) {
      return locale;
    } else if (supported.contains(languageLocale)) {
      return languageLocale;
    } else {
      final Locale fallbackLocale = fallback ?? supported.first;
      return fallbackLocale;
    }
  }

  ///
  /// Returns true if the specified locale is supported, false otherwise.
  ///
  bool _isSupported(Locale locale, bool withCountry) {
    if (locale != null) {
      for (Locale supportedLocale in supportedLocales) {
        // Language must always match both locales.
        if (supportedLocale.languageCode != locale.languageCode) {
          continue;
        }

        // If country code matches, return this locale.
        if (supportedLocale.countryCode == locale.countryCode) {
          return true;
        }

        // If no country requirement is requested, check if this locale has no country.
        if (true != withCountry && (supportedLocale.countryCode == null || supportedLocale.countryCode.isEmpty)) {
          return true;
        }
      }
    }
    return false;
  }
}

String getLang(Locale l) => l == null
  ? null
  : l.countryCode != null && l.countryCode.isEmpty
    ? l.languageCode
    : l.toString();
