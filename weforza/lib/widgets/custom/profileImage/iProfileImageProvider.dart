
import 'dart:io';
import 'package:path/path.dart';
import 'package:path_provider/path_provider.dart';

///This class defines a contract for providing profile images.
abstract class IProfileImageProvider {

  ///Get the provided image.
  File get image;

  ///Check if a given image exists.
  Future<bool> imageExists();
}

///This class implements [IProfileImageProvider].
class ProfileImageProvider implements IProfileImageProvider {
  ProfileImageProvider(this._fileName);

  final String _fileName;

  File _image;

  @override
  File get image => _image;

  @override
  Future<bool> imageExists() async {
    if(_fileName == null || _fileName.isEmpty){
      return Future.value(false);
    }else {
      //join paths and create image
      final docsDir = await getApplicationDocumentsDirectory();
      File file = File(join(docsDir.path,_fileName));
      if(await file.exists()){
        _image = file;
        return Future.value(true);
      }
      return Future.value(false);
    }
  }

}