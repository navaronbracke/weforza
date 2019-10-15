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

  String get AddMemberSubmit => "Create New Member";
  String get AddMemberTitle => "New Member";
  String get AppName => "WeForza";
  String get FirstNameIllegalCharacters => "First Name can only contain letters, spaces or ' -";
  String get FridayPrefix => "Fri";
  String get HomePageMembersTab => "Members";
  String get HomePageRidesTab => "Rides";
  String get LastNameIllegalCharacters => "Last Name can only contain letters, spaces or ' -";
  String get MemberDeleteDialogCancel => "Cancel";
  String get MemberDeleteDialogConfirm => "Delete Member";
  String get MemberDeleteDialogDescription => "Are you sure that you want to delete this member? The member will be permanently deleted.";
  String get MemberDeleteDialogTitle => "Delete Member";
  String get MemberDetailsAddDevicesInstruction => "Add devices by editing this member.";
  String get MemberDetailsNoDevices => "This member has no devices yet.";
  String get MemberDetailsTitle => "Details";
  String get MemberListAddMemberInstruction => "Add members by using the menu above";
  String get MemberListLoadingFailed => "Could not fetch members";
  String get MemberListLoadingInProgress => "Loading members...";
  String get MemberListNoItems => "There are no members to display";
  String get MemberListTitle => "Members";
  String get MondayPrefix => "Mon";
  String get PersonDevicesLabel => "Devices";
  String get PersonFirstNameLabel => "First Name";
  String get PersonLastNameLabel => "Last Name";
  String get PersonTelephoneLabel => "Telephone";
  String get PhoneIllegalCharacters => "A phone number can only contain digits";
  String get RideListAddMemberInstruction => "Add members in the members menu";
  String get RideListAddRideInstruction => "Add a ride with the + icon";
  String get RideListAttendeesHeader => "Attendees";
  String get RideListFilterShowAttendingOnly => "Only attending people";
  String get RideListLoadingMembersFailed => "Could not load the members";
  String get RideListLoadingRidesFailed => "Could not load the rides";
  String get RideListNoMembers => "There are no members";
  String get RideListNoRides => "There are no rides";
  String get RideListRidesHeader => "Rides";
  String get SaturdayPrefix => "Sat";
  String get SundayPrefix => "Sun";
  String get ThursdayPrefix => "Thu";
  String get TuesdayPrefix => "Tue";
  String get UnknownDate => "Unknown Date";
  String get WednesdayPrefix => "Wed";
  String FirstNameMaxLength(String maxLength) => "First Name can't be longer than $maxLength characters";
  String LastNameMaxLength(String maxLength) => "Last Name can't be longer than $maxLength characters";
  String MemberDetailsPhoneFormat(String phone) => "Telephone $phone";
  String MemberDetailsWasPresentCountLabel(String count) => "Number of times present during rides   $count";
  String PhoneMaxLength(String maxLength) => "A phone number is maximum $maxLength digits long";
  String PhoneMinLength(String minLength) => "A phone number is minimum $minLength digits long";
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
  String get RideListAddMemberInstruction => "Voeg leden toe in het leden menu";
  @override
  String get RideListLoadingRidesFailed => "Kon de ritten niet ophalen";
  @override
  String get MemberDetailsNoDevices => "Dit lid heeft nog geen toestellen.";
  @override
  String get RideListRidesHeader => "Ritten";
  @override
  String get WednesdayPrefix => "Wo";
  @override
  String get AppName => "WeForza";
  @override
  String get HomePageRidesTab => "Ritten";
  @override
  String get MemberListLoadingInProgress => "Leden aan het ophalen...";
  @override
  String get FridayPrefix => "Vr";
  @override
  String get MemberDetailsTitle => "Details";
  @override
  String get SaturdayPrefix => "Za";
  @override
  String get UnknownDate => "Onbekende Datum";
  @override
  String get RideListAttendeesHeader => "Aanwezigen";
  @override
  String get MemberListTitle => "Leden";
  @override
  String get PersonTelephoneLabel => "Telefoon";
  @override
  String get RideListNoRides => "Er zijn geen ritten";
  @override
  String get MemberDeleteDialogDescription => "Bent u zeker dat u dit lid wil verwijderen? Het lid wordt permanent verwijderd.";
  @override
  String get MondayPrefix => "Ma";
  @override
  String get MemberDeleteDialogConfirm => "Verwijder Lid";
  @override
  String get PersonDevicesLabel => "Toestellen";
  @override
  String get MemberDetailsAddDevicesInstruction => "Voeg toestellen toe door dit lid te bewerken.";
  @override
  String get TuesdayPrefix => "Di";
  @override
  String get RideListNoMembers => "Er zijn geen leden";
  @override
  String get MemberDeleteDialogCancel => "Annuleren";
  @override
  String get SundayPrefix => "Zo";
  @override
  String get RideListFilterShowAttendingOnly => "Enkel aanwezigen";
  @override
  String get PhoneIllegalCharacters => "Een telefoonnummer bestaat enkel uit cijfers";
  @override
  String get PersonFirstNameLabel => "Voornaam";
  @override
  String get LastNameIllegalCharacters => "Familienaam mag enkel letters,spaties of ' - bevatten";
  @override
  String get AddMemberTitle => "Nieuw lid";
  @override
  String get ThursdayPrefix => "Do";
  @override
  String get RideListAddRideInstruction => "Voeg een rit toe met de +";
  @override
  String get PersonLastNameLabel => "Familienaam";
  @override
  String get AddMemberSubmit => "Voeg nieuw lid toe";
  @override
  String get FirstNameIllegalCharacters => "Voornaam mag enkel letters, spaties of ' - bevatten";
  @override
  String get RideListLoadingMembersFailed => "Kon de leden niet ophalen";
  @override
  String get HomePageMembersTab => "Leden";
  @override
  String get MemberListLoadingFailed => "Kon geen leden ophalen";
  @override
  String get MemberListAddMemberInstruction => "Voeg leden toe via het menu hierboven";
  @override
  String get MemberDeleteDialogTitle => "Verwijder Lid";
  @override
  String get MemberListNoItems => "Er zijn geen leden om te tonen";
  @override
  String PhoneMinLength(String minLength) => "Een telefoonnummer is minimum $minLength cijfers lang";
  @override
  String ValueIsRequired(String value) => "$value is verplicht";
  @override
  String LastNameMaxLength(String maxLength) => "Familienaam kan niet langer zijn dan $maxLength letters";
  @override
  String MemberDetailsPhoneFormat(String phone) => "Telefoon $phone";
  @override
  String FirstNameMaxLength(String maxLength) => "Voornaam kan niet langer zijn dan $maxLength letters";
  @override
  String MemberDetailsWasPresentCountLabel(String count) => "Aantal keren aanwezig tijdens ritten   $count";
  @override
  String PhoneMaxLength(String maxLength) => "Een telefoonnummer is maximum $maxLength cijfers lang";
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
