import 'package:flutter/material.dart';
import 'package:flutter_test/flutter_test.dart';
import 'package:newsfeed_mobile/Detail/DetailPage.dart';
import 'package:newsfeed_mobile/models/DatabaseProvider.dart';
import 'package:newsfeed_mobile/models/Feed.dart';
import 'package:newsfeed_mobile/models/FeedProvider.dart';
import 'package:provider/provider.dart';

import 'news_list_test.dart';

void main() {
  group("Detail Page", () {
    MockDatabaseProvider databaseProvider = MockDatabaseProvider();
    Publisher publisher = Publisher(id: 0, name: "CNN");

    Feed feed = Feed(
        title: "News One",
        content: "This is news",
        publisher: publisher,
        postedTime: DateTime.now(),
        keywords: [
          "Keyword 1",
          "Keyword 2"
        ],
        feedComments: [
          FeedComment(author: Author(username: "A"), comment: "Nice"),
          FeedComment(author: Author(username: "A"), comment: "Nice"),
        ]);

    testWidgets("Detail page", (tester) async {
      await tester.pumpWidget(
        MultiProvider(
          providers: [
            ChangeNotifierProvider(
              create: (_) => FeedProvider(),
            ),
            ChangeNotifierProvider<DatabaseProvider>(
              create: (_) => MockDatabaseProvider(),
            )
          ],
          child: MaterialApp(
            home: Material(
                child: DetailPage(
              isTest: true,
              feed: feed,
            )),
          ),
        ),
      );
      await tester.pump();

      expect(find.text("News One"), findsOneWidget);
      expect(find.text("2"), findsOneWidget);
    });
  });
}
