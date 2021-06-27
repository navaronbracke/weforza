
import 'package:flutter_driver/flutter_driver.dart';
import 'package:test/test.dart';

void main(){
  group("We Forza App", (){
    late FlutterDriver driver;

    // Connect to the Flutter driver before running any tests.
    setUpAll(() async {
      driver = await FlutterDriver.connect();
    });

    // Close the connection to the driver after the tests have completed.
    tearDownAll(() async {
      await driver.close();
    });

    //group()
    //  test1, test2,...
  });
}