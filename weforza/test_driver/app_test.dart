import 'package:flutter_driver/flutter_driver.dart';
import 'package:test/test.dart';

void main(){
  group("We Forza App", (){
    FlutterDriver driver;

    // Connect to the Flutter driver before running any tests.
    setUpAll(() async {
      driver = await FlutterDriver.connect();
    });

    // Close the connection to the driver after the tests have completed.
    tearDownAll(() async {
      if (driver != null) {
        driver.close();
      }
    });

    group("HomePage", (){

      test("Layout", () async{

        //Find the title
        await driver.waitFor(find.text('WeForza'));

        //Find button 1 and 2
        await driver.waitFor(find.text('Event Catalog'));
        await driver.waitFor(find.text('People Catalog'));
      });

      test("Navigate to PersonList", () async {
        //Find button
        await driver.waitFor(find.text('People Catalog'));
        //Tap
        await driver.tap(find.text('People Catalog'));
        //wait for list page with title
        await driver.waitFor(find.text('People Catalog'));
      });

      //navigate to events
    });


  });
}