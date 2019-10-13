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
  String get HomePageMembersTab => "Members";
  String get HomePageRidesTab => "Rides";
  String get LastNameIllegalCharacters => "Last Name can only contain letters, spaces or ' -";
  String get MemberDetailsTitle => "Details";
  String get MemberListAddMemberInstruction => "Add members by using the menu above.";
  String get MemberListLoadingFailed => "Could not fetch members.";
  String get MemberListLoadingInProgress => "Loading members...";
  String get MemberListNoItems => "There are no members to display.";
  String get MemberListTitle => "Members";
  String get PersonFirstNameLabel => "First Name";
  String get PersonLastNameLabel => "Last Name";
  String get PersonTelephoneLabel => "Telephone";
  String get PhoneIllegalCharacters => "A phone number can only contain digits";
  String get RideListTitle => "Rides";
  String FirstNameMaxLength(String maxLength) => "First Name can't be longer than $maxLength characters";
  String LastNameMaxLength(String maxLength) => "Last Name can't be longer than $maxLength characters";
  String MemberPhoneFormat(String phone) => "Tel: $phone";
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
  String get RideListTitle => "Ritten";
  @override
  String get PhoneIllegalCharacters => "Een telefoonnummer bestaat enkel uit cijfers";
  @override
  String get PersonFirstNameLabel => "Voornaam";
  @override
  String get AppName => "WeForza";
  @override
  String get LastNameIllegalCharacters => "Familienaam mag enkel letters,spaties of ' - bevatten";
  @override
  String get HomePageRidesTab => "Ritten";
  @override
  String get MemberListLoadingInProgress => "Leden aan het ophalen...";
  @override
  String get AddMemberTitle => "Nieuw lid";
  @override
  String get MemberDetailsTitle => "Details";
  @override
  String get PersonLastNameLabel => "Familienaam";
  @override
  String get MemberListTitle => "Leden";
  @override
  String get AddMemberSubmit => "Voeg nieuw lid toe";
  @override
  String get PersonTelephoneLabel => "Telefoon";
  @override
  String get FirstNameIllegalCharacters => "Voornaam mag enkel letters, spaties of ' - bevatten";
  @override
  String get HomePageMembersTab => "Leden";
  @override
  String get MemberListLoadingFailed => "Kon geen leden ophalen.";
  @override
  String get MemberListAddMemberInstruction => "Voeg leden toe via het menu hierboven.";
  @override
  String get MemberListNoItems => "Er zijn geen leden om te tonen.";
  @override
  String PhoneMaxLength(String maxLength) => "Een telefoonnummer is maximum $maxLength cijfers lang";
  @override
  String PhoneMinLength(String minLength) => "Een telefoonnummer is minimum $minLength cijfers lang";
  @override
  String MemberPhoneFormat(String phone) => "Tel: $phone";
  @override
  String ValueIsRequired(String value) => "$value is verplicht";
  @override
  String LastNameMaxLength(String maxLength) => "Familienaam kan niet langer zijn dan $maxLength letters";
  @override
  String FirstNameMaxLength(String maxLength) => "Voornaam kan niet langer zijn dan $maxLength letters";
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
