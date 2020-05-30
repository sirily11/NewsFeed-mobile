import 'package:flutter/material.dart';
import 'package:flutter_test/flutter_test.dart';
import 'package:mockito/mockito.dart';
import 'package:newsfeed_mobile/Settings/NewsSourceList.dart';
import 'package:newsfeed_mobile/Settings/SettingPage.dart';
import 'package:newsfeed_mobile/models/DatabaseProvider.dart';
import 'package:newsfeed_mobile/models/FeedProvider.dart';
import 'package:newsfeed_mobile/models/FeedSource.dart';
import 'package:provider/provider.dart';

import 'news_list_test.dart';

class MockFeedProvider extends Mock implements FeedProvider {}

void main() {
  group("Settings page", () {
    testWidgets("Test news source list", (tester) async {
      DatabaseProvider databaseProvider = MockDatabaseProvider();
      FeedProvider feedProvider = MockFeedProvider();

      when(databaseProvider.getFeedSources()).thenAnswer(
        (_) => Future.value(
          [
            FeedSourceData(id: 1, link: "test", name: "Test link"),
            FeedSourceData(id: 2, link: "test1", name: "Test link 2")
          ],
        ),
      );

      when(databaseProvider.getSelectedFeedSourceId()).thenAnswer(
        (_) => Future.value(1),
      );

      await tester.pumpWidget(
        MaterialApp(
          home: Material(
            child: NewsSourceList(
              databaseProvider: databaseProvider,
              feedProvider: feedProvider,
            ),
          ),
        ),
      );
      await tester.pump();
      expect(find.text("Test link"), findsOneWidget);
      expect(find.text("Test link 2"), findsOneWidget);
    });
  });
}
