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

  static m0(device) => "Delete ${device}?";

  static m1(device) => "Could not delete ${device}";

  static m2(device) => "Found ${device}";

  static m3(maxLength) => "Device name is max. ${maxLength} characters";

  static m4(maxLength) => "An address can\'t be longer than ${maxLength} characters";

  static m5(maxDistance) => "A ride cannot have a distance that exceeds ${maxDistance} Km";

  static m6(maxLength) => "A title can\'t be longer than ${maxLength} characters";

  static m7(maxLength) => "First Name can\'t be longer than ${maxLength} characters";

  static m8(maxLength) => "Last Name can\'t be longer than ${maxLength} characters";

  static m9(maxLength) => "A phone number is maximum ${maxLength} digits long";

  static m10(minLength) => "A phone number is minimum ${minLength} digits long";

  static m11(value) => "${value} is required";

  final messages = _notInlinedMessages(_notInlinedMessages);
  static _notInlinedMessages(_) => <String, Function> {
    "AddDeviceError" : MessageLookupByLibrary.simpleMessage("Could not add device"),
    "AddDeviceGenericError" : MessageLookupByLibrary.simpleMessage("Something went wrong"),
    "AddDeviceSubmit" : MessageLookupByLibrary.simpleMessage("Add Device"),
    "AddMemberError" : MessageLookupByLibrary.simpleMessage("Could not add member"),
    "AddMemberSubmit" : MessageLookupByLibrary.simpleMessage("Create New Member"),
    "AddMemberTitle" : MessageLookupByLibrary.simpleMessage("New Member"),
    "AddRideColorLegendCurrentSelection" : MessageLookupByLibrary.simpleMessage("Current Selection"),
    "AddRideColorLegendFutureRide" : MessageLookupByLibrary.simpleMessage("Future Ride"),
    "AddRideColorLegendPastDay" : MessageLookupByLibrary.simpleMessage("Past Day Without Ride"),
    "AddRideColorLegendPastRide" : MessageLookupByLibrary.simpleMessage("Past Day With Ride"),
    "AddRideEmptySelection" : MessageLookupByLibrary.simpleMessage("Please select at least one date"),
    "AddRideError" : MessageLookupByLibrary.simpleMessage("Could not add rides"),
    "AddRideLoadingFailed" : MessageLookupByLibrary.simpleMessage("Could not load Calendar"),
    "AddRideSubmit" : MessageLookupByLibrary.simpleMessage("Add Selection"),
    "AddRideTitle" : MessageLookupByLibrary.simpleMessage("New Ride"),
    "AppName" : MessageLookupByLibrary.simpleMessage("WeForza"),
    "DeleteDeviceDescription" : m0,
    "DeleteDeviceError" : m1,
    "DeviceAlreadyExists" : MessageLookupByLibrary.simpleMessage("This device already exists"),
    "DeviceFound" : m2,
    "DeviceGPS" : MessageLookupByLibrary.simpleMessage("GPS"),
    "DeviceHeadset" : MessageLookupByLibrary.simpleMessage("Headset"),
    "DeviceNameLabel" : MessageLookupByLibrary.simpleMessage("Device Name"),
    "DeviceNameMaxLength" : m3,
    "DeviceOverviewNoDevices" : MessageLookupByLibrary.simpleMessage("No Devices"),
    "DeviceOverviewTitle" : MessageLookupByLibrary.simpleMessage("Manage Devices"),
    "DevicePhone" : MessageLookupByLibrary.simpleMessage("Phone"),
    "DevicePulseMonitor" : MessageLookupByLibrary.simpleMessage("Pulse Monitor"),
    "DeviceTablet" : MessageLookupByLibrary.simpleMessage("Tablet"),
    "DeviceTypeLabel" : MessageLookupByLibrary.simpleMessage("Device Type"),
    "DeviceUnknown" : MessageLookupByLibrary.simpleMessage("Unknown"),
    "DeviceWatch" : MessageLookupByLibrary.simpleMessage("Watch"),
    "DevicesHeader" : MessageLookupByLibrary.simpleMessage("Devices"),
    "DialogCancel" : MessageLookupByLibrary.simpleMessage("Cancel"),
    "DialogDelete" : MessageLookupByLibrary.simpleMessage("Delete"),
    "DialogOk" : MessageLookupByLibrary.simpleMessage("Ok"),
    "DistanceKm" : MessageLookupByLibrary.simpleMessage("Km"),
    "EditDeviceSubmit" : MessageLookupByLibrary.simpleMessage("Edit Device"),
    "EditMemberError" : MessageLookupByLibrary.simpleMessage("Failed to save the changes"),
    "EditMemberSubmit" : MessageLookupByLibrary.simpleMessage("Save Changes"),
    "EditMemberTitle" : MessageLookupByLibrary.simpleMessage("Edit Member"),
    "EditRideAddressInvalid" : MessageLookupByLibrary.simpleMessage("An address can only contain letters, numbers, spaces and # , ; : \' & / ° . ( ) -"),
    "EditRideAddressMaxLength" : m4,
    "EditRideAddressWhitespace" : MessageLookupByLibrary.simpleMessage("An address cannot be only whitespace"),
    "EditRideDepartureLabel" : MessageLookupByLibrary.simpleMessage("Departure"),
    "EditRideDestinationLabel" : MessageLookupByLibrary.simpleMessage("Destination"),
    "EditRideDistanceInvalid" : MessageLookupByLibrary.simpleMessage("Please enter a valid distance"),
    "EditRideDistanceLabel" : MessageLookupByLibrary.simpleMessage("Distance"),
    "EditRideDistanceMaximum" : m5,
    "EditRideDistancePositive" : MessageLookupByLibrary.simpleMessage("Distance must be greater than zero"),
    "EditRidePageTitle" : MessageLookupByLibrary.simpleMessage("Edit Ride"),
    "EditRideSubmit" : MessageLookupByLibrary.simpleMessage("Save Changes"),
    "EditRideSubmitError" : MessageLookupByLibrary.simpleMessage("Failed to save the changes"),
    "EditRideTitleLabel" : MessageLookupByLibrary.simpleMessage("Title"),
    "EditRideTitleMaxLength" : m6,
    "EditRideTitleWhitespace" : MessageLookupByLibrary.simpleMessage("A title can\'t be only whitespace"),
    "FirstNameBlank" : MessageLookupByLibrary.simpleMessage("First Name can\'t be just whitespace"),
    "FirstNameIllegalCharacters" : MessageLookupByLibrary.simpleMessage("First Name can only contain letters, spaces or \' -"),
    "FirstNameMaxLength" : m7,
    "FridayPrefix" : MessageLookupByLibrary.simpleMessage("Fri"),
    "HomePageMembersTab" : MessageLookupByLibrary.simpleMessage("Members"),
    "HomePageRidesTab" : MessageLookupByLibrary.simpleMessage("Rides"),
    "HomePageSettingsTab" : MessageLookupByLibrary.simpleMessage("Settings"),
    "LastNameBlank" : MessageLookupByLibrary.simpleMessage("Last Name can\'t be just whitespace"),
    "LastNameIllegalCharacters" : MessageLookupByLibrary.simpleMessage("Last Name can only contain letters, spaces or \' -"),
    "LastNameMaxLength" : m8,
    "MemberAlreadyExists" : MessageLookupByLibrary.simpleMessage("This member already exists"),
    "MemberDeleteDialogDescription" : MessageLookupByLibrary.simpleMessage("Are you sure that you want to delete this member?"),
    "MemberDeleteDialogErrorDescription" : MessageLookupByLibrary.simpleMessage("Could not delete member"),
    "MemberDeleteDialogTitle" : MessageLookupByLibrary.simpleMessage("Delete Member"),
    "MemberDetailsLoadDevicesError" : MessageLookupByLibrary.simpleMessage("Could not load devices"),
    "MemberDetailsLoadPictureError" : MessageLookupByLibrary.simpleMessage("Could not load profile picture"),
    "MemberDetailsNoDevices" : MessageLookupByLibrary.simpleMessage("This member has no devices yet"),
    "MemberDetailsNoDevicesAddDevice" : MessageLookupByLibrary.simpleMessage("Add a device"),
    "MemberDetailsTitle" : MessageLookupByLibrary.simpleMessage("Details"),
    "MemberListAddMemberInstruction" : MessageLookupByLibrary.simpleMessage("Add members by using the menu above"),
    "MemberListLoadingFailed" : MessageLookupByLibrary.simpleMessage("Could not load members"),
    "MemberListNoItems" : MessageLookupByLibrary.simpleMessage("There are no members to display"),
    "MemberListTitle" : MessageLookupByLibrary.simpleMessage("Members"),
    "MemberPickImageError" : MessageLookupByLibrary.simpleMessage("Could not load image"),
    "MondayPrefix" : MessageLookupByLibrary.simpleMessage("Mon"),
    "PersonFirstNameLabel" : MessageLookupByLibrary.simpleMessage("First Name"),
    "PersonLastNameLabel" : MessageLookupByLibrary.simpleMessage("Last Name"),
    "PersonTelephoneLabel" : MessageLookupByLibrary.simpleMessage("Telephone"),
    "PhoneIllegalCharacters" : MessageLookupByLibrary.simpleMessage("A phone number can only contain digits"),
    "PhoneMaxLength" : m9,
    "PhoneMinLength" : m10,
    "RideAttendeeScanningBluetoothDisabled" : MessageLookupByLibrary.simpleMessage("Cannot start scanning, Bluetooth is disabled."),
    "RideAttendeeScanningGenericError" : MessageLookupByLibrary.simpleMessage("Something went wrong."),
    "RideAttendeeScanningGoBack" : MessageLookupByLibrary.simpleMessage("Return to detail page"),
    "RideAttendeeScanningGoToBluetoothSettings" : MessageLookupByLibrary.simpleMessage("Go to settings"),
    "RideAttendeeScanningNoMembers" : MessageLookupByLibrary.simpleMessage("Cannot start a scan, there are no members."),
    "RideAttendeeScanningPreparingScan" : MessageLookupByLibrary.simpleMessage("Preparing Scan"),
    "RideAttendeeScanningProcessAddMembersLabel" : MessageLookupByLibrary.simpleMessage("Add Members"),
    "RideAttendeeScanningProcessScanLabel" : MessageLookupByLibrary.simpleMessage("Scan"),
    "RideAttendeeScanningRetryScan" : MessageLookupByLibrary.simpleMessage("Retry Scan"),
    "RideAttendeeScanningSaveManualResults" : MessageLookupByLibrary.simpleMessage("Save Selection"),
    "RideAttendeeScanningSaveScanResults" : MessageLookupByLibrary.simpleMessage("Save Scan Results"),
    "RideAttendeeScanningSkipScan" : MessageLookupByLibrary.simpleMessage("Skip Scan"),
    "RideDeleteDialogDescription" : MessageLookupByLibrary.simpleMessage("Are you sure that you want to delete this ride?"),
    "RideDeleteDialogErrorDescription" : MessageLookupByLibrary.simpleMessage("Could not delete ride"),
    "RideDeleteDialogTitle" : MessageLookupByLibrary.simpleMessage("Delete Ride"),
    "RideDestination" : MessageLookupByLibrary.simpleMessage("Destination"),
    "RideDetailsLoadAttendeesError" : MessageLookupByLibrary.simpleMessage("Could not load attendees"),
    "RideDetailsNoAttendees" : MessageLookupByLibrary.simpleMessage("This ride has no attendees"),
    "RideListAddRideInstruction" : MessageLookupByLibrary.simpleMessage("Add rides by using the menu above"),
    "RideListLoadingRidesError" : MessageLookupByLibrary.simpleMessage("Could not load rides"),
    "RideListNoRides" : MessageLookupByLibrary.simpleMessage("There are no rides"),
    "RideListRidesHeader" : MessageLookupByLibrary.simpleMessage("Rides"),
    "RideStart" : MessageLookupByLibrary.simpleMessage("Start"),
    "SaturdayPrefix" : MessageLookupByLibrary.simpleMessage("Sat"),
    "SettingsGenericError" : MessageLookupByLibrary.simpleMessage("Something went wrong"),
    "SettingsLoading" : MessageLookupByLibrary.simpleMessage("Loading Settings"),
    "SettingsLoadingError" : MessageLookupByLibrary.simpleMessage("Could not load the settings"),
    "SettingsScanSliderHeader" : MessageLookupByLibrary.simpleMessage("Duration of a scan (in seconds)"),
    "SettingsShowAllDevicesOptionDescription" : MessageLookupByLibrary.simpleMessage("Show all scanned devices, regardless if they belong to a known person or not."),
    "SettingsShowAllDevicesOptionLabel" : MessageLookupByLibrary.simpleMessage("Show All Scanned Devices"),
    "SettingsSubmitError" : MessageLookupByLibrary.simpleMessage("Could not save the settings"),
    "SettingsTitle" : MessageLookupByLibrary.simpleMessage("Settings"),
    "SundayPrefix" : MessageLookupByLibrary.simpleMessage("Sun"),
    "ThursdayPrefix" : MessageLookupByLibrary.simpleMessage("Thu"),
    "TuesdayPrefix" : MessageLookupByLibrary.simpleMessage("Tue"),
    "UnknownDate" : MessageLookupByLibrary.simpleMessage("Unknown Date"),
    "ValueIsRequired" : m11,
    "WednesdayPrefix" : MessageLookupByLibrary.simpleMessage("Wed")
  };
}
