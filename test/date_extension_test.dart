import 'package:flutter_test/flutter_test.dart';

import 'package:weforza/extensions/date_extension.dart';

void main() {
  group('date extension test', () {
    test('toStringWithoutMilliseconds - UTC', () {
      final date = DateTime.utc(1989, 11, 9, 2, 10, 59, 100);

      expect(
        date.toStringWithoutMilliseconds(),
        '1989-11-09 02:10:59',
      );
    });

    test('toStringWithoutMilliseconds - local time', () {
      final date = DateTime(1989, 11, 9, 2, 10, 59, 100);

      expect(
        date.toStringWithoutMilliseconds(),
        '1989-11-09 02:10:59',
      );
    });
  });
}
