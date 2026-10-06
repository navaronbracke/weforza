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
    final result = await FilePicker.pickFile(type: FileType.custom, allowedExtensions: <String>['csv', 'json']);

    if (result == null) {
      return null;
    }

    final extension = result.extension;

    if (extension == null || (!extension.endsWith('csv') && !extension.endsWith('json'))) {
      throw UnsupportedFileFormatException();
    }

    final filePath = result.path;

    if (filePath == null) {
      throw UnsupportedFileFormatException();
    }

    return fileSystem.file(filePath);
  }
}
