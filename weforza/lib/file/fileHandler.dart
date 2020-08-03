
import 'dart:convert';
import 'dart:io';

import 'package:file_picker/file_picker.dart';
import 'package:path_provider/path_provider.dart';
import 'package:weforza/model/member.dart';
import 'package:weforza/model/ride.dart';

enum FileExtension {
  JSON, CSV
}

extension ToFileTypeExtension on FileExtension {
  String toFileExtension(){
    switch(this){
      case FileExtension.JSON: return ".json";
      case FileExtension.CSV: return ".csv";
    }
    return null;
  }
}

///This class provides a contract to work with [File].
abstract class IFileHandler {

  ///Pick an image from the device gallery.
  ///Returns the [File] that was picked or null otherwise.
  Future<File> chooseProfileImageFromGallery();

  ///Load a file from the given [path].
  ///Returns the [File] if it exists, or null otherwise.
  Future<File> loadProfileImageFromDisk(String path);

  Future<File> chooseImportMemberDatasourceFile(List<String> allowedFileExtensions);

  Future<void> saveRideAndAttendeesToFile(String fileName, FileExtension extension, Ride ride, List<Member> attendees);
}

///This class is an implementation of [IFileHandler].
class FileHandler implements IFileHandler {

  @override
  Future<File> chooseProfileImageFromGallery() => FilePicker.getFile(type: FileType.image);

  @override
  Future<File> loadProfileImageFromDisk(String path) async {
    if(path == null || path.isEmpty){
      return null;
    }
    else {
      File image = File(path);
      return await image.exists() ? image : null;
    }
  }

  @override
  Future<File> chooseImportMemberDatasourceFile(List<String> allowedFileExtensions)
    => FilePicker.getFile(type: FileType.custom, allowedExtensions: allowedFileExtensions);

  @override
  Future<void> saveRideAndAttendeesToFile(String fileName, FileExtension extension, Ride ride, List<Member> attendees) async {
    String filePath;

    if(Platform.isAndroid){
      filePath = "${await getExternalStorageDirectory()}/$fileName${extension.toFileExtension()}";
    }else if(Platform.isIOS){
      filePath = "${await getApplicationDocumentsDirectory()}/$fileName${extension.toFileExtension()}";
    }else{
      throw Exception("Only Android and IOS are supported");
    }

    if(filePath == null){
      throw Exception("Could not create file path");
    }

    await _writeRideToFile(ride, attendees, File(filePath), extension);
  }

  Future<void> _writeRideToFile(Ride ride, List<Member> attendees, File file, FileExtension fileExtension) async {
    switch(fileExtension){
      case FileExtension.JSON: {
        //Ride details as JSON
        //Attendees as array of JSOn objects
        final data = {
          "details": ride.exportToJson(),
          "attendees": attendees.map((a) => a.exportToJson()).toList()
        };
        await file.writeAsString(jsonEncode(data));
      }
      break;
      case FileExtension.CSV: {
        //Ride details on single line
        //Attendee 1
        //Attendee 2
        //.....
        final buffer = StringBuffer();
        buffer.writeln(ride.exportToCsv());
        for(Member m in attendees){
          buffer.writeln(m.exportToCsv());
        }
        await file.writeAsString(buffer.toString());
      }
      break;
    }
  }

}