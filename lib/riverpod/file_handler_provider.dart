import 'package:flutter_riverpod/flutter_riverpod.dart';
import 'package:weforza/file/file_handler.dart';

/// This provider provides the file handler.
final fileHandlerProvider = Provider<FileHandler>((_) => IoFileHandler());
