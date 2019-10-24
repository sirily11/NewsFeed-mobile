import 'package:flutter_driver/flutter_driver.dart';
import 'package:test/test.dart';

void main() {
  group("app test", () {
    final newsList = find.byValueKey("news_list");
    final title = find.byValueKey("title");
    final moreText = find.byValueKey("more_text");
    final newsBody = find.byValueKey("news_body");
    final categoryTab = find.byValueKey("2");
    final settingTab = find.byValueKey("settings");
    final homeTap = find.byValueKey("news");

    FlutterDriver driver;

    setUpAll(() async {
      driver = await FlutterDriver.connect();
    });

    tearDownAll(() async {
      if (driver != null) {
        driver.close();
      }
    });

    test("Scroll the app", () async {
      expect(await driver.getText(title), "All");
      await driver.scroll(newsList, 0, -1000, Duration(milliseconds: 300));
      expect(await driver.getText(title), "All");
      await driver.tap(newsList);
    });
  });

  group("app test", () {
    final newsList = find.byValueKey("news_list");
    final title = find.byValueKey("title");
    final moreText = find.byValueKey("more_text");
    final newsBody = find.byValueKey("news_body");
    final categoryTab = find.byValueKey("1");
    final settingTab = find.byValueKey("settings");
    final homeTap = find.byValueKey("news");

    FlutterDriver driver;

    setUpAll(() async {
      driver = await FlutterDriver.connect();
    });

    tearDownAll(() async {
      if (driver != null) {
        driver.close();
      }
    });

    test("Scroll the app after select category", () async {
      await driver.tap(settingTab);
      await driver.tap(categoryTab);
      await Future.delayed(Duration(seconds: 1));
      var titleText = await driver.getText(title);
      expect(titleText != "All", true);
      await driver.scroll(newsList, 0, -1000, Duration(milliseconds: 300));
    });
  });
}
