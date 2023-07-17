import 'package:flutter_riverpod/flutter_riverpod.dart';
import 'package:weforza/model/image/io_pick_image_delegate.dart';
import 'package:weforza/model/image/pick_image_delegate.dart';
import 'package:weforza/riverpod/file_system_provider.dart';

final imagePickerDelegateProvider = Provider<PickImageDelegate>((ref) {
  return IoPickImageDelegate(fileSystem: ref.read(fileSystemProvider));
});
