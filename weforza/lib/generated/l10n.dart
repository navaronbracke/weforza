// GENERATED CODE - DO NOT MODIFY BY HAND
import 'package:flutter/material.dart';
import 'package:intl/intl.dart';
import 'intl/messages_all.dart';

// **************************************************************************
// Generator: Flutter Intl IDE plugin
// Made by Localizely
// **************************************************************************

// ignore_for_file: non_constant_identifier_names, lines_longer_than_80_chars

class S {
  S();
  
  static S current;
  
  static const AppLocalizationDelegate delegate =
    AppLocalizationDelegate();

  static Future<S> load(Locale locale) {
    final name = (locale.countryCode?.isEmpty ?? false) ? locale.languageCode : locale.toString();
    final localeName = Intl.canonicalizedLocale(name); 
    return initializeMessages(localeName).then((_) {
      Intl.defaultLocale = localeName;
      S.current = S();
      
      return S.current;
    });
  } 

  static S of(BuildContext context) {
    return Localizations.of<S>(context, S);
  }

  /// `WeForza`
  String get AppName {
    return Intl.message(
      'WeForza',
      name: 'AppName',
      desc: '',
      args: [],
    );
  }

  /// `Version: {version}`
  String AppVersionNumber(Object version) {
    return Intl.message(
      'Version: $version',
      name: 'AppVersionNumber',
      desc: '',
      args: [version],
    );
  }

  /// `Build Number: {buildNumber}`
  String AppVersionBuildNumber(Object buildNumber) {
    return Intl.message(
      'Build Number: $buildNumber',
      name: 'AppVersionBuildNumber',
      desc: '',
      args: [buildNumber],
    );
  }

  /// `Mon`
  String get MondayPrefix {
    return Intl.message(
      'Mon',
      name: 'MondayPrefix',
      desc: '',
      args: [],
    );
  }

  /// `Tue`
  String get TuesdayPrefix {
    return Intl.message(
      'Tue',
      name: 'TuesdayPrefix',
      desc: '',
      args: [],
    );
  }

  /// `Wed`
  String get WednesdayPrefix {
    return Intl.message(
      'Wed',
      name: 'WednesdayPrefix',
      desc: '',
      args: [],
    );
  }

  /// `Thu`
  String get ThursdayPrefix {
    return Intl.message(
      'Thu',
      name: 'ThursdayPrefix',
      desc: '',
      args: [],
    );
  }

  /// `Fri`
  String get FridayPrefix {
    return Intl.message(
      'Fri',
      name: 'FridayPrefix',
      desc: '',
      args: [],
    );
  }

  /// `Sat`
  String get SaturdayPrefix {
    return Intl.message(
      'Sat',
      name: 'SaturdayPrefix',
      desc: '',
      args: [],
    );
  }

  /// `Sun`
  String get SundayPrefix {
    return Intl.message(
      'Sun',
      name: 'SundayPrefix',
      desc: '',
      args: [],
    );
  }

  /// `Unknown Date`
  String get UnknownDate {
    return Intl.message(
      'Unknown Date',
      name: 'UnknownDate',
      desc: '',
      args: [],
    );
  }

  /// `Rides`
  String get HomePageRidesTab {
    return Intl.message(
      'Rides',
      name: 'HomePageRidesTab',
      desc: '',
      args: [],
    );
  }

  /// `Members`
  String get HomePageMembersTab {
    return Intl.message(
      'Members',
      name: 'HomePageMembersTab',
      desc: '',
      args: [],
    );
  }

  /// `Settings`
  String get HomePageSettingsTab {
    return Intl.message(
      'Settings',
      name: 'HomePageSettingsTab',
      desc: '',
      args: [],
    );
  }

  /// `Members`
  String get MemberListTitle {
    return Intl.message(
      'Members',
      name: 'MemberListTitle',
      desc: '',
      args: [],
    );
  }

  /// `Could not load members`
  String get MemberListLoadingFailed {
    return Intl.message(
      'Could not load members',
      name: 'MemberListLoadingFailed',
      desc: '',
      args: [],
    );
  }

  /// `There are no members to display`
  String get MemberListNoItems {
    return Intl.message(
      'There are no members to display',
      name: 'MemberListNoItems',
      desc: '',
      args: [],
    );
  }

  /// `Add members by using the menu above`
  String get MemberListAddMemberInstruction {
    return Intl.message(
      'Add members by using the menu above',
      name: 'MemberListAddMemberInstruction',
      desc: '',
      args: [],
    );
  }

