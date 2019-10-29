
import 'dart:io';

///This class will load files for the app.
abstract class FileLoader {

  ///Load an image from the given path.
  ///If there is no file at the given path or path is empty, null is returned.
  static Future<File> getImage(String path) async {
    if(path == null || path.isEmpty) return Future.value(null);
    else {
      File image = File(path);
      return await image.exists() ? image : null;
    }
  }
}