import 'package:flutter_riverpod/flutter_riverpod.dart';
import 'package:weforza/model/selected_member.dart';

/// This provider manages the selected member.
final selectedMemberProvider = StateProvider<SelectedMember?>((_) => null);