  /// `Rides`
  String get RideListRidesHeader {
    return Intl.message(
      'Rides',
      name: 'RideListRidesHeader',
      desc: '',
      args: [],
    );
  }

  /// `There are no rides`
  String get RideListNoRides {
    return Intl.message(
      'There are no rides',
      name: 'RideListNoRides',
      desc: '',
      args: [],
    );
  }

  /// `Add rides by using the menu above`
  String get RideListAddRideInstruction {
    return Intl.message(
      'Add rides by using the menu above',
      name: 'RideListAddRideInstruction',
      desc: '',
      args: [],
    );
  }

  /// `Could not load rides`
  String get RideListLoadingRidesError {
    return Intl.message(
      'Could not load rides',
      name: 'RideListLoadingRidesError',
      desc: '',
      args: [],
    );
  }

  /// `Could not load attendees`
  String get RideDetailsLoadAttendeesError {
    return Intl.message(
      'Could not load attendees',
      name: 'RideDetailsLoadAttendeesError',
      desc: '',
      args: [],
    );
  }

  /// `This ride has no attendees`
  String get RideDetailsNoAttendees {
    return Intl.message(
      'This ride has no attendees',
      name: 'RideDetailsNoAttendees',
      desc: '',
      args: [],
    );
  }

  /// `Edit`
  String get RideDetailsEditOption {
    return Intl.message(
      'Edit',
      name: 'RideDetailsEditOption',
      desc: '',
      args: [],
    );
  }

  /// `Export`
  String get RideDetailsExportOption {
    return Intl.message(
      'Export',
      name: 'RideDetailsExportOption',
      desc: '',
      args: [],
    );
  }

  /// `Delete`
  String get RideDetailsDeleteOption {
    return Intl.message(
      'Delete',
      name: 'RideDetailsDeleteOption',
      desc: '',
      args: [],
    );
  }

  /// `Delete Ride`
  String get RideDeleteDialogTitle {
    return Intl.message(
      'Delete Ride',
      name: 'RideDeleteDialogTitle',
      desc: '',
      args: [],
    );
  }

  /// `Are you sure that you want to delete this ride?`
  String get RideDeleteDialogDescription {
    return Intl.message(
      'Are you sure that you want to delete this ride?',
      name: 'RideDeleteDialogDescription',
      desc: '',
      args: [],
    );
  }

  /// `Could not delete ride`
  String get RideDeleteDialogErrorDescription {
    return Intl.message(
      'Could not delete ride',
      name: 'RideDeleteDialogErrorDescription',
      desc: '',
      args: [],
    );
  }

  /// `Details`
  String get MemberDetailsTitle {
    return Intl.message(
      'Details',
      name: 'MemberDetailsTitle',
      desc: '',
      args: [],
    );
  }

  /// `This member has no devices yet`
  String get MemberDetailsNoDevices {
    return Intl.message(
      'This member has no devices yet',
      name: 'MemberDetailsNoDevices',
      desc: '',
      args: [],
    );
  }

  /// `Add a device`
  String get MemberDetailsNoDevicesAddDevice {
    return Intl.message(
      'Add a device',
      name: 'MemberDetailsNoDevicesAddDevice',
      desc: '',
      args: [],
    );
  }

  /// `Could not load devices`
  String get MemberDetailsLoadDevicesError {
    return Intl.message(
      'Could not load devices',
      name: 'MemberDetailsLoadDevicesError',
      desc: '',
      args: [],
    );
  }

  /// `Could not load profile picture`
  String get MemberDetailsLoadPictureError {
    return Intl.message(
      'Could not load profile picture',
      name: 'MemberDetailsLoadPictureError',
      desc: '',
      args: [],
    );
  }

  /// `Devices`
  String get DevicesListHeader {
    return Intl.message(
      'Devices',
      name: 'DevicesListHeader',
      desc: '',
      args: [],
    );
  }

  /// `No devices to show`
  String get DevicesListNoDevices {
    return Intl.message(
      'No devices to show',
      name: 'DevicesListNoDevices',
      desc: '',
      args: [],
    );
  }

  /// `Device Name`
  String get DeviceNameLabel {
    return Intl.message(
      'Device Name',
      name: 'DeviceNameLabel',
      desc: '',
      args: [],
    );
  }

  /// `Add Device`
  String get AddDeviceTitle {
    return Intl.message(
      'Add Device',
      name: 'AddDeviceTitle',
      desc: '',
      args: [],
    );
  }

