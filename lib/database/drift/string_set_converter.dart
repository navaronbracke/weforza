import 'dart:convert';

import 'package:drift/drift.dart';

/// This class is a [TypeConverter] that can convert a [Set] of [String]s to a [String].
class StringSetConverter extends TypeConverter<Set<String>, String> {
  const StringSetConverter();

  @override
  Set<String> fromSql(String fromDb) {
    if (fromDb.isEmpty) {
      return <String>{};
    }

    if (jsonDecode(fromDb) case final List<Object?> value) {
      return value.cast<String>().toSet();
    }

    return <String>{};
  }

  @override
  String toSql(Set<String> value) {
    if (value.isEmpty) {
      return '';
    }

    return jsonEncode(value.toList());
  }
}
