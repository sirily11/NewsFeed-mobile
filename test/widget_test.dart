import 'package:dio/dio.dart';
import 'package:flutter/material.dart';
import 'package:flutter_test/flutter_test.dart';
import 'package:mockito/mockito.dart';
import 'package:newsfeed_mobile/Database/FeedData.dart';
import 'package:newsfeed_mobile/Detail/DetailPage.dart';
import 'package:newsfeed_mobile/Home/HomePage.dart';
import 'package:newsfeed_mobile/models/Feed.dart';
import 'package:newsfeed_mobile/models/FeedProvider.dart';
import 'package:newsfeed_mobile/models/HomeControlProvider.dart';
import 'package:provider/provider.dart';

class MockClient extends Mock implements Dio {}

class MockDatabase extends Mock implements MyDatabase {}

void main() {
  group("Test home", () {
    Dio client = MockClient();

    setUpAll(() async {
      when(client.get(FeedProvider.publisherURL))
          .thenAnswer((_) async => Response<List>(data: [
                {"id": 1, "name": "游民星空"},
                {"id": 2, "name": "CNN"},
              ]));
      when(client.get(FeedProvider.baseURL)).thenAnswer(
        (_) async => Response<Map<String, dynamic>>(
          data: {
            "results": [
              {
                "id": 1,
                "title": "Title 1",
                "link": "https://a.com",
                "cover": null,
                "news_publisher": {"id": 1, "name": "游民星空"},
                "content": null,
                "sentiment": null,
                "posted_time": "2019-10-26T05:04:31.468114Z",
                "publisher": 1
              },
              {
                "id": 2,
                "title": "Title 2",
                "link": "https://a.com",
                "cover": null,
                "news_publisher": {"id": 2, "name": "CNN"},
                "content": "![]",
                "sentiment": null,
                "posted_time": "2019-10-26T05:04:31.238107Z",
                "publisher": 2
              },
              {
                "id": 3,
                "title": "Title 3",
                "link": "https://c.com",
                "cover": null,
                "news_publisher": {"id": 2, "name": "CNN"},
                "content": null,
                "sentiment": null,
                "posted_time": "2019-10-26T05:04:31.238107Z",
                "publisher": 2
              }
            ]
          },
        ),
      );
    });
    testWidgets("If fetch fail, then print error", (WidgetTester tester) async {
      FeedProvider feedProvider = FeedProvider(client: client);
      feedProvider.isError = true;
      Widget widget = MultiProvider(
        providers: [
          ChangeNotifierProvider(
            builder: (_) => feedProvider,
          ),
          ChangeNotifierProvider(
            builder: (_) => HomeControlProvider(),
          )
        ],
        child: MaterialApp(
          darkTheme: ThemeData.dark(),
          theme: ThemeData(
              primarySwatch: Colors.blue, brightness: Brightness.dark),
          home: HomePage(
            isError: true,
          ),
        ),
      );

      await tester.pumpWidget(widget);
      await tester.pumpAndSettle(Duration(milliseconds: 300));
      final refreshFinder = find.byIcon(Icons.refresh);
      expect(refreshFinder, findsOneWidget);
    });

    testWidgets("Widget should at show the tags for all publishers",
        (WidgetTester tester) async {
      FeedProvider feedProvider = FeedProvider(client: client);
      Widget widget = MultiProvider(
        providers: [
          ChangeNotifierProvider(
            builder: (_) => feedProvider,
          ),
          ChangeNotifierProvider(
            builder: (_) => HomeControlProvider(),
          )
        ],
        child: MaterialApp(
          darkTheme: ThemeData.dark(),
          theme: ThemeData(
              primarySwatch: Colors.blue, brightness: Brightness.dark),
          home: HomePage(),
        ),
      );
      await tester.pumpWidget(widget);
      await tester.pumpAndSettle(Duration(milliseconds: 200));
      var cnnTag = find.text("CNN");
      var gamerSkyTag = find.text("游民星空");
      expect(cnnTag, findsOneWidget);
      expect(gamerSkyTag, findsOneWidget);
    });
    testWidgets("If error and then refetch, should list titles",
        (WidgetTester tester) async {
      FeedProvider feedProvider = FeedProvider(client: client);
      feedProvider.isError = true;

      Widget widget = MultiProvider(
        providers: [
          ChangeNotifierProvider(
            builder: (_) => feedProvider,
          ),
          ChangeNotifierProvider(
            builder: (_) => HomeControlProvider(),
          )
        ],
        child: MaterialApp(
          darkTheme: ThemeData.dark(),
          theme: ThemeData(
              primarySwatch: Colors.blue, brightness: Brightness.dark),
          home: HomePage(
            isError: true,
          ),
        ),
      );
      await tester.pumpWidget(widget);
      await tester.pumpAndSettle(Duration(milliseconds: 300));
      await tester.tap(find.byIcon(Icons.refresh));
      await tester.pump();
      await tester.pumpAndSettle();
      var title1 = find.text("Title 1");
      expect(find.byIcon(Icons.refresh), findsNothing);
      expect(title1, findsOneWidget);
    });

    testWidgets("When click on star, should show star list page",
        (WidgetTester tester) async {
      FeedProvider feedProvider = FeedProvider(client: client);

      Widget widget = MultiProvider(
        providers: [
          ChangeNotifierProvider(
            builder: (_) => feedProvider,
          ),
          ChangeNotifierProvider(
            builder: (_) => HomeControlProvider(),
          )
        ],
        child: MaterialApp(
          darkTheme: ThemeData.dark(),
          theme: ThemeData(
              primarySwatch: Colors.blue, brightness: Brightness.dark),
          home: HomePage(),
        ),
      );
      await tester.pumpWidget(widget);
      await tester.pumpAndSettle(Duration(milliseconds: 300));
      expect(find.text("Title 1"), findsOneWidget);
      await tester.tap(find.byIcon(Icons.star));
      await tester.pump();
      expect(find.byKey(Key("star-list")), findsOneWidget);
    });
  });

  group("Test markdown", () {
    Feed feed;
    MyDatabase myDatabase = MockDatabase();

    setUpAll(() {
      feed = Feed(
          title: "Hello",
          content: "#Hello",
          link: "http://a",
          postedTime: DateTime.now(),
          publisher: Publisher(name: "Me"),
          id: 1);
    });

    testWidgets("Test markdown detail page", (tester) async {
      when(myDatabase.getFeed(any)).thenAnswer((_) async => Future.value(null));
      Widget widget = MaterialApp(
        home: DetailPage(
          feed: feed,
          myDatabase: myDatabase,
        ),
      );

      await tester.pumpWidget(widget);
      expect(find.text("Hello"), findsOneWidget);
      await tester.tap(find.byIcon(Icons.star));
      await tester.pump();
      await tester.pumpAndSettle();

      /// when click on the star button, it should change the color
      IconButton iconButton =
          find.byKey(Key("star_btn")).evaluate().single.widget;
      expect(iconButton.color, Colors.yellow);
      await tester.tap(find.byIcon(Icons.star));
      await tester.pump();
      iconButton = find.byKey(Key("star_btn")).evaluate().single.widget;
      expect(iconButton.color, null);
    });

    testWidgets("Test a post if has a local version", (tester) async {
      when(myDatabase.getFeed(any)).thenAnswer(
        (_) async => Future.value(
          FavoriteFeedData(
              id: 1,
              title: "a",
              postedTime: DateTime.now(),
              publiser: "a",
              content: "",
              link: ""),
        ),
      );
      Widget widget = MaterialApp(
        home: DetailPage(
          feed: feed,
          myDatabase: myDatabase,
        ),
      );
      await tester.pumpWidget(widget);
      await tester.pumpAndSettle();
      IconButton iconButton =
          find.byKey(Key("star_btn")).evaluate().single.widget;
      expect(iconButton.color, Colors.yellow);

      await tester.tap(find.byIcon(Icons.star));
      await tester.pump();
      iconButton = find.byKey(Key("star_btn")).evaluate().single.widget;
      expect(iconButton.color, null);
    });
  });
}