  /// `Could not add device`
  String get AddDeviceError {
    return Intl.message(
      'Could not add device',
      name: 'AddDeviceError',
      desc: '',
      args: [],
    );
  }

  /// `Create Device`
  String get AddDeviceSubmit {
    return Intl.message(
      'Create Device',
      name: 'AddDeviceSubmit',
      desc: '',
      args: [],
    );
  }

  /// `Edit Device`
  String get EditDeviceTitle {
    return Intl.message(
      'Edit Device',
      name: 'EditDeviceTitle',
      desc: '',
      args: [],
    );
  }

  /// `Could not edit device`
  String get EditDeviceError {
    return Intl.message(
      'Could not edit device',
      name: 'EditDeviceError',
      desc: '',
      args: [],
    );
  }

  /// `Save Changes`
  String get EditDeviceSubmit {
    return Intl.message(
      'Save Changes',
      name: 'EditDeviceSubmit',
      desc: '',
      args: [],
    );
  }

  /// `Edit Member`
  String get EditMemberTitle {
    return Intl.message(
      'Edit Member',
      name: 'EditMemberTitle',
      desc: '',
      args: [],
    );
  }

  /// `Failed to save the changes`
  String get EditMemberError {
    return Intl.message(
      'Failed to save the changes',
      name: 'EditMemberError',
      desc: '',
      args: [],
    );
  }

  /// `Save Changes`
  String get EditMemberSubmit {
    return Intl.message(
      'Save Changes',
      name: 'EditMemberSubmit',
      desc: '',
      args: [],
    );
  }

  /// `Delete Member`
  String get MemberDeleteDialogTitle {
    return Intl.message(
      'Delete Member',
      name: 'MemberDeleteDialogTitle',
      desc: '',
      args: [],
    );
  }

  /// `Are you sure that you want to delete this member?`
  String get MemberDeleteDialogDescription {
    return Intl.message(
      'Are you sure that you want to delete this member?',
      name: 'MemberDeleteDialogDescription',
      desc: '',
      args: [],
    );
  }

  /// `Could not delete member`
  String get MemberDeleteDialogErrorDescription {
    return Intl.message(
      'Could not delete member',
      name: 'MemberDeleteDialogErrorDescription',
      desc: '',
      args: [],
    );
  }

  /// `New Member`
  String get AddMemberTitle {
    return Intl.message(
      'New Member',
      name: 'AddMemberTitle',
      desc: '',
      args: [],
    );
  }

  /// `Create New Member`
  String get AddMemberSubmit {
    return Intl.message(
      'Create New Member',
      name: 'AddMemberSubmit',
      desc: '',
      args: [],
    );
  }

  /// `This member already exists`
  String get MemberAlreadyExists {
    return Intl.message(
      'This member already exists',
      name: 'MemberAlreadyExists',
      desc: '',
      args: [],
    );
  }

  /// `Could not add member`
  String get AddMemberError {
    return Intl.message(
      'Could not add member',
      name: 'AddMemberError',
      desc: '',
      args: [],
    );
  }

  /// `Could not load image`
  String get MemberPickImageError {
    return Intl.message(
      'Could not load image',
      name: 'MemberPickImageError',
      desc: '',
      args: [],
    );
  }

  /// `New Ride`
  String get AddRideTitle {
    return Intl.message(
      'New Ride',
      name: 'AddRideTitle',
      desc: '',
      args: [],
    );
  }

  /// `Add Selection`
  String get AddRideSubmit {
    return Intl.message(
      'Add Selection',
      name: 'AddRideSubmit',
      desc: '',
      args: [],
    );
  }

  /// `Could not load Calendar`
  String get AddRideLoadingFailed {
    return Intl.message(
      'Could not load Calendar',
      name: 'AddRideLoadingFailed',
      desc: '',
      args: [],
    );
  }

  /// `Please select at least one date`
  String get AddRideEmptySelection {
    return Intl.message(
      'Please select at least one date',
      name: 'AddRideEmptySelection',
      desc: '',
      args: [],
    );
  }

  /// `Could not add rides`
  String get AddRideError {
    return Intl.message(
      'Could not add rides',
      name: 'AddRideError',
      desc: '',
      args: [],
    );
  }

  /// `Past Day Without Ride`
  String get AddRideColorLegendPastDay {
    return Intl.message(
      'Past Day Without Ride',
      name: 'AddRideColorLegendPastDay',
      desc: '',
      args: [],
    );
  }

  /// `Past Day With Ride`
  String get AddRideColorLegendPastRide {
    return Intl.message(
      'Past Day With Ride',
      name: 'AddRideColorLegendPastRide',
      desc: '',
      args: [],
    );
  }

