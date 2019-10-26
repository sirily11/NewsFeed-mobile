import 'package:dio/dio.dart';
import 'package:flutter_test/flutter_test.dart';
import 'package:mockito/mockito.dart';
import 'package:newsfeed_mobile/Database/FeedData.dart';
import 'package:newsfeed_mobile/models/FeedProvider.dart';

class MockClient extends Mock implements Dio {}

class MockDatabase extends Mock implements MyDatabase {}

void main() {
  group("Test Feed Provider", () {
    Dio client = MockClient();
    MyDatabase database = MockDatabase();
    FeedProvider provider;

    setUpAll(() async {
      when(database.allFavoriteFeed).thenAnswer((_) async => [
            FavoriteFeedData(
                id: 1,
                title: "Title 1",
                link: "",
                content: "",
                postedTime: DateTime.now(),
                publiser: null)
          ]);

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
      provider = FeedProvider(client: client, database: database);
    });

    test("Test fetch", () async {
      await provider.fetchFeeds();
      expect(provider.feeds.length, 3);
      expect(provider.isError, false);
      expect(provider.isLoading, false);

      /// no more
      await provider.fetchMore();
      expect(provider.feeds.length, 3);
      expect(provider.isError, false);
      expect(provider.isLoading, false);

      // has more
      provider.nextLink = FeedProvider.baseURL;
      await provider.fetchMore();
      expect(provider.feeds.length, 6);
      expect(provider.isError, false);
      expect(provider.isLoading, false);
    });

    test("If there is an error, refetch should clear the error", () async {
      provider.isError = true;
      await provider.fetchFeeds();
      expect(provider.isError, false);
    });

    test("If feed is in the database, then feed isStar should be true",
        () async {
      await provider.fetchFeeds();
      expect(provider.feeds[0].isStar, true);
      expect(provider.feeds[1].isStar, false);
      expect(provider.feeds[2].isStar, false);
    }, skip: true);
  });
}
