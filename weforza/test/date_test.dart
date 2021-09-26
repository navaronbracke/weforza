import 'package:test/test.dart';

import 'package:weforza/extensions/date_extensions.dart';

void main(){
  group("DateTime tests", (){
    test("toStringSimple outputs correct string", (){
      final date = DateTime(2000,1,1); // 1 Jan 2000, midnight

      expect(date.toStringSimple(), "2000-01-01 00:00:00");
    });

    test("toStringSimple can be passed to DateTime.parse", (){
      final inputString = "2000-01-01 00:00:00";

      expect(() => DateTime.parse(inputString), returnsNormally);
      expect(DateTime.parse(inputString), DateTime(2000,1,1));
    });
  });
}