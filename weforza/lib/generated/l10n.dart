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

  /// `Manage Devices`
  String get DeviceOverviewTitle {
    return Intl.message(
      'Manage Devices',
      name: 'DeviceOverviewTitle',
      desc: '',
      args: [],
    );
  }

  /// `No Devices`
  String get DeviceOverviewNoDevices {
    return Intl.message(
      'No Devices',
      name: 'DeviceOverviewNoDevices',
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

  /// `Devices`
  String get DevicesHeader {
    return Intl.message(
      'Devices',
      name: 'DevicesHeader',
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

  /// `Something went wrong`
  String get AddDeviceGenericError {
    return Intl.message(
      'Something went wrong',
      name: 'AddDeviceGenericError',
      desc: '',
      args: [],
    );
  }

  /// `Add Device`
  String get AddDeviceSubmit {
    return Intl.message(
      'Add Device',
      name: 'AddDeviceSubmit',
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

  /// `Add Members`
  String get RideAttendeeScanningProcessAddMembersLabel {
    return Intl.message(
      'Add Members',
      name: 'RideAttendeeScanningProcessAddMembersLabel',
      desc: '',
      args: [],
    );
  }

  /// `Attendees`
  String get RideAttendeeAssignmentTitle {
    return Intl.message(
      'Attendees',
      name: 'RideAttendeeAssignmentTitle',
      desc: '',
      args: [],
    );
  }

  /// `Loading members for assignment`
  String get RideAttendeeAssignmentLoadingMembers {
    return Intl.message(
      'Loading members for assignment',
      name: 'RideAttendeeAssignmentLoadingMembers',
      desc: '',
      args: [],
    );
  }

  /// `The scan failed`
  String get RideAttendeeAssignmentScanningFailed {
    return Intl.message(
      'The scan failed',
      name: 'RideAttendeeAssignmentScanningFailed',
      desc: '',
      args: [],
    );
  }

  /// `Return to the list`
  String get RideAttendeeAssignmentReturnToList {
    return Intl.message(
      'Return to the list',
      name: 'RideAttendeeAssignmentReturnToList',
      desc: '',
      args: [],
    );
  }

  /// `Scanning for attendees`
  String get RideAttendeeAssignmentScanningTitle {
    return Intl.message(
      'Scanning for attendees',
      name: 'RideAttendeeAssignmentScanningTitle',
      desc: '',
      args: [],
    );
  }

  /// `Stop Scan`
  String get RideAttendeeAssignmentStopScan {
    return Intl.message(
      'Stop Scan',
      name: 'RideAttendeeAssignmentStopScan',
      desc: '',
      args: [],
    );
  }

  /// `Saving Attendees`
  String get RideAttendeeAssignmentSubmitting {
    return Intl.message(
      'Saving Attendees',
      name: 'RideAttendeeAssignmentSubmitting',
      desc: '',
      args: [],
    );
  }

  /// `Could not save attendees`
  String get RideAttendeeAssignmentSubmitError {
    return Intl.message(
      'Could not save attendees',
      name: 'RideAttendeeAssignmentSubmitError',
      desc: '',
      args: [],
    );
  }

  /// `Something went wrong`
  String get RideAttendeeAssignmentError {
    return Intl.message(
      'Something went wrong',
      name: 'RideAttendeeAssignmentError',
      desc: '',
      args: [],
    );
  }

  /// `Loading all known devices`
  String get RideAttendeeAssignmentLoadingDevices {
    return Intl.message(
      'Loading all known devices',
      name: 'RideAttendeeAssignmentLoadingDevices',
      desc: '',
      args: [],
    );
  }

  /// `Processing Scan Results`
  String get RideAttendeeAssignmentProcessingScanResult {
    return Intl.message(
      'Processing Scan Results',
      name: 'RideAttendeeAssignmentProcessingScanResult',
      desc: '',
      args: [],
    );
  }

  /// `The previous scan wasn't finished`
  String get RideAttendeeAssignmentAlreadyScanning {
    return Intl.message(
      'The previous scan wasn\'t finished',
      name: 'RideAttendeeAssignmentAlreadyScanning',
      desc: '',
      args: [],
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

  /// `A title can't be only whitespace`
  String get EditRideTitleWhitespace {
    return Intl.message(
      'A title can\'t be only whitespace',
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

  /// `An address cannot be only whitespace`
  String get EditRideAddressWhitespace {
    return Intl.message(
      'An address cannot be only whitespace',
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

  /// `Device Type`
  String get DeviceTypeLabel {
    return Intl.message(
      'Device Type',
      name: 'DeviceTypeLabel',
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

  /// `Tablet`
  String get DeviceTablet {
    return Intl.message(
      'Tablet',
      name: 'DeviceTablet',
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

  /// `This device already exists`
  String get DeviceAlreadyExists {
    return Intl.message(
      'This device already exists',
      name: 'DeviceAlreadyExists',
      desc: '',
      args: [],
    );
  }

  /// `Found {device}`
  String DeviceFound(Object device) {
    return Intl.message(
      'Found $device',
      name: 'DeviceFound',
      desc: '',
      args: [device],
    );
  }

  /// `Edit Device`
  String get EditDeviceSubmit {
    return Intl.message(
      'Edit Device',
      name: 'EditDeviceSubmit',
      desc: '',
      args: [],
    );
  }

  /// `Delete {device}?`
  String DeleteDeviceDescription(Object device) {
    return Intl.message(
      'Delete $device?',
      name: 'DeleteDeviceDescription',
      desc: '',
      args: [device],
    );
  }

  /// `Could not delete {device}`
  String DeleteDeviceError(Object device) {
    return Intl.message(
      'Could not delete $device',
      name: 'DeleteDeviceError',
      desc: '',
      args: [device],
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

  /// `Something went wrong`
  String get SettingsGenericError {
    return Intl.message(
      'Something went wrong',
      name: 'SettingsGenericError',
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

  /// `Show All Scanned Devices`
  String get SettingsShowAllDevicesOptionLabel {
    return Intl.message(
      'Show All Scanned Devices',
      name: 'SettingsShowAllDevicesOptionLabel',
      desc: '',
      args: [],
    );
  }

  /// `Show all scanned devices, regardless if they belong to a known person or not.`
  String get SettingsShowAllDevicesOptionDescription {
    return Intl.message(
      'Show all scanned devices, regardless if they belong to a known person or not.',
      name: 'SettingsShowAllDevicesOptionDescription',
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

  /// `Telephone`
  String get PersonTelephoneLabel {
    return Intl.message(
      'Telephone',
      name: 'PersonTelephoneLabel',
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

  /// `First Name can't be just whitespace`
  String get FirstNameBlank {
    return Intl.message(
      'First Name can\'t be just whitespace',
      name: 'FirstNameBlank',
      desc: '',
      args: [],
    );
  }

  /// `Last Name can't be just whitespace`
  String get LastNameBlank {
    return Intl.message(
      'Last Name can\'t be just whitespace',
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

  /// `A phone number can only contain digits`
  String get PhoneIllegalCharacters {
    return Intl.message(
      'A phone number can only contain digits',
      name: 'PhoneIllegalCharacters',
      desc: '',
      args: [],
    );
  }

  /// `A phone number is minimum {minLength} digits long`
  String PhoneMinLength(Object minLength) {
    return Intl.message(
      'A phone number is minimum $minLength digits long',
      name: 'PhoneMinLength',
      desc: '',
      args: [minLength],
    );
  }

  /// `A phone number is maximum {maxLength} digits long`
  String PhoneMaxLength(Object maxLength) {
    return Intl.message(
      'A phone number is maximum $maxLength digits long',
      name: 'PhoneMaxLength',
      desc: '',
      args: [maxLength],
    );
  }

  /// `Enable Bluetooth`
  String get EnableBluetoothDialogTitle {
    return Intl.message(
      'Enable Bluetooth',
      name: 'EnableBluetoothDialogTitle',
      desc: '',
      args: [],
    );
  }

  /// `Bluetooth is required to start a scan. Do you want to go to Settings?`
  String get EnableBluetoothDialogDescription {
    return Intl.message(
      'Bluetooth is required to start a scan. Do you want to go to Settings?',
      name: 'EnableBluetoothDialogDescription',
      desc: '',
      args: [],
    );
  }

  /// `Go To Settings`
  String get EnableBluetoothGoToSettings {
    return Intl.message(
      'Go To Settings',
      name: 'EnableBluetoothGoToSettings',
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
  String get DialogOk {
    return Intl.message(
      'Ok',
      name: 'DialogOk',
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