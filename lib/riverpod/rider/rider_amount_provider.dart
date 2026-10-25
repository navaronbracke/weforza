import 'package:flutter_riverpod/flutter_riverpod.dart';
import 'package:weforza/riverpod/rider/rider_list_provider.dart';

/// This provider provides the total amount of riders.
final riderAmountProvider = FutureProvider<int>(
  (ref) => ref.watch(riderListProvider.selectAsync((list) => list.length)),
);
