import 'package:flutter_riverpod/flutter_riverpod.dart';
import 'package:weforza/native_service/file_storage_delegate.dart';
import 'package:weforza/native_service/io_file_storage_delegate.dart';

/// This provider provides a [FileStorageDelegate] for managing files with the underlying file provider.
final fileStorageDelegateProvider = Provider<FileStorageDelegate>((_) => const IoFileStorageDelegate());
