import 'package:flutter_riverpod/flutter_riverpod.dart';
import 'package:weforza/native_service/media_permissions_delegate.dart';
import 'package:weforza/native_service/media_permissions_service.dart';

final mediaPermissionsProvider = Provider<MediaPermissionsService>((_) => const MediaPermissionsDelegate());
