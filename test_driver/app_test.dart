// Imports the Flutter Driver API.
import 'package:flutter_driver/flutter_driver.dart';
// import 'package:flutter_test/flutter_test.dart' as ft;
import 'package:test/test.dart';

void main() {
  group('News Feed', () {
    // First, define the Finders and use them to locate widgets from the
    // test suite. Note: the Strings provided to the `byValueKey` method must
    // be the same as the Strings we used for the Keys in step 1.

    FlutterDriver driver;
    final allTextFinder = find.text("All");
    final settingsFinder = find.text("Settings");
    final addSourceButton = find.text("Add source");
    final nameField = find.byValueKey("name_field");
    final urlField = find.byValueKey("url_field");
    final okBtn = find.byValueKey("ok");

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

    test("First time, hello card will be display", () async {
      await driver.waitFor(settingsFinder);
      expect(find.byValueKey("hello_card") != null, true);
    });

    test("Add source", () async {
      //https://812h5181yb.execute-api.us-east-1.amazonaws.com/dev/news-feed
      await driver.tap(settingsFinder);
      await driver.tap(addSourceButton);
      await driver.waitFor(nameField);
      await driver.tap(nameField);
      await driver.enterText("Blog");
      await driver.tap(urlField);
      await driver.enterText("https://api.sirileepage.com/blog");
      await driver.tap(find.text("Confirm"));
      await driver.waitForAbsent(find.byValueKey("progress_bar"));
      await driver.tap(okBtn);
      expect(find.text("Blog") != null, true);
    });

    test("Find all tag", () async {
      expect(allTextFinder != null, true);
      await driver.tap(find.text("News"));
      await driver.tap(find.byType("FeedRow"));
      await driver.tap(find.byValueKey("star_btn"));
      await driver.tap(find.byTooltip("Back"));
      expect(allTextFinder != null, true);
      await driver.tap(find.text("Favorite"));
      expect(find.byType("Card") != null, true);
    });
  });
}
