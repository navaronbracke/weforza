import 'package:flutter_riverpod/flutter_riverpod.dart';
import 'package:weforza/model/image/io_pick_image_delegate.dart';
import 'package:weforza/model/image/pick_image_delegate.dart';
import 'package:weforza/riverpod/file_storage_delegate_provider.dart';
import 'package:weforza/riverpod/file_system_provider.dart';
import 'package:weforza/riverpod/media_permissions_provider.dart';

final imagePickerDelegateProvider = Provider<PickImageDelegate>((ref) {
  return IoPickImageDelegate(
    fileStorageDelegate: ref.read(fileStorageDelegateProvider),
    fileSystem: ref.read(fileSystemProvider),
    mediaPermissionsDelegate: ref.read(mediaPermissionsProvider),
  );
});
