import 'package:dio/dio.dart';
import 'package:flutter/material.dart';
import 'package:flutter_test/flutter_test.dart';
import 'package:mockito/mockito.dart';
import 'package:newsfeed_mobile/Detail/DetailPage.dart';
import 'package:newsfeed_mobile/Docs/DocsView.dart';
import 'package:newsfeed_mobile/Home/HelpCardList.dart';
import 'package:newsfeed_mobile/Home/HomePage.dart';
import 'package:newsfeed_mobile/Home/TwoColumnNewsList.dart';
import 'package:newsfeed_mobile/Home/NewsList.dart';
import 'package:newsfeed_mobile/models/DatabaseProvider.dart';
import 'package:newsfeed_mobile/models/Feed.dart';
import 'package:newsfeed_mobile/models/FeedProvider.dart';
import 'package:newsfeed_mobile/models/HomeControlProvider.dart';
import 'package:provider/provider.dart';
import 'package:shared_preferences/shared_preferences.dart';

class MockClient extends Mock implements Dio {}

class MockDatabaseProvider extends Mock implements DatabaseProvider {}

class MockSharedPreferences extends Mock implements SharedPreferences {}

class MockNavigatorObserver extends Mock implements NavigatorObserver {}

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
      expect(find.text("Keyword 1"), findsOneWidget);
      expect(find.text("CNN"), findsWidgets);
    });

    testWidgets("Render News List without image", (tester) async {
      HomeControlProvider homeControlProvider = HomeControlProvider();
      homeControlProvider.enableImage = false;

      List<Feed> imageFeed = [
        Feed(
          cover:
              "https://www.google.com/images/branding/googlelogo/1x/googlelogo_color_272x92dp.png",
          title: "Title 1",
          publisher: publisher[0],
          description: "Hello",
          postedTime: DateTime.now(),
          keywords: [],
        ),
        Feed(
          cover:
              "https://www.google.com/images/branding/googlelogo/1x/googlelogo_color_272x92dp.png",
          title: "Title 2",
          publisher: publisher[0],
          postedTime: DateTime.now(),
          keywords: ["a"],
        ),
      ];

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
                create: (_) => homeControlProvider,
              ),
            ],
            child: Material(
              child: NewsList(
                feeds: imageFeed,
                refetch: () {},
              ),
            ),
          ),
        ),
      );

      expect(find.byKey(Key("feed-image")), findsNothing);
      expect(find.byKey(Key("feed-publisher")), findsWidgets);
      // find keyword
      expect(find.text("a"), findsOneWidget);
    });

    /// Enable image but no cover url sets
    testWidgets("Render News List without image", (tester) async {
      HomeControlProvider homeControlProvider = HomeControlProvider();
      homeControlProvider.enableImage = true;

      List<Feed> imageFeed = [
        Feed(
          title: "Title 1",
          publisher: publisher[0],
          description: "Hello",
          postedTime: DateTime.now(),
          keywords: [],
        ),
        Feed(
          title: "Title 2",
          publisher: publisher[0],
          postedTime: DateTime.now(),
          keywords: ["a"],
        ),
      ];

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
                create: (_) => homeControlProvider,
              ),
            ],
            child: Material(
              child: NewsList(
                feeds: imageFeed,
                refetch: () {},
              ),
            ),
          ),
        ),
      );

      expect(find.byKey(Key("feed-image")), findsNothing);
      expect(find.byKey(Key("feed-publisher")), findsWidgets);
      // find keyword
      expect(find.text("a"), findsOneWidget);
    });

    testWidgets("Render News List with image", (tester) async {
      HomeControlProvider homeControlProvider = HomeControlProvider();
      homeControlProvider.enableImage = true;

      List<Feed> imageFeed = [
        Feed(
          cover:
              "https://www.google.com/images/branding/googlelogo/1x/googlelogo_color_272x92dp.png",
          title: "Title 1",
          publisher: publisher[0],
          description: "Hello",
          postedTime: DateTime.now(),
          keywords: [],
        ),
        Feed(
          cover:
              "https://www.google.com/images/branding/googlelogo/1x/googlelogo_color_272x92dp.png",
          title: "Title 2",
          publisher: publisher[0],
          postedTime: DateTime.now(),
          keywords: ["a"],
        ),
      ];

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
                create: (_) => homeControlProvider,
              ),
            ],
            child: Material(
              child: NewsList(
                feeds: imageFeed,
                refetch: () {},
              ),
            ),
          ),
        ),
      );

      expect(find.byKey(Key("feed-image")), findsWidgets);
      expect(find.byKey(Key("feed-publisher")), findsNothing);
      expect(find.byKey(Key("small-feed-publisher")), findsWidgets);
      // find keyword
      expect(find.text("a"), findsOneWidget);
    });

    testWidgets("Render News List with error", (tester) async {
      var feedProvider = FeedProvider(
        client: MockClient(),
      );

      feedProvider.isError = true;

      List<Feed> imageFeed = [
        Feed(
          cover:
              "https://www.google.com/images/branding/googlelogo/1x/googlelogo_color_272x92dp.png",
          title: "Title 1",
          publisher: publisher[0],
          description: "Hello",
          postedTime: DateTime.now(),
          keywords: [],
        ),
        Feed(
          cover:
              "https://www.google.com/images/branding/googlelogo/1x/googlelogo_color_272x92dp.png",
          title: "Title 2",
          publisher: publisher[0],
          postedTime: DateTime.now(),
          keywords: ["a"],
        ),
      ];

      await tester.pumpWidget(
        MaterialApp(
          home: MultiProvider(
            providers: [
              ChangeNotifierProvider(
                create: (_) => feedProvider,
              ),
              ChangeNotifierProvider(
                create: (_) => HomeControlProvider(),
              ),
            ],
            child: Material(
              child: NewsList(
                feeds: imageFeed,
                refetch: () {},
              ),
            ),
          ),
        ),
      );
      expect(find.byKey(Key("error-refresh")), findsOneWidget);
    });

    testWidgets("Render News List with error", (tester) async {
      final mockObserver = MockNavigatorObserver();
      await tester.pumpWidget(
        MaterialApp(
          navigatorObservers: [mockObserver],
          home: Material(
            child: HelpCardList(),
          ),
        ),
      );
      verify(mockObserver.didPush(any, any));
      expect(find.byKey(Key("hello_card")), findsOneWidget);

      await tester.tap(find.byType(FlatButton));
      await tester.pumpAndSettle();

      expect(find.byType(DocView), findsOneWidget);
    });
  });

  group("Two Column List", () {
    Dio client = MockClient();
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

    testWidgets("fetch feed test", (tester) async {
      FeedProvider feedProvider = FeedProvider(
        client: client,
        preferences: MockSharedPreferences(),
      );

      feedProvider.feeds = feeds;
      feedProvider.publishers = publisher;

      await tester.pumpWidget(
        MaterialApp(
          home: MultiProvider(
            providers: [
              ChangeNotifierProvider(
                create: (_) => feedProvider,
              ),
            ],
            child: Material(
              child: TwoColumnNewsList(
                feeds: feeds,
                refetch: () {},
              ),
            ),
          ),
        ),
      );
      await tester.pump();
      await tester.pumpAndSettle(Duration(seconds: 2));
      expect(find.text("News One"), findsOneWidget);
      expect(find.text("News Two"), findsOneWidget);
      expect(find.text("News Three"), findsOneWidget);
    });
  });
}
