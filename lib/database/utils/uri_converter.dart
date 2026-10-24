import 'package:drift/drift.dart';

/// A [TypeConverter] for converting between [Uri] and its corresponding string representation in the database.
final class UriConverter extends TypeConverter<Uri, String> {
  const new();

  @override
  Uri fromSql(String fromDb) => Uri.parse(fromDb);

  @override
  String toSql(Uri value) => value.toString();
}