  /// `Current Selection`
  String get AddRideColorLegendCurrentSelection {
    return Intl.message(
      'Current Selection',
      name: 'AddRideColorLegendCurrentSelection',
      desc: '',
      args: [],
    );
  }

  /// `Future Ride`
  String get AddRideColorLegendFutureRide {
    return Intl.message(
      'Future Ride',
      name: 'AddRideColorLegendFutureRide',
      desc: '',
      args: [],
    );
  }

  /// `Scan`
  String get RideAttendeeScanningProcessScanLabel {
    return Intl.message(
      'Scan',
      name: 'RideAttendeeScanningProcessScanLabel',
      desc: '',
      args: [],
    );
  }

  /// `By Hand`
  String get RideAttendeeScanningProcessAddMembersLabel {
    return Intl.message(
      'By Hand',
      name: 'RideAttendeeScanningProcessAddMembersLabel',
      desc: '',
      args: [],
    );
  }

  /// `Preparing Scan`
  String get RideAttendeeScanningPreparingScan {
    return Intl.message(
      'Preparing Scan',
      name: 'RideAttendeeScanningPreparingScan',
      desc: '',
      args: [],
    );
  }

  /// `Cannot start a scan, there are no members`
  String get RideAttendeeScanningNoMembers {
    return Intl.message(
      'Cannot start a scan, there are no members',
      name: 'RideAttendeeScanningNoMembers',
      desc: '',
      args: [],
    );
  }

  /// `Return to detail page`
  String get RideAttendeeScanningGoBackToDetailPage {
    return Intl.message(
      'Return to detail page',
      name: 'RideAttendeeScanningGoBackToDetailPage',
      desc: '',
      args: [],
    );
  }

  /// `Scan aborted, permission was denied`
  String get RideAttendeeScanningPermissionDenied {
    return Intl.message(
      'Scan aborted, permission was denied',
      name: 'RideAttendeeScanningPermissionDenied',
      desc: '',
      args: [],
    );
  }

  /// `Scanning requires permission to use your location`
  String get RideAttendeeScanningPermissionDescription {
    return Intl.message(
      'Scanning requires permission to use your location',
      name: 'RideAttendeeScanningPermissionDescription',
      desc: '',
      args: [],
    );
  }

  /// `Scan aborted, Bluetooth is disabled`
  String get RideAttendeeScanningBluetoothDisabled {
    return Intl.message(
      'Scan aborted, Bluetooth is disabled',
      name: 'RideAttendeeScanningBluetoothDisabled',
      desc: '',
      args: [],
    );
  }

  /// `Go to Settings`
  String get RideAttendeeScanningGoToSettings {
    return Intl.message(
      'Go to Settings',
      name: 'RideAttendeeScanningGoToSettings',
      desc: '',
      args: [],
    );
  }

  /// `Retry Scan`
  String get RideAttendeeScanningRetryScan {
    return Intl.message(
      'Retry Scan',
      name: 'RideAttendeeScanningRetryScan',
      desc: '',
      args: [],
    );
  }

  /// `Skip Scan`
  String get RideAttendeeScanningSkipScan {
    return Intl.message(
      'Skip Scan',
      name: 'RideAttendeeScanningSkipScan',
      desc: '',
      args: [],
    );
  }

  /// `Save Scan Results`
  String get RideAttendeeScanningSaveScanResults {
    return Intl.message(
      'Save Scan Results',
      name: 'RideAttendeeScanningSaveScanResults',
      desc: '',
      args: [],
    );
  }

  /// `Save Selection`
  String get RideAttendeeScanningSaveManualResults {
    return Intl.message(
      'Save Selection',
      name: 'RideAttendeeScanningSaveManualResults',
      desc: '',
      args: [],
    );
  }

  /// `There are no members to choose from`
  String get RideAttendeeScanningManualSelectionEmptyList {
    return Intl.message(
      'There are no members to choose from',
      name: 'RideAttendeeScanningManualSelectionEmptyList',
      desc: '',
      args: [],
    );
  }

  /// `Owned by: {firstName} '{alias}' {lastName}`
  String RideAttendeeScanningScanResultDeviceOwnedByLabel(Object firstName, Object alias, Object lastName) {
    return Intl.message(
      'Owned by: $firstName \'$alias\' $lastName',
      name: 'RideAttendeeScanningScanResultDeviceOwnedByLabel',
      desc: '',
      args: [firstName, alias, lastName],
    );
  }

  /// `Edit Ride`
  String get EditRidePageTitle {
    return Intl.message(
      'Edit Ride',
      name: 'EditRidePageTitle',
      desc: '',
      args: [],
    );
  }

  /// `Title`
  String get EditRideTitleLabel {
    return Intl.message(
      'Title',
      name: 'EditRideTitleLabel',
      desc: '',
      args: [],
    );
  }

  /// `Departure`
  String get EditRideDepartureLabel {
    return Intl.message(
      'Departure',
      name: 'EditRideDepartureLabel',
      desc: '',
      args: [],
    );
  }

  /// `Destination`
  String get EditRideDestinationLabel {
    return Intl.message(
      'Destination',
      name: 'EditRideDestinationLabel',
      desc: '',
      args: [],
    );
  }

  /// `Distance`
  String get EditRideDistanceLabel {
    return Intl.message(
      'Distance',
      name: 'EditRideDistanceLabel',
      desc: '',
      args: [],
    );
  }

  /// `A title can't be longer than {maxLength} characters`
  String EditRideTitleMaxLength(Object maxLength) {
    return Intl.message(
      'A title can\'t be longer than $maxLength characters',
      name: 'EditRideTitleMaxLength',
      desc: '',
      args: [maxLength],
    );
  }

  /// `A title can't be blank`
  String get EditRideTitleWhitespace {
    return Intl.message(
      'A title can\'t be blank',
      name: 'EditRideTitleWhitespace',
      desc: '',
      args: [],
    );
  }

  /// `Please enter a valid distance`
  String get EditRideDistanceInvalid {
    return Intl.message(
      'Please enter a valid distance',
      name: 'EditRideDistanceInvalid',
      desc: '',
      args: [],
    );
  }

  /// `Distance must be greater than zero`
  String get EditRideDistancePositive {
    return Intl.message(
      'Distance must be greater than zero',
      name: 'EditRideDistancePositive',
      desc: '',
      args: [],
    );
  }

  /// `A ride cannot have a distance that exceeds {maxDistance} Km`
  String EditRideDistanceMaximum(Object maxDistance) {
    return Intl.message(
      'A ride cannot have a distance that exceeds $maxDistance Km',
      name: 'EditRideDistanceMaximum',
      desc: '',
      args: [maxDistance],
    );
  }

  /// `An address can't be blank`
  String get EditRideAddressWhitespace {
    return Intl.message(
      'An address can\'t be blank',
      name: 'EditRideAddressWhitespace',
      desc: '',
      args: [],
    );
  }

  /// `An address can't be longer than {maxLength} characters`
  String EditRideAddressMaxLength(Object maxLength) {
    return Intl.message(
      'An address can\'t be longer than $maxLength characters',
      name: 'EditRideAddressMaxLength',
      desc: '',
      args: [maxLength],
    );
  }

  /// `An address can only contain letters, numbers, spaces and # , ; : ' & / ° . ( ) -`
  String get EditRideAddressInvalid {
    return Intl.message(
      'An address can only contain letters, numbers, spaces and # , ; : \' & / ° . ( ) -',
      name: 'EditRideAddressInvalid',
      desc: '',
      args: [],
    );
  }

  /// `Save Changes`
  String get EditRideSubmit {
    return Intl.message(
      'Save Changes',
      name: 'EditRideSubmit',
      desc: '',
      args: [],
    );
  }

  /// `Failed to save the changes`
  String get EditRideSubmitError {
    return Intl.message(
      'Failed to save the changes',
      name: 'EditRideSubmitError',
      desc: '',
      args: [],
    );
  }

  /// `Import Members`
  String get ImportMembersPageTitle {
    return Intl.message(
      'Import Members',
      name: 'ImportMembersPageTitle',
      desc: '',
      args: [],
    );
  }

  /// `Choose File`
  String get ImportMembersPickFile {
    return Intl.message(
      'Choose File',
      name: 'ImportMembersPickFile',
      desc: '',
      args: [],
    );
  }

  /// `Please choose a file to import members`
  String get ImportMembersPickFileWarning {
    return Intl.message(
      'Please choose a file to import members',
      name: 'ImportMembersPickFileWarning',
      desc: '',
      args: [],
    );
  }

  /// `Importing Members`
  String get ImportMembersImporting {
    return Intl.message(
      'Importing Members',
      name: 'ImportMembersImporting',
      desc: '',
      args: [],
    );
  }

  /// `(firstname)\,(surname|familyname|lastname),(alias|nickname)\,(devices)(.*)`
  String get ImportMembersCsvHeaderRegex {
    return Intl.message(
      '(firstname)\,(surname|familyname|lastname),(alias|nickname)\,(devices)(.*)',
      name: 'ImportMembersCsvHeaderRegex',
      desc: '',
      args: [],
    );
  }

  /// `A csv header might look like:`
  String get ImportMembersCsvHeaderExampleDescription {
    return Intl.message(
      'A csv header might look like:',
      name: 'ImportMembersCsvHeaderExampleDescription',
      desc: '',
      args: [],
    );
  }

  /// `firstname,surname,alias,devices`
  String get ImportMembersCsvHeaderExample {
    return Intl.message(
      'firstname,surname,alias,devices',
      name: 'ImportMembersCsvHeaderExample',
      desc: '',
      args: [],
    );
  }

  /// `Only CSV files are allowed`
  String get ImportMembersInvalidFileFormat {
    return Intl.message(
      'Only CSV files are allowed',
      name: 'ImportMembersInvalidFileFormat',
      desc: '',
      args: [],
    );
  }

  /// `If a header exists, it will be removed`
  String get ImportMembersHeaderStrippedMessage {
    return Intl.message(
      'If a header exists, it will be removed',
      name: 'ImportMembersHeaderStrippedMessage',
      desc: '',
      args: [],
    );
  }

  /// `Export Ride`
  String get ExportRideTitle {
    return Intl.message(
      'Export Ride',
      name: 'ExportRideTitle',
      desc: '',
      args: [],
    );
  }

  /// `ride_{date}`
  String ExportRideFileNamePlaceholder(Object date) {
    return Intl.message(
      'ride_$date',
      name: 'ExportRideFileNamePlaceholder',
      desc: '',
      args: [date],
    );
  }

  /// `Ride saved at {path}`
  String ExportRideExportedToPathMessage(Object path) {
    return Intl.message(
      'Ride saved at $path',
      name: 'ExportRideExportedToPathMessage',
      desc: '',
      args: [path],
    );
  }

  /// `Exporting ride to file`
  String get ExportRideExportingToFile {
    return Intl.message(
      'Exporting ride to file',
      name: 'ExportRideExportingToFile',
      desc: '',
      args: [],
    );
  }

  /// `Export`
  String get Export {
    return Intl.message(
      'Export',
      name: 'Export',
      desc: '',
      args: [],
    );
  }

  /// `Export Rides`
  String get ExportRidesTitle {
    return Intl.message(
      'Export Rides',
      name: 'ExportRidesTitle',
      desc: '',
      args: [],
    );
  }

  /// `Exporting rides and attendees`
  String get ExportingRidesDescription {
    return Intl.message(
      'Exporting rides and attendees',
      name: 'ExportingRidesDescription',
      desc: '',
      args: [],
    );
  }

  /// `Start`
  String get RideStart {
    return Intl.message(
      'Start',
      name: 'RideStart',
      desc: '',
      args: [],
    );
  }

  /// `Destination`
  String get RideDestination {
    return Intl.message(
      'Destination',
      name: 'RideDestination',
      desc: '',
      args: [],
    );
  }

  /// `Unknown`
  String get DeviceUnknown {
    return Intl.message(
      'Unknown',
      name: 'DeviceUnknown',
      desc: '',
      args: [],
    );
  }

  /// `GPS`
  String get DeviceGPS {
    return Intl.message(
      'GPS',
      name: 'DeviceGPS',
      desc: '',
      args: [],
    );
  }

  /// `Phone`
  String get DevicePhone {
    return Intl.message(
      'Phone',
      name: 'DevicePhone',
      desc: '',
      args: [],
    );
  }

  /// `Watch`
  String get DeviceWatch {
    return Intl.message(
      'Watch',
      name: 'DeviceWatch',
      desc: '',
      args: [],
    );
  }

  /// `Power meter`
  String get DevicePowerMeter {
    return Intl.message(
      'Power meter',
      name: 'DevicePowerMeter',
      desc: '',
      args: [],
    );
  }

  /// `Cadence meter`
  String get DeviceCadenceMeter {
    return Intl.message(
      'Cadence meter',
      name: 'DeviceCadenceMeter',
      desc: '',
      args: [],
    );
  }

  /// `Headset`
  String get DeviceHeadset {
    return Intl.message(
      'Headset',
      name: 'DeviceHeadset',
      desc: '',
      args: [],
    );
  }

  /// `Pulse Monitor`
  String get DevicePulseMonitor {
    return Intl.message(
      'Pulse Monitor',
      name: 'DevicePulseMonitor',
      desc: '',
      args: [],
    );
  }

