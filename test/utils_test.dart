import 'package:flutter_test/flutter_test.dart';
import 'package:newsfeed_mobile/utils/utils.dart';

void main() {
  group("Utils testing", () {
    test("Test time duration in minute", () {
      DateTime now = DateTime(2019, 6, 4, 23, 1, 1);
      DateTime after = DateTime(2019, 6, 4, 23, 1, 2);
      String results = getTime(now, after: after);
      expect(results, "0 minute ago");
    });

    test("Test time duration in minutes", () {
      DateTime now = DateTime(2019, 6, 4, 23, 1, 1);
      DateTime after = DateTime(2019, 6, 4, 23, 3, 1);
      String results = getTime(now, after: after);
      expect(results, "2 minutes ago");
    });

    test("Test time duration in hour", () {
      DateTime now = DateTime(2019, 6, 4, 20, 1, 1);
      DateTime after = DateTime(2019, 6, 4, 21, 1, 1);
      String results = getTime(now, after: after);
      expect(results, "1 hour ago");
    });

    test("Test time duration in hours", () {
      DateTime now = DateTime(2019, 6, 4, 20, 1, 1);
      DateTime after = DateTime(2019, 6, 4, 22, 1, 1);
      String results = getTime(now, after: after);
      expect(results, "2 hours ago");
    });

    test("Test time duration in day", () {
      DateTime now = DateTime(2019, 6, 4, 0, 1, 1);
      DateTime after = DateTime(2019, 6, 5, 0, 1, 1);
      String results = getTime(now, after: after);
      expect(results, "1 day ago");
    });

    test("Test time duration in days", () {
      DateTime now = DateTime(2019, 6, 4, 0, 1, 1);
      DateTime after = DateTime(2019, 6, 6, 0, 1, 1);
      String results = getTime(now, after: after);
      expect(results, "2 days ago");
    });

    test("Test time duration in year", () {
      DateTime now = DateTime(2019, 6, 4, 0, 1, 1);
      DateTime after = DateTime(2020, 6, 4, 0, 1, 1);
      String results = getTime(now, after: after);
      expect(results, "1 year ago");
    });

    test("Test time duration in years", () {
      DateTime now = DateTime(2019, 6, 4, 0, 1, 1);
      DateTime after = DateTime(2022, 6, 4, 0, 1, 1);
      String results = getTime(now, after: after);
      expect(results, "3 years ago");
    });
  });

  group("Test split highlight text", () {
    test("Simple split", () {
      var results = getHighlightText("simple <em>test</em>");
      expect(results.length, 2);
      expect(results[0].text, "simple ");
      expect(results[0].isBold, false);
      expect(results[1].text, "test");
      expect(results[1].isBold, true);
    });

    test("Simple split 2", () {
      var results = getHighlightText("<em>simple</em> test");
      expect(results.length, 2);
      expect(results[0].text, "simple");
      expect(results[0].isBold, true);
      expect(results[1].text, " test");
      expect(results[1].isBold, false);
    });

    test("Simple split 3", () {
      var results = getHighlightText("<em>simple</em> test <em>3</em>");
      expect(results.length, 3);
      expect(results[0].text, "simple");
      expect(results[0].isBold, true);
      expect(results[1].text, " test ");
      expect(results[1].isBold, false);
      expect(results[2].text, "3");
      expect(results[2].isBold, true);
    });
  });
}
