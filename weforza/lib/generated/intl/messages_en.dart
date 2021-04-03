// DO NOT EDIT. This is code generated via package:intl/generate_localized.dart
// This is a library that provides messages for a en locale. All the
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
  String get localeName => 'en';

  static m0(maxLength) => "An alias can\'t be longer than ${maxLength} characters";

  static m1(version) => "Version: ${version}";

  static m2(count) => "${count} attendants";

  static m3(maxLength) => "Device name is max. ${maxLength} characters";

  static m4(date) => "ride_${date}";

  static m5(maxLength) => "A filename can\'t be longer than ${maxLength} characters";

  static m6(maxLength) => "First Name can\'t be longer than ${maxLength} characters";

  static m7(maxLength) => "Last Name can\'t be longer than ${maxLength} characters";

  static m8(amount) => "${amount} riders have a device with this name";

  static m9(amount) => "Riders (${amount})";

  static m10(value) => "${value} is required";

  final messages = _notInlinedMessages(_notInlinedMessages);
  static _notInlinedMessages(_) => <String, Function> {
    "Active" : MessageLookupByLibrary.simpleMessage("Active"),
    "AddDeviceSubmit" : MessageLookupByLibrary.simpleMessage("Add device"),
    "AddDeviceTitle" : MessageLookupByLibrary.simpleMessage("Add Device"),
    "AddMemberSubmit" : MessageLookupByLibrary.simpleMessage("Create New Rider"),
    "AddMemberTitle" : MessageLookupByLibrary.simpleMessage("New Rider"),
    "AddRideColorLegendCurrentSelection" : MessageLookupByLibrary.simpleMessage("Current Selection"),
    "AddRideColorLegendFutureRide" : MessageLookupByLibrary.simpleMessage("Future Ride"),
    "AddRideColorLegendPastDay" : MessageLookupByLibrary.simpleMessage("Past Day Without Ride"),
    "AddRideColorLegendPastRide" : MessageLookupByLibrary.simpleMessage("Past Day With Ride"),
    "AddRideEmptySelection" : MessageLookupByLibrary.simpleMessage("Please select at least one date"),
    "AddRideSubmit" : MessageLookupByLibrary.simpleMessage("Add Selection"),
    "AddRideTitle" : MessageLookupByLibrary.simpleMessage("New Ride"),
    "AliasBlank" : MessageLookupByLibrary.simpleMessage("An alias can\'t be blank"),
    "AliasIllegalCharacters" : MessageLookupByLibrary.simpleMessage("An alias can only contain letters, spaces or \' -"),
    "AliasMaxLength" : m0,
    "All" : MessageLookupByLibrary.simpleMessage("All"),
    "AppVersionNumber" : m1,
    "AttendeeCounterMany" : m2,
    "AttendeeCounterOne" : MessageLookupByLibrary.simpleMessage("One attendant"),
    "Cancel" : MessageLookupByLibrary.simpleMessage("Cancel"),
    "Delete" : MessageLookupByLibrary.simpleMessage("Delete"),
    "DeleteDeviceDescription" : MessageLookupByLibrary.simpleMessage("Are you sure you want to delete this device?"),
    "DeleteDeviceTitle" : MessageLookupByLibrary.simpleMessage("Delete Device"),
    "Details" : MessageLookupByLibrary.simpleMessage("Details"),
    "DeviceCadenceMeter" : MessageLookupByLibrary.simpleMessage("Cadence meter"),
    "DeviceExists" : MessageLookupByLibrary.simpleMessage("This person already has a device with this name"),
    "DeviceGPS" : MessageLookupByLibrary.simpleMessage("GPS"),
    "DeviceHeadset" : MessageLookupByLibrary.simpleMessage("Headset"),
    "DeviceNameBlank" : MessageLookupByLibrary.simpleMessage("A device name can\'t be empty"),
    "DeviceNameCannotContainComma" : MessageLookupByLibrary.simpleMessage("A device name cannot contain a ,"),
    "DeviceNameLabel" : MessageLookupByLibrary.simpleMessage("Device Name"),
    "DeviceNameMaxLength" : m3,
    "DevicePhone" : MessageLookupByLibrary.simpleMessage("Phone"),
    "DevicePowerMeter" : MessageLookupByLibrary.simpleMessage("Power meter"),
    "DevicePulseMonitor" : MessageLookupByLibrary.simpleMessage("Pulse Monitor"),
    "DeviceUnknown" : MessageLookupByLibrary.simpleMessage("Unknown"),
    "DeviceWatch" : MessageLookupByLibrary.simpleMessage("Watch"),
    "Devices" : MessageLookupByLibrary.simpleMessage("Devices"),
    "DevicesListNoDevices" : MessageLookupByLibrary.simpleMessage("No devices to show"),
    "EditDeviceTitle" : MessageLookupByLibrary.simpleMessage("Edit Device"),
    "EditMemberTitle" : MessageLookupByLibrary.simpleMessage("Edit Rider"),
    "Export" : MessageLookupByLibrary.simpleMessage("Export"),
    "ExportMembersCsvHeader" : MessageLookupByLibrary.simpleMessage("firstname,lastname,alias,active,devices"),
    "ExportMembersTitle" : MessageLookupByLibrary.simpleMessage("Export Riders"),
    "ExportRideExportingToFile" : MessageLookupByLibrary.simpleMessage("Exporting ride to file"),
    "ExportRideFileNamePlaceholder" : m4,
    "ExportRideTitle" : MessageLookupByLibrary.simpleMessage("Export Ride"),
    "ExportRidesTitle" : MessageLookupByLibrary.simpleMessage("Export Rides"),
    "ExportingMembersDescription" : MessageLookupByLibrary.simpleMessage("Exporting riders and devices"),
    "ExportingRidesDescription" : MessageLookupByLibrary.simpleMessage("Exporting rides and attendants"),
    "FileCsvExtension" : MessageLookupByLibrary.simpleMessage("csv"),
    "FileExists" : MessageLookupByLibrary.simpleMessage("This file already exists"),
    "FileJsonExtension" : MessageLookupByLibrary.simpleMessage("json"),
    "Filename" : MessageLookupByLibrary.simpleMessage("Filename"),
    "FilenameMaxLength" : m5,
    "FilenameWhitespace" : MessageLookupByLibrary.simpleMessage("A filename can\'t be blank"),
    "Filter" : MessageLookupByLibrary.simpleMessage("Filter"),
    "FirstNameBlank" : MessageLookupByLibrary.simpleMessage("First Name can\'t be blank"),
    "FirstNameIllegalCharacters" : MessageLookupByLibrary.simpleMessage("First Name can only contain letters, spaces or \' -"),
    "FirstNameMaxLength" : m6,
    "FridayPrefix" : MessageLookupByLibrary.simpleMessage("Fri"),
    "GenericError" : MessageLookupByLibrary.simpleMessage("Something went wrong"),
    "GoBack" : MessageLookupByLibrary.simpleMessage("Go Back"),
    "ImportMembersCsvHeaderExample" : MessageLookupByLibrary.simpleMessage("firstname,surname,alias,devices"),
    "ImportMembersCsvHeaderExampleDescription" : MessageLookupByLibrary.simpleMessage("A csv header might look like:"),
    "ImportMembersCsvHeaderRegex" : MessageLookupByLibrary.simpleMessage("(firstname),(surname|familyname|lastname),(alias|nickname),(active),(devices)(.*)"),
    "ImportMembersCsvHeaderRequired" : MessageLookupByLibrary.simpleMessage("A header is required for .csv files."),
    "ImportMembersImporting" : MessageLookupByLibrary.simpleMessage("Importing Riders"),
    "ImportMembersIncompatibleFileJsonContents" : MessageLookupByLibrary.simpleMessage("The chosen .json file is incompatible."),
    "ImportMembersInvalidFileExtension" : MessageLookupByLibrary.simpleMessage("Only .csv or .json files are allowed"),
    "ImportMembersPageTitle" : MessageLookupByLibrary.simpleMessage("Import Riders"),
    "ImportMembersPickFile" : MessageLookupByLibrary.simpleMessage("Choose File"),
    "ImportMembersPickFileWarning" : MessageLookupByLibrary.simpleMessage("Please choose a file to import riders"),
    "Inactive" : MessageLookupByLibrary.simpleMessage("Inactive"),
    "InvalidFilename" : MessageLookupByLibrary.simpleMessage("Invalid filename"),
    "LastNameBlank" : MessageLookupByLibrary.simpleMessage("Last Name can\'t be blank"),
    "LastNameIllegalCharacters" : MessageLookupByLibrary.simpleMessage("Last Name can only contain letters, spaces or \' -"),
    "LastNameMaxLength" : m7,
    "ListEmpty" : MessageLookupByLibrary.simpleMessage("There is nothing to show"),
    "MemberAlreadyExists" : MessageLookupByLibrary.simpleMessage("This rider already exists"),
    "MemberDeleteDialogDescription" : MessageLookupByLibrary.simpleMessage("Are you sure that you want to delete this rider?"),
    "MemberDeleteDialogTitle" : MessageLookupByLibrary.simpleMessage("Delete Rider"),
    "MemberDetailsNoDevices" : MessageLookupByLibrary.simpleMessage("This rider has no devices yet"),
    "MondayPrefix" : MessageLookupByLibrary.simpleMessage("Mon"),
    "Ok" : MessageLookupByLibrary.simpleMessage("Ok"),
    "PersonAliasLabel" : MessageLookupByLibrary.simpleMessage("Alias"),
    "PersonFirstNameLabel" : MessageLookupByLibrary.simpleMessage("First Name"),
    "PersonLastNameLabel" : MessageLookupByLibrary.simpleMessage("Last Name"),
    "RideAttendeeScanningBluetoothDisabled" : MessageLookupByLibrary.simpleMessage("Scan aborted, Bluetooth is disabled"),
    "RideAttendeeScanningContinue" : MessageLookupByLibrary.simpleMessage("Proceed to next step"),
    "RideAttendeeScanningDeviceWithMultiplePossibleOwnersLabel" : m8,
    "RideAttendeeScanningGoBackToDetailPage" : MessageLookupByLibrary.simpleMessage("Return to detail page"),
    "RideAttendeeScanningGoToSettings" : MessageLookupByLibrary.simpleMessage("Go to Settings"),
    "RideAttendeeScanningManualSelectionEmptyList" : MessageLookupByLibrary.simpleMessage("There are no riders to choose from"),
    "RideAttendeeScanningNoMembers" : MessageLookupByLibrary.simpleMessage("Cannot start a scan, there are no riders"),
    "RideAttendeeScanningPermissionDenied" : MessageLookupByLibrary.simpleMessage("Scan aborted, permission was denied."),
    "RideAttendeeScanningPermissionDeniedDescription" : MessageLookupByLibrary.simpleMessage("Scanning requires permission to use your location."),
    "RideAttendeeScanningPreparingScan" : MessageLookupByLibrary.simpleMessage("Preparing Scan"),
    "RideAttendeeScanningProcessAddMembersLabel" : MessageLookupByLibrary.simpleMessage("By Hand"),
    "RideAttendeeScanningProcessScanLabel" : MessageLookupByLibrary.simpleMessage("Scan"),
    "RideAttendeeScanningRetryScan" : MessageLookupByLibrary.simpleMessage("Retry Scan"),
    "RideAttendeeScanningSkipScan" : MessageLookupByLibrary.simpleMessage("Skip Scan"),
    "RideAttendeeScanningUnresolvedOwnersListTooltip" : MessageLookupByLibrary.simpleMessage("Some scanned devices have multiple possible owners. You can select the attending owners here."),
    "RideDeleteDialogDescription" : MessageLookupByLibrary.simpleMessage("Are you sure that you want to delete this ride?"),
    "RideDeleteDialogTitle" : MessageLookupByLibrary.simpleMessage("Delete Ride"),
    "RideDetailsNoAttendees" : MessageLookupByLibrary.simpleMessage("This ride has no attendants"),
    "RiderSearchFilterInputLabel" : MessageLookupByLibrary.simpleMessage("Search riders"),
    "RiderSearchFilterNoResults" : MessageLookupByLibrary.simpleMessage("Nothing found for the specified search term"),
    "Riders" : MessageLookupByLibrary.simpleMessage("Riders"),
    "RidersListTitle" : m9,
    "Rides" : MessageLookupByLibrary.simpleMessage("Rides"),
    "SaturdayPrefix" : MessageLookupByLibrary.simpleMessage("Sat"),
    "Save" : MessageLookupByLibrary.simpleMessage("Save"),
    "SaveChanges" : MessageLookupByLibrary.simpleMessage("Save changes"),
    "Settings" : MessageLookupByLibrary.simpleMessage("Settings"),
    "SettingsLoading" : MessageLookupByLibrary.simpleMessage("Loading Settings"),
    "SettingsResetRideCalendarButtonLabel" : MessageLookupByLibrary.simpleMessage("Reset Ride Calendar"),
    "SettingsResetRideCalendarDescription" : MessageLookupByLibrary.simpleMessage("This will remove all rides. The attendances will be reset to zero."),
    "SettingsResetRideCalendarDialogConfirm" : MessageLookupByLibrary.simpleMessage("Clear"),
    "SettingsResetRideCalendarDialogDescription" : MessageLookupByLibrary.simpleMessage("Are you sure that you want to remove all the rides?"),
    "SettingsResetRideCalendarDialogTitle" : MessageLookupByLibrary.simpleMessage("Reset Calendar"),
    "SettingsResetRideCalendarErrorMessage" : MessageLookupByLibrary.simpleMessage("Could not reset the ride calendar."),
    "SettingsRiderFilterDescription" : MessageLookupByLibrary.simpleMessage("Filter riders in the rider list, based on their status"),
    "SettingsRiderFilterHeader" : MessageLookupByLibrary.simpleMessage("Rider List Filter"),
    "SettingsScanSliderHeader" : MessageLookupByLibrary.simpleMessage("Duration of a scan (in seconds)"),
    "SundayPrefix" : MessageLookupByLibrary.simpleMessage("Sun"),
    "ThursdayPrefix" : MessageLookupByLibrary.simpleMessage("Thu"),
    "TuesdayPrefix" : MessageLookupByLibrary.simpleMessage("Tue"),
    "ValueIsRequired" : m10,
    "WednesdayPrefix" : MessageLookupByLibrary.simpleMessage("Wed")
  };
}
