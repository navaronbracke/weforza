import 'package:flutter_riverpod/flutter_riverpod.dart';
import 'package:weforza/native_service/file_storage_delegate.dart';
import 'package:weforza/native_service/io_file_storage_delegate.dart';

/// This provider provides a [FileStorageDelegate] for managing files with the underlying file provider.
///
/// Since the provided delegate here is constant,
/// it is the same object as the one used in the initialization at the top of `void main() {}`.
final fileStorageDelegateProvider = Provider<FileStorageDelegate>((_) => const IoFileStorageDelegate());
