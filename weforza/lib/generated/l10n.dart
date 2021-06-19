// GENERATED CODE - DO NOT MODIFY BY HAND
import 'package:flutter/material.dart';
import 'package:intl/intl.dart';
import 'intl/messages_all.dart';

// **************************************************************************
// Generator: Flutter Intl IDE plugin
// Made by Localizely
// **************************************************************************

// ignore_for_file: non_constant_identifier_names, lines_longer_than_80_chars
// ignore_for_file: join_return_with_assignment, prefer_final_in_for_each
// ignore_for_file: avoid_redundant_argument_values, avoid_escaping_inner_quotes

class S {
  S();

  static S? _current;

  static S get current {
    assert(_current != null,
        'No instance of S was loaded. Try to initialize the S delegate before accessing S.current.');
    return _current!;
  }

  static const AppLocalizationDelegate delegate = AppLocalizationDelegate();

  static Future<S> load(Locale locale) {
    final name = (locale.countryCode?.isEmpty ?? false)
        ? locale.languageCode
        : locale.toString();
    final localeName = Intl.canonicalizedLocale(name);
    return initializeMessages(localeName).then((_) {
      Intl.defaultLocale = localeName;
      final instance = S();
      S._current = instance;

      return instance;
    });
  }

  static S of(BuildContext context) {
    final instance = S.maybeOf(context);
    assert(instance != null,
        'No instance of S present in the widget tree. Did you add S.delegate in localizationsDelegates?');
    return instance!;
  }

  static S? maybeOf(BuildContext context) {
    return Localizations.of<S>(context, S);
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

  /// `Rides`
  String get Rides {
    return Intl.message(
      'Rides',
      name: 'Rides',
      desc: '',
      args: [],
    );
  }

  /// `Riders`
  String get Riders {
    return Intl.message(
      'Riders',
      name: 'Riders',
      desc: '',
      args: [],
    );
  }

  /// `Settings`
  String get Settings {
    return Intl.message(
      'Settings',
      name: 'Settings',
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

  /// `Delete`
  String get Delete {
    return Intl.message(
      'Delete',
      name: 'Delete',
      desc: '',
      args: [],
    );
  }

  /// `Cancel`
  String get Cancel {
    return Intl.message(
      'Cancel',
      name: 'Cancel',
      desc: '',
      args: [],
    );
  }

  /// `Ok`
  String get Ok {
    return Intl.message(
      'Ok',
      name: 'Ok',
      desc: '',
      args: [],
    );
  }

  /// `Details`
  String get Details {
    return Intl.message(
      'Details',
      name: 'Details',
      desc: '',
      args: [],
    );
  }

  /// `Devices`
  String get Devices {
    return Intl.message(
      'Devices',
      name: 'Devices',
      desc: '',
      args: [],
    );
  }

  /// `Save changes`
  String get SaveChanges {
    return Intl.message(
      'Save changes',
      name: 'SaveChanges',
      desc: '',
      args: [],
    );
  }

  /// `Save`
  String get Save {
    return Intl.message(
      'Save',
      name: 'Save',
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

  /// `Active`
  String get Active {
    return Intl.message(
      'Active',
      name: 'Active',
      desc: '',
      args: [],
    );
  }

  /// `Inactive`
  String get Inactive {
    return Intl.message(
      'Inactive',
      name: 'Inactive',
      desc: '',
      args: [],
    );
  }

  /// `All`
  String get All {
    return Intl.message(
      'All',
      name: 'All',
      desc: '',
      args: [],
    );
  }

  /// `Filter`
  String get Filter {
    return Intl.message(
      'Filter',
      name: 'Filter',
      desc: '',
      args: [],
    );
  }

  /// `There is nothing to show`
  String get ListEmpty {
    return Intl.message(
      'There is nothing to show',
      name: 'ListEmpty',
      desc: '',
      args: [],
    );
  }

  /// `Riders ({amount})`
  String RidersListTitle(Object amount) {
    return Intl.message(
      'Riders ($amount)',
      name: 'RidersListTitle',
      desc: '',
      args: [amount],
    );
  }

  /// `This ride has no attendants`
  String get RideDetailsNoAttendees {
    return Intl.message(
      'This ride has no attendants',
      name: 'RideDetailsNoAttendees',
      desc: '',
      args: [],
    );
  }

  /// `Total`
  String get RideDetailsTotalAttendeesTooltip {
    return Intl.message(
      'Total',
      name: 'RideDetailsTotalAttendeesTooltip',
      desc: '',
      args: [],
    );
  }

  /// `Scanned`
  String get RideDetailsScannedAttendeesTooltip {
    return Intl.message(
      'Scanned',
      name: 'RideDetailsScannedAttendeesTooltip',
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

  /// `This rider has no devices yet`
  String get MemberDetailsNoDevices {
    return Intl.message(
      'This rider has no devices yet',
      name: 'MemberDetailsNoDevices',
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

  /// `Add device`
  String get AddDeviceSubmit {
    return Intl.message(
      'Add device',
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

  /// `Edit Rider`
  String get EditMemberTitle {
    return Intl.message(
      'Edit Rider',
      name: 'EditMemberTitle',
      desc: '',
      args: [],
    );
  }

  /// `Delete Rider`
  String get MemberDeleteDialogTitle {
    return Intl.message(
      'Delete Rider',
      name: 'MemberDeleteDialogTitle',
      desc: '',
      args: [],
    );
  }

  /// `Are you sure that you want to delete this rider?`
  String get MemberDeleteDialogDescription {
    return Intl.message(
      'Are you sure that you want to delete this rider?',
      name: 'MemberDeleteDialogDescription',
      desc: '',
      args: [],
    );
  }

  /// `New Rider`
  String get AddMemberTitle {
    return Intl.message(
      'New Rider',
      name: 'AddMemberTitle',
      desc: '',
      args: [],
    );
  }

  /// `Create New Rider`
  String get AddMemberSubmit {
    return Intl.message(
      'Create New Rider',
      name: 'AddMemberSubmit',
      desc: '',
      args: [],
    );
  }

  /// `This rider already exists`
  String get MemberAlreadyExists {
    return Intl.message(
      'This rider already exists',
      name: 'MemberAlreadyExists',
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

  /// `Please select at least one date`
  String get AddRideEmptySelection {
    return Intl.message(
      'Please select at least one date',
      name: 'AddRideEmptySelection',
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

  /// `Cannot start a scan, there are no riders`
  String get RideAttendeeScanningNoMembers {
    return Intl.message(
      'Cannot start a scan, there are no riders',
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

  /// `Scan aborted, permission was denied.`
  String get RideAttendeeScanningPermissionDenied {
    return Intl.message(
      'Scan aborted, permission was denied.',
      name: 'RideAttendeeScanningPermissionDenied',
      desc: '',
      args: [],
    );
  }

  /// `Scanning requires permission to use your location.`
  String get RideAttendeeScanningPermissionDeniedDescription {
    return Intl.message(
      'Scanning requires permission to use your location.',
      name: 'RideAttendeeScanningPermissionDeniedDescription',
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

  /// `Continue`
  String get RideAttendeeScanningContinue {
    return Intl.message(
      'Continue',
      name: 'RideAttendeeScanningContinue',
      desc: '',
      args: [],
    );
  }

  /// `There are no riders to choose from`
  String get RideAttendeeScanningManualSelectionEmptyList {
    return Intl.message(
      'There are no riders to choose from',
      name: 'RideAttendeeScanningManualSelectionEmptyList',
      desc: '',
      args: [],
    );
  }

  /// `{amount} riders have a device with this name`
  String RideAttendeeScanningDeviceWithMultiplePossibleOwnersLabel(
      Object amount) {
    return Intl.message(
      '$amount riders have a device with this name',
      name: 'RideAttendeeScanningDeviceWithMultiplePossibleOwnersLabel',
      desc: '',
      args: [amount],
    );
  }

  /// `Some scanned devices have multiple possible owners. You can select the attending owners here.`
  String get RideAttendeeScanningUnresolvedOwnersListTooltip {
    return Intl.message(
      'Some scanned devices have multiple possible owners. You can select the attending owners here.',
      name: 'RideAttendeeScanningUnresolvedOwnersListTooltip',
      desc: '',
      args: [],
    );
  }

  /// `Nothing found for the specified search term`
  String get RiderSearchFilterNoResults {
    return Intl.message(
      'Nothing found for the specified search term',
      name: 'RiderSearchFilterNoResults',
      desc: '',
      args: [],
    );
  }

  /// `Search riders`
  String get RiderSearchFilterInputLabel {
    return Intl.message(
      'Search riders',
      name: 'RiderSearchFilterInputLabel',
      desc: '',
      args: [],
    );
  }

  /// `Import Riders`
  String get ImportMembersPageTitle {
    return Intl.message(
      'Import Riders',
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

  /// `Please choose a file to import riders`
  String get ImportMembersPickFileWarning {
    return Intl.message(
      'Please choose a file to import riders',
      name: 'ImportMembersPickFileWarning',
      desc: '',
      args: [],
    );
  }

  /// `Importing Riders`
  String get ImportMembersImporting {
    return Intl.message(
      'Importing Riders',
      name: 'ImportMembersImporting',
      desc: '',
      args: [],
    );
  }

  /// `(firstname),(lastname),(alias),(active),(last_updated),(devices)(.*)`
  String get ImportMembersCsvHeaderRegex {
    return Intl.message(
      '(firstname),(lastname),(alias),(active),(last_updated),(devices)(.*)',
      name: 'ImportMembersCsvHeaderRegex',
      desc: '',
      args: [],
    );
  }

  /// `A header is required for .csv files.`
  String get ImportMembersCsvHeaderRequired {
    return Intl.message(
      'A header is required for .csv files.',
      name: 'ImportMembersCsvHeaderRequired',
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

  /// `Only .csv or .json files are allowed`
  String get ImportMembersInvalidFileExtension {
    return Intl.message(
      'Only .csv or .json files are allowed',
      name: 'ImportMembersInvalidFileExtension',
      desc: '',
      args: [],
    );
  }

  /// `The chosen .json file is incompatible.`
  String get ImportMembersIncompatibleFileJsonContents {
    return Intl.message(
      'The chosen .json file is incompatible.',
      name: 'ImportMembersIncompatibleFileJsonContents',
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

  /// `Exporting ride to file`
  String get ExportRideExportingToFile {
    return Intl.message(
      'Exporting ride to file',
      name: 'ExportRideExportingToFile',
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

  /// `Exporting rides and attendants`
  String get ExportingRidesDescription {
    return Intl.message(
      'Exporting rides and attendants',
      name: 'ExportingRidesDescription',
      desc: '',
      args: [],
    );
  }

  /// `Export Riders`
  String get ExportMembersTitle {
    return Intl.message(
      'Export Riders',
      name: 'ExportMembersTitle',
      desc: '',
      args: [],
    );
  }

  /// `Exporting riders and devices`
  String get ExportingMembersDescription {
    return Intl.message(
      'Exporting riders and devices',
      name: 'ExportingMembersDescription',
      desc: '',
      args: [],
    );
  }

  /// `firstname,lastname,alias,active,last_updated,devices`
  String get ExportMembersCsvHeader {
    return Intl.message(
      'firstname,lastname,alias,active,last_updated,devices',
      name: 'ExportMembersCsvHeader',
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

  /// `A device name can't be empty`
  String get DeviceNameBlank {
    return Intl.message(
      'A device name can\'t be empty',
      name: 'DeviceNameBlank',
      desc: '',
      args: [],
    );
  }

  /// `This person already has a device with this name`
  String get DeviceExists {
    return Intl.message(
      'This person already has a device with this name',
      name: 'DeviceExists',
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

  /// `Reset Calendar`
  String get SettingsResetRideCalendarButtonLabel {
    return Intl.message(
      'Reset Calendar',
      name: 'SettingsResetRideCalendarButtonLabel',
      desc: '',
      args: [],
    );
  }

  /// `This will remove all rides.\nThe attendances will be reset to zero.`
  String get SettingsResetRideCalendarDescription {
    return Intl.message(
      'This will remove all rides.\nThe attendances will be reset to zero.',
      name: 'SettingsResetRideCalendarDescription',
      desc: '',
      args: [],
    );
  }

  /// `Could not reset the ride calendar.`
  String get SettingsResetRideCalendarErrorMessage {
    return Intl.message(
      'Could not reset the ride calendar.',
      name: 'SettingsResetRideCalendarErrorMessage',
      desc: '',
      args: [],
    );
  }

  /// `Reset Calendar`
  String get SettingsResetRideCalendarDialogTitle {
    return Intl.message(
      'Reset Calendar',
      name: 'SettingsResetRideCalendarDialogTitle',
      desc: '',
      args: [],
    );
  }

  /// `Are you sure that you want to remove all the rides?`
  String get SettingsResetRideCalendarDialogDescription {
    return Intl.message(
      'Are you sure that you want to remove all the rides?',
      name: 'SettingsResetRideCalendarDialogDescription',
      desc: '',
      args: [],
    );
  }

  /// `Clear`
  String get SettingsResetRideCalendarDialogConfirm {
    return Intl.message(
      'Clear',
      name: 'SettingsResetRideCalendarDialogConfirm',
      desc: '',
      args: [],
    );
  }

  /// `Rider List Filter`
  String get SettingsRiderFilterHeader {
    return Intl.message(
      'Rider List Filter',
      name: 'SettingsRiderFilterHeader',
      desc: '',
      args: [],
    );
  }

  /// `Filter riders in the rider list, based on their status`
  String get SettingsRiderFilterDescription {
    return Intl.message(
      'Filter riders in the rider list, based on their status',
      name: 'SettingsRiderFilterDescription',
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
    for (var supportedLocale in supportedLocales) {
      if (supportedLocale.languageCode == locale.languageCode) {
        return true;
      }
    }
    return false;
  }
}
