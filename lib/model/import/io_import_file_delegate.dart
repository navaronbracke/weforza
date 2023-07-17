import 'package:file/file.dart' as fs;
import 'package:file_picker/file_picker.dart';
import 'package:weforza/exceptions/exceptions.dart';
import 'package:weforza/file/file_system.dart';
import 'package:weforza/model/import/import_file_delegate.dart';

class IoImportFileDelegate implements ImportFileDelegate {
  IoImportFileDelegate(this.fileSystem);

  final FileSystem fileSystem;

  @override
  Future<fs.File?> pickImportRidersDataSource() async {
    final result = await FilePicker.platform.pickFiles(
      type: FileType.custom,
      allowedExtensions: <String>['csv', 'json'],
    );

    if (result == null || result.files.isEmpty) {
      return null;
    }

    final chosenFile = result.files.first;
    final ext = chosenFile.extension;

    if (ext == null || (!ext.endsWith('csv') && !ext.endsWith('json'))) {
      throw UnsupportedFileFormatException();
    }

    final filePath = chosenFile.path;

    if (filePath == null) {
      throw UnsupportedFileFormatException();
    }

    return fileSystem.file(filePath);
  }
}