  /// `Device name is max. {maxLength} characters`
  String DeviceNameMaxLength(Object maxLength) {
    return Intl.message(
      'Device name is max. $maxLength characters',
      name: 'DeviceNameMaxLength',
      desc: '',
      args: [maxLength],
    );
  }

  /// `A device name cannot contain a ,`
  String get DeviceNameCannotContainComma {
    return Intl.message(
      'A device name cannot contain a ,',
      name: 'DeviceNameCannotContainComma',
      desc: '',
      args: [],
    );
  }

  /// `This device already exists`
  String get DeviceAlreadyExists {
    return Intl.message(
      'This device already exists',
      name: 'DeviceAlreadyExists',
      desc: '',
      args: [],
    );
  }

  /// `A device name can't be empty`
  String get DeviceNameBlank {
    return Intl.message(
      'A device name can\'t be empty',
      name: 'DeviceNameBlank',
      desc: '',
      args: [],
    );
  }

  /// `Delete Device`
  String get DeleteDeviceTitle {
    return Intl.message(
      'Delete Device',
      name: 'DeleteDeviceTitle',
      desc: '',
      args: [],
    );
  }

  /// `Are you sure you want to delete this device?`
  String get DeleteDeviceDescription {
    return Intl.message(
      'Are you sure you want to delete this device?',
      name: 'DeleteDeviceDescription',
      desc: '',
      args: [],
    );
  }

  /// `Could not delete the device`
  String get DeleteDeviceErrorDescription {
    return Intl.message(
      'Could not delete the device',
      name: 'DeleteDeviceErrorDescription',
      desc: '',
      args: [],
    );
  }

  /// `Settings`
  String get SettingsTitle {
    return Intl.message(
      'Settings',
      name: 'SettingsTitle',
      desc: '',
      args: [],
    );
  }

  /// `Duration of a scan (in seconds)`
  String get SettingsScanSliderHeader {
    return Intl.message(
      'Duration of a scan (in seconds)',
      name: 'SettingsScanSliderHeader',
      desc: '',
      args: [],
    );
  }

  /// `Loading Settings`
  String get SettingsLoading {
    return Intl.message(
      'Loading Settings',
      name: 'SettingsLoading',
      desc: '',
      args: [],
    );
  }

  /// `Could not load the settings`
  String get SettingsLoadingError {
    return Intl.message(
      'Could not load the settings',
      name: 'SettingsLoadingError',
      desc: '',
      args: [],
    );
  }

  /// `Could not save the settings`
  String get SettingsSubmitError {
    return Intl.message(
      'Could not save the settings',
      name: 'SettingsSubmitError',
      desc: '',
      args: [],
    );
  }

  /// `First Name`
  String get PersonFirstNameLabel {
    return Intl.message(
      'First Name',
      name: 'PersonFirstNameLabel',
      desc: '',
      args: [],
    );
  }

  /// `Last Name`
  String get PersonLastNameLabel {
    return Intl.message(
      'Last Name',
      name: 'PersonLastNameLabel',
      desc: '',
      args: [],
    );
  }

  /// `Alias`
  String get PersonAliasLabel {
    return Intl.message(
      'Alias',
      name: 'PersonAliasLabel',
      desc: '',
      args: [],
    );
  }

  /// `First Name can't be longer than {maxLength} characters`
  String FirstNameMaxLength(Object maxLength) {
    return Intl.message(
      'First Name can\'t be longer than $maxLength characters',
      name: 'FirstNameMaxLength',
      desc: '',
      args: [maxLength],
    );
  }

  /// `Last Name can't be longer than {maxLength} characters`
  String LastNameMaxLength(Object maxLength) {
    return Intl.message(
      'Last Name can\'t be longer than $maxLength characters',
      name: 'LastNameMaxLength',
      desc: '',
      args: [maxLength],
    );
  }

  /// `First Name can't be blank`
  String get FirstNameBlank {
    return Intl.message(
      'First Name can\'t be blank',
      name: 'FirstNameBlank',
      desc: '',
      args: [],
    );
  }

  /// `Last Name can't be blank`
  String get LastNameBlank {
    return Intl.message(
      'Last Name can\'t be blank',
      name: 'LastNameBlank',
      desc: '',
      args: [],
    );
  }

  /// `First Name can only contain letters, spaces or ' -`
  String get FirstNameIllegalCharacters {
    return Intl.message(
      'First Name can only contain letters, spaces or \' -',
      name: 'FirstNameIllegalCharacters',
      desc: '',
      args: [],
    );
  }

