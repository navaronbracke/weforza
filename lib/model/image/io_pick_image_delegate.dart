import 'package:file/file.dart' as fs;
import 'package:image_picker/image_picker.dart';
import 'package:path/path.dart';
import 'package:weforza/file/file_system.dart';
import 'package:weforza/model/image/pick_image_delegate.dart';

/// The [FileSystem] based implementation of [PickImageDelegate].
class IoPickImageDelegate implements PickImageDelegate {
  IoPickImageDelegate({required this.fileSystem});

  final FileSystem fileSystem;

  @override
  Future<fs.File?> pickProfileImage(ImageSource source) async {
    // TODO: refactor this flow
    // - if scoped storage on Android, register the photo (the registration should return a readable path)
    // - if not scoped storage on Android
    //   - request write external storage permission first
    //   - then save the image to the top-level pictures dir
    //   - then register the photo
    // - on iOS
    //   - request permission for the photo gallery (add only)
    //   - save the image to the application documents dir
    //   - register the photo

    final profileImage = await ImagePicker().pickImage(
      maxHeight: 320,
      maxWidth: 320,
      requestFullMetadata: false,
      source: source,
    );

    if (profileImage == null) {
      return null;
    }

    switch (source) {
      case ImageSource.camera:
        final fs.Directory? directory = fileSystem.topLevelImagesDirectory;

        if (directory == null) {
          throw ArgumentError.notNull('directory');
        }

        final fs.File destinationFile = fileSystem.file(join(directory.path, profileImage.name));

        await profileImage.saveTo(destinationFile.path);

        return destinationFile;
      case ImageSource.gallery:
        return fileSystem.file(profileImage.path);
    }
  }
}
