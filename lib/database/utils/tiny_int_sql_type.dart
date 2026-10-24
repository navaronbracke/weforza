import 'package:drift/drift.dart';

/// A SQL type that is declared as `TINYINT`.
final class TinyIntSqlType implements CustomSqlType<int> {
  const new();

  @override
  String mapToSqlLiteral(int dartValue) => dartValue.toString();

  @override
  Object mapToSqlParameter(int dartValue) => dartValue;

  @override
  int read(Object fromSql) => fromSql as int;

  @override
  String sqlTypeName(GenerationContext context) => 'TINYINT';
}