  /// `Last Name can only contain letters, spaces or ' -`
  String get LastNameIllegalCharacters {
    return Intl.message(
      'Last Name can only contain letters, spaces or \' -',
      name: 'LastNameIllegalCharacters',
      desc: '',
      args: [],
    );
  }

  /// `An alias can't be longer than {maxLength} characters`
  String AliasMaxLength(Object maxLength) {
    return Intl.message(
      'An alias can\'t be longer than $maxLength characters',
      name: 'AliasMaxLength',
      desc: '',
      args: [maxLength],
    );
  }

  /// `An alias can't be blank`
  String get AliasBlank {
    return Intl.message(
      'An alias can\'t be blank',
      name: 'AliasBlank',
      desc: '',
      args: [],
    );
  }

  /// `An alias can only contain letters, spaces or ' -`
  String get AliasIllegalCharacters {
    return Intl.message(
      'An alias can only contain letters, spaces or \' -',
      name: 'AliasIllegalCharacters',
      desc: '',
      args: [],
    );
  }

  /// `{value} is required`
  String ValueIsRequired(Object value) {
    return Intl.message(
      '$value is required',
      name: 'ValueIsRequired',
      desc: '',
      args: [value],
    );
  }

  /// `Cancel`
  String get DialogCancel {
    return Intl.message(
      'Cancel',
      name: 'DialogCancel',
      desc: '',
      args: [],
    );
  }

  /// `Delete`
  String get DialogDelete {
    return Intl.message(
      'Delete',
      name: 'DialogDelete',
      desc: '',
      args: [],
    );
  }

  /// `Ok`
  String get DialogDismiss {
    return Intl.message(
      'Ok',
      name: 'DialogDismiss',
      desc: '',
      args: [],
    );
  }

  /// `Something went wrong`
  String get GenericError {
    return Intl.message(
      'Something went wrong',
      name: 'GenericError',
      desc: '',
      args: [],
    );
  }

  /// `Go Back`
  String get GoBack {
    return Intl.message(
      'Go Back',
      name: 'GoBack',
      desc: '',
      args: [],
    );
  }

  /// `Km`
  String get DistanceKm {
    return Intl.message(
      'Km',
      name: 'DistanceKm',
      desc: '',
      args: [],
    );
  }

  /// `Filename`
  String get Filename {
    return Intl.message(
      'Filename',
      name: 'Filename',
      desc: '',
      args: [],
    );
  }

  /// `Invalid filename`
  String get InvalidFilename {
    return Intl.message(
      'Invalid filename',
      name: 'InvalidFilename',
      desc: '',
      args: [],
    );
  }

  /// `A filename can't be blank`
  String get FilenameWhitespace {
    return Intl.message(
      'A filename can\'t be blank',
      name: 'FilenameWhitespace',
      desc: '',
      args: [],
    );
  }

  /// `This file already exists`
  String get FileExists {
    return Intl.message(
      'This file already exists',
      name: 'FileExists',
      desc: '',
      args: [],
    );
  }

  /// `A filename can't be longer than {maxLength} characters`
  String FilenameMaxLength(Object maxLength) {
    return Intl.message(
      'A filename can\'t be longer than $maxLength characters',
      name: 'FilenameMaxLength',
      desc: '',
      args: [maxLength],
    );
  }

  /// `csv`
  String get FileCsvExtension {
    return Intl.message(
      'csv',
      name: 'FileCsvExtension',
      desc: '',
      args: [],
    );
  }

  /// `json`
  String get FileJsonExtension {
    return Intl.message(
      'json',
      name: 'FileJsonExtension',
      desc: '',
      args: [],
    );
  }
}

class AppLocalizationDelegate extends LocalizationsDelegate<S> {
  const AppLocalizationDelegate();

  List<Locale> get supportedLocales {
    return const <Locale>[
      Locale.fromSubtags(languageCode: 'en'),
      Locale.fromSubtags(languageCode: 'nl'),
    ];
  }

  @override
  bool isSupported(Locale locale) => _isSupported(locale);
  @override
  Future<S> load(Locale locale) => S.load(locale);
  @override
  bool shouldReload(AppLocalizationDelegate old) => false;

  bool _isSupported(Locale locale) {
    if (locale != null) {
      for (var supportedLocale in supportedLocales) {
        if (supportedLocale.languageCode == locale.languageCode) {
          return true;
        }
      }
    }
    return false;
  }
}