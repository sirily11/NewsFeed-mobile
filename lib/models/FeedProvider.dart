import 'package:dio/dio.dart';
import 'package:flutter/material.dart';
import 'package:flutter/widgets.dart';
import 'package:newsfeed_mobile/Database/FeedData.dart';
import 'package:newsfeed_mobile/models/Feed.dart';

class FeedProvider with ChangeNotifier {
  static const baseURL =
      "https://812h5181yb.execute-api.us-east-1.amazonaws.com/dev/news-feed/news/";
  static const publisherURL =
      "https://812h5181yb.execute-api.us-east-1.amazonaws.com/dev/news-feed/publisher/";
  Dio client;
  MyDatabase database;
  bool isLoading = false;
  String nextLink;
  int _currentSelection = 0;
  List<Feed> feeds = [];
  List<Publisher> publishers = [Publisher(name: "All", id: -1)];
  bool isError = false;
  final ScrollController scrollController = ScrollController();
  final GlobalKey<ScaffoldState> key = GlobalKey();

  FeedProvider({Dio client, MyDatabase database}) {
    // For testing. Inject dependencies
    this.client = client ?? Dio();
    // this.database = database ?? MyDatabase();

    // fetch more listener
    scrollController.addListener(() async {
      if (scrollController.position.pixels ==
              scrollController.position.maxScrollExtent &&
          nextLink != null) {
        key.currentState.showSnackBar(
          SnackBar(
            content: Text("Loading More"),
            duration: Duration(milliseconds: 400),
          ),
        );
        await fetchMore();
      }
    });
  }

  /// Back to the top of the list
  void backToTop() {
    if (scrollController.hasClients) {
      scrollController.animateTo(0,
          duration: Duration(
            milliseconds: 300,
          ),
          curve: Curves.easeInOut);
    }
  }

  /// Fetch publishers from server
  Future<List<Publisher>> fetchPublishers() async {
    try {
      Response<List> response = await client.get(publisherURL);
      publishers = List.from(publishers)
        ..addAll(response.data.map((p) => Publisher.fromJson(p)).toList());
      notifyListeners();
      return publishers;
    } catch (err) {
      print(err);
      isError = true;
      notifyListeners();
      return null;
    }
  }

  /// Fetch feeds from server. If no category selected, fetch all
  Future<void> fetchFeeds() async {
    try {
      isLoading = true;
      notifyListeners();
      String url = baseURL;
      if (_currentSelection > 0) {
        url = "$url?publisher=${publishers[_currentSelection].id}";
      }

      Response<Map<String, dynamic>> response = await client.get(url);
      List results = response.data['results']
          .map((r) => r as Map<String, dynamic>)
          .toList();

      nextLink = response.data['next'];

      /// get saved feeds

      feeds = results.map((d) {
        Feed feed = Feed.fromJson(d);

        return feed;
      }).toList();
      isError = false;
    } catch (e) {
      print(e);
      isError = true;
    } finally {
      isLoading = false;
      notifyListeners();
    }
  }

  /// Fetch more feeds base on the category
  Future<void> fetchMore() async {
    try {
      if (nextLink == null) {
        return;
      }
      isLoading = true;
      notifyListeners();

      Response<Map<String, dynamic>> response = await client.get(nextLink);
      List results = response.data['results']
          .map((r) => r as Map<String, dynamic>)
          .toList();
      nextLink = response.data['next'];
      feeds = List.from(feeds)
        ..addAll(results.map((d) => Feed.fromJson(d)).toList());
      isLoading = false;
      notifyListeners();
    } catch (e) {
      print(e);
    }
  }

  /// Search feed
  Future<List<Feed>> search(String keyword) async {
    try {
      var url = "$baseURL?search=$keyword";
      Response response = await client.get(url);
      List results = response.data['results']
          .map((r) => r as Map<String, dynamic>)
          .toList();
      return results.map((d) => Feed.fromJson(d)).toList();
    } catch (err) {
      print(err);
      return [];
    }
  }

  /// Set current category
  Future setCurrentSelectionIndex(int selection) async {
    this._currentSelection = selection;
    this.backToTop();
    notifyListeners();
    await this.fetchFeeds();
  }

  int get currentSelectionIndex => this._currentSelection;
}
