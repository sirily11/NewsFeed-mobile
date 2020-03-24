import 'package:dio/dio.dart';
import 'package:flutter/material.dart';
import 'package:flutter_test/flutter_test.dart';
import 'package:mockito/mockito.dart';
import 'package:newsfeed_mobile/Detail/DetailPage.dart';
import 'package:newsfeed_mobile/Home/HomePage.dart';
import 'package:newsfeed_mobile/Home/headline/NewsList.dart';
import 'package:newsfeed_mobile/models/DatabaseProvider.dart';
import 'package:newsfeed_mobile/models/Feed.dart';
import 'package:newsfeed_mobile/models/FeedProvider.dart';
import 'package:newsfeed_mobile/models/HomeControlProvider.dart';
import 'package:provider/provider.dart';

class MockClient extends Mock implements Dio {}

class MockDatabaseProvider extends Mock implements DatabaseProvider {}

void main() {
  group("Test home", () {
    List<Publisher> publisher = [Publisher(id: 0, name: "CNN")];
    List<Feed> feeds = [
      Feed(
          title: "News One",
          publisher: publisher[0],
          postedTime: DateTime.now(),
          keywords: ["Keyword 1", "Keyword 2"]),
      Feed(
          title: "News Two",
          publisher: publisher[0],
          postedTime: DateTime.now(),
          keywords: []),
      Feed(
        title: "News Three",
        publisher: publisher[0],
        postedTime: DateTime.now(),
        keywords: [],
      )
    ];

    testWidgets("Render News List", (tester) async {
      await tester.pumpWidget(
        MaterialApp(
          home: MultiProvider(
            providers: [
              ChangeNotifierProvider(
                create: (_) => FeedProvider(
                  client: MockClient(),
                ),
              ),
              ChangeNotifierProvider(
                create: (_) => HomeControlProvider(),
              )
            ],
            child: Material(
              child: NewsList(
                feeds: feeds,
                refetch: () {},
              ),
            ),
          ),
        ),
      );
      await tester.pump();
      await tester.pumpAndSettle(Duration(seconds: 5));
      expect(find.text("News One"), findsOneWidget);
      expect(find.text("News Two"), findsOneWidget);
      expect(find.text("News Three"), findsOneWidget);
      expect(find.text("Keyword 1"), findsOneWidget);
      expect(find.text("CNN"), findsWidgets);
    });
  });

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

      // await tester.pumpAndSettle();
      // expect(find.text("This is news"), findsOneWidget);
      // expect(find.text("2"), findsOneWidget);
    });
  });
}
