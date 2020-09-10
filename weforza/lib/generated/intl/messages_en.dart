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

  static m0(buildNumber) => "Build Number: ${buildNumber}";

  static m1(version) => "Version: ${version}";

  static m2(maxLength) => "Device name is max. ${maxLength} characters";

  static m3(maxLength) => "An address can\'t be longer than ${maxLength} characters";

  static m4(maxDistance) => "A ride cannot have a distance that exceeds ${maxDistance} Km";

  static m5(maxLength) => "A title can\'t be longer than ${maxLength} characters";

  static m6(path) => "Ride saved at ${path}";

  static m7(date) => "ride_${date}";

  static m8(maxLength) => "A filename can\'t be longer than ${maxLength} characters";

  static m9(maxLength) => "First Name can\'t be longer than ${maxLength} characters";

  static m10(maxLength) => "Last Name can\'t be longer than ${maxLength} characters";

  static m11(maxLength) => "A phone number is maximum ${maxLength} digits long";

  static m12(minLength) => "A phone number is minimum ${minLength} digits long";

  static m13(value) => "${value} is required";

  final messages = _notInlinedMessages(_notInlinedMessages);
  static _notInlinedMessages(_) => <String, Function> {
    "AddDeviceError" : MessageLookupByLibrary.simpleMessage("Could not add device"),
    "AddDeviceSubmit" : MessageLookupByLibrary.simpleMessage("Create Device"),
    "AddDeviceTitle" : MessageLookupByLibrary.simpleMessage("Add Device"),
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
    "AppVersionBuildNumber" : m0,
    "AppVersionNumber" : m1,
    "DeleteDeviceDescription" : MessageLookupByLibrary.simpleMessage("Are you sure you want to delete this device?"),
    "DeleteDeviceErrorDescription" : MessageLookupByLibrary.simpleMessage("Could not delete the device"),
    "DeleteDeviceTitle" : MessageLookupByLibrary.simpleMessage("Delete Device"),
    "DeviceAlreadyExists" : MessageLookupByLibrary.simpleMessage("This device already exists"),
    "DeviceCadenceMeter" : MessageLookupByLibrary.simpleMessage("Cadence meter"),
    "DeviceGPS" : MessageLookupByLibrary.simpleMessage("GPS"),
    "DeviceHeadset" : MessageLookupByLibrary.simpleMessage("Headset"),
    "DeviceNameBlank" : MessageLookupByLibrary.simpleMessage("A device name can\'t be empty"),
    "DeviceNameCannotContainComma" : MessageLookupByLibrary.simpleMessage("A device name cannot contain a ,"),
    "DeviceNameLabel" : MessageLookupByLibrary.simpleMessage("Device Name"),
    "DeviceNameMaxLength" : m2,
    "DevicePhone" : MessageLookupByLibrary.simpleMessage("Phone"),
    "DevicePowerMeter" : MessageLookupByLibrary.simpleMessage("Power meter"),
    "DevicePulseMonitor" : MessageLookupByLibrary.simpleMessage("Pulse Monitor"),
    "DeviceUnknown" : MessageLookupByLibrary.simpleMessage("Unknown"),
    "DeviceWatch" : MessageLookupByLibrary.simpleMessage("Watch"),
    "DevicesListHeader" : MessageLookupByLibrary.simpleMessage("Devices"),
    "DevicesListNoDevices" : MessageLookupByLibrary.simpleMessage("No devices to show"),
    "DialogCancel" : MessageLookupByLibrary.simpleMessage("Cancel"),
    "DialogDelete" : MessageLookupByLibrary.simpleMessage("Delete"),
    "DialogDismiss" : MessageLookupByLibrary.simpleMessage("Ok"),
    "DistanceKm" : MessageLookupByLibrary.simpleMessage("Km"),
    "EditDeviceError" : MessageLookupByLibrary.simpleMessage("Could not edit device"),
    "EditDeviceSubmit" : MessageLookupByLibrary.simpleMessage("Save Changes"),
    "EditDeviceTitle" : MessageLookupByLibrary.simpleMessage("Edit Device"),
    "EditMemberError" : MessageLookupByLibrary.simpleMessage("Failed to save the changes"),
    "EditMemberSubmit" : MessageLookupByLibrary.simpleMessage("Save Changes"),
    "EditMemberTitle" : MessageLookupByLibrary.simpleMessage("Edit Member"),
    "EditRideAddressInvalid" : MessageLookupByLibrary.simpleMessage("An address can only contain letters, numbers, spaces and # , ; : \' & / ° . ( ) -"),
    "EditRideAddressMaxLength" : m3,
    "EditRideAddressWhitespace" : MessageLookupByLibrary.simpleMessage("An address can\'t be blank"),
    "EditRideDepartureLabel" : MessageLookupByLibrary.simpleMessage("Departure"),
    "EditRideDestinationLabel" : MessageLookupByLibrary.simpleMessage("Destination"),
    "EditRideDistanceInvalid" : MessageLookupByLibrary.simpleMessage("Please enter a valid distance"),
    "EditRideDistanceLabel" : MessageLookupByLibrary.simpleMessage("Distance"),
    "EditRideDistanceMaximum" : m4,
    "EditRideDistancePositive" : MessageLookupByLibrary.simpleMessage("Distance must be greater than zero"),
    "EditRidePageTitle" : MessageLookupByLibrary.simpleMessage("Edit Ride"),
    "EditRideSubmit" : MessageLookupByLibrary.simpleMessage("Save Changes"),
    "EditRideSubmitError" : MessageLookupByLibrary.simpleMessage("Failed to save the changes"),
    "EditRideTitleLabel" : MessageLookupByLibrary.simpleMessage("Title"),
    "EditRideTitleMaxLength" : m5,
    "EditRideTitleWhitespace" : MessageLookupByLibrary.simpleMessage("A title can\'t be blank"),
    "Export" : MessageLookupByLibrary.simpleMessage("Export"),
    "ExportRideExportedToPathMessage" : m6,
    "ExportRideExportingToFile" : MessageLookupByLibrary.simpleMessage("Exporting ride to file"),
    "ExportRideFileNamePlaceholder" : m7,
    "ExportRideTitle" : MessageLookupByLibrary.simpleMessage("Export Ride"),
    "ExportRidesTitle" : MessageLookupByLibrary.simpleMessage("Export Rides"),
    "ExportingRidesDescription" : MessageLookupByLibrary.simpleMessage("Exporting rides and attendees"),
    "FileCsvExtension" : MessageLookupByLibrary.simpleMessage("csv"),
    "FileExists" : MessageLookupByLibrary.simpleMessage("This file already exists"),
    "FileJsonExtension" : MessageLookupByLibrary.simpleMessage("json"),
    "Filename" : MessageLookupByLibrary.simpleMessage("Filename"),
    "FilenameMaxLength" : m8,
    "FilenameWhitespace" : MessageLookupByLibrary.simpleMessage("A filename can\'t be blank"),
    "FirstNameBlank" : MessageLookupByLibrary.simpleMessage("First Name can\'t be blank"),
    "FirstNameIllegalCharacters" : MessageLookupByLibrary.simpleMessage("First Name can only contain letters, spaces or \' -"),
    "FirstNameMaxLength" : m9,
    "FridayPrefix" : MessageLookupByLibrary.simpleMessage("Fri"),
    "GenericError" : MessageLookupByLibrary.simpleMessage("Something went wrong"),
    "GoBack" : MessageLookupByLibrary.simpleMessage("Go Back"),
    "HomePageMembersTab" : MessageLookupByLibrary.simpleMessage("Members"),
    "HomePageRidesTab" : MessageLookupByLibrary.simpleMessage("Rides"),
    "HomePageSettingsTab" : MessageLookupByLibrary.simpleMessage("Settings"),
    "ImportMembersCsvHeaderExample" : MessageLookupByLibrary.simpleMessage("firstname,surname,cellphone,devices"),
    "ImportMembersCsvHeaderExampleDescription" : MessageLookupByLibrary.simpleMessage("A csv header might look like:"),
    "ImportMembersCsvHeaderRegex" : MessageLookupByLibrary.simpleMessage("(firstname)\\,(surname|familyname|lastname),(cellphone|telephone|phone|phonenumber|mobilephone)\\,(devices)(.*)"),
    "ImportMembersHeaderStrippedMessage" : MessageLookupByLibrary.simpleMessage("If a header exists, it will be removed"),
    "ImportMembersImporting" : MessageLookupByLibrary.simpleMessage("Importing Members"),
    "ImportMembersInvalidFileFormat" : MessageLookupByLibrary.simpleMessage("Only CSV files are allowed"),
    "ImportMembersPageTitle" : MessageLookupByLibrary.simpleMessage("Import Members"),
    "ImportMembersPickFile" : MessageLookupByLibrary.simpleMessage("Choose File"),
    "ImportMembersPickFileWarning" : MessageLookupByLibrary.simpleMessage("Please choose a file to import members"),
    "InvalidFilename" : MessageLookupByLibrary.simpleMessage("Invalid filename"),
    "LastNameBlank" : MessageLookupByLibrary.simpleMessage("Last Name can\'t be blank"),
    "LastNameIllegalCharacters" : MessageLookupByLibrary.simpleMessage("Last Name can only contain letters, spaces or \' -"),
    "LastNameMaxLength" : m10,
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
    "PhoneMaxLength" : m11,
    "PhoneMinLength" : m12,
    "RideAttendeeScanningBluetoothDisabled" : MessageLookupByLibrary.simpleMessage("Scan aborted, Bluetooth is disabled"),
    "RideAttendeeScanningGoBackToDetailPage" : MessageLookupByLibrary.simpleMessage("Return to detail page"),
    "RideAttendeeScanningGoToSettings" : MessageLookupByLibrary.simpleMessage("Go to Settings"),
    "RideAttendeeScanningManualSelectionEmptyList" : MessageLookupByLibrary.simpleMessage("There are no members to choose from"),
    "RideAttendeeScanningNoMembers" : MessageLookupByLibrary.simpleMessage("Cannot start a scan, there are no members"),
    "RideAttendeeScanningPermissionDenied" : MessageLookupByLibrary.simpleMessage("Scan aborted, permission was denied"),
    "RideAttendeeScanningPermissionDescription" : MessageLookupByLibrary.simpleMessage("Scanning requires permission to use your location"),
    "RideAttendeeScanningPreparingScan" : MessageLookupByLibrary.simpleMessage("Preparing Scan"),
    "RideAttendeeScanningProcessAddMembersLabel" : MessageLookupByLibrary.simpleMessage("By Hand"),
    "RideAttendeeScanningProcessScanLabel" : MessageLookupByLibrary.simpleMessage("Scan"),
    "RideAttendeeScanningRetryScan" : MessageLookupByLibrary.simpleMessage("Retry Scan"),
    "RideAttendeeScanningSaveManualResults" : MessageLookupByLibrary.simpleMessage("Save Selection"),
    "RideAttendeeScanningSaveScanResults" : MessageLookupByLibrary.simpleMessage("Save Scan Results"),
    "RideAttendeeScanningScanResultDeviceOwnedByLabel" : MessageLookupByLibrary.simpleMessage("Owned By:"),
    "RideAttendeeScanningScanResultOwnerTelephoneLabel" : MessageLookupByLibrary.simpleMessage("tel: "),
    "RideAttendeeScanningSkipScan" : MessageLookupByLibrary.simpleMessage("Skip Scan"),
    "RideDeleteDialogDescription" : MessageLookupByLibrary.simpleMessage("Are you sure that you want to delete this ride?"),
    "RideDeleteDialogErrorDescription" : MessageLookupByLibrary.simpleMessage("Could not delete ride"),
    "RideDeleteDialogTitle" : MessageLookupByLibrary.simpleMessage("Delete Ride"),
    "RideDestination" : MessageLookupByLibrary.simpleMessage("Destination"),
    "RideDetailsDeleteOption" : MessageLookupByLibrary.simpleMessage("Delete"),
    "RideDetailsEditOption" : MessageLookupByLibrary.simpleMessage("Edit"),
    "RideDetailsExportOption" : MessageLookupByLibrary.simpleMessage("Export"),
    "RideDetailsLoadAttendeesError" : MessageLookupByLibrary.simpleMessage("Could not load attendees"),
    "RideDetailsNoAttendees" : MessageLookupByLibrary.simpleMessage("This ride has no attendees"),
    "RideListAddRideInstruction" : MessageLookupByLibrary.simpleMessage("Add rides by using the menu above"),
    "RideListLoadingRidesError" : MessageLookupByLibrary.simpleMessage("Could not load rides"),
    "RideListNoRides" : MessageLookupByLibrary.simpleMessage("There are no rides"),
    "RideListRidesHeader" : MessageLookupByLibrary.simpleMessage("Rides"),
    "RideStart" : MessageLookupByLibrary.simpleMessage("Start"),
    "SaturdayPrefix" : MessageLookupByLibrary.simpleMessage("Sat"),
    "SettingsLoading" : MessageLookupByLibrary.simpleMessage("Loading Settings"),
    "SettingsLoadingError" : MessageLookupByLibrary.simpleMessage("Could not load the settings"),
    "SettingsScanSliderHeader" : MessageLookupByLibrary.simpleMessage("Duration of a scan (in seconds)"),
    "SettingsSubmitError" : MessageLookupByLibrary.simpleMessage("Could not save the settings"),
    "SettingsTitle" : MessageLookupByLibrary.simpleMessage("Settings"),
    "SundayPrefix" : MessageLookupByLibrary.simpleMessage("Sun"),
    "ThursdayPrefix" : MessageLookupByLibrary.simpleMessage("Thu"),
    "TuesdayPrefix" : MessageLookupByLibrary.simpleMessage("Tue"),
    "UnknownDate" : MessageLookupByLibrary.simpleMessage("Unknown Date"),
    "ValueIsRequired" : m13,
    "WednesdayPrefix" : MessageLookupByLibrary.simpleMessage("Wed")
  };
}
