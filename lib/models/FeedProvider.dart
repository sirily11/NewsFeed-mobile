import 'package:dio/dio.dart';
import 'package:flutter/material.dart';
import 'package:flutter/widgets.dart';
import 'package:newsfeed_mobile/models/Feed.dart';

class FeedProvider with ChangeNotifier {
  static const baseURL =
      "https://toebpt5v9j.execute-api.us-east-1.amazonaws.com/dev/news-feed/news/";
  static const publisherURL =
      "https://toebpt5v9j.execute-api.us-east-1.amazonaws.com/dev/news-feed/publisher/";
  Dio client;
  bool isLoading = false;
  String nextLink;
  int _currentSelection = 0;
  List<Feed> feeds = [];
  List<Publisher> publishers = [Publisher(name: "All", id: -1)];
  final ScrollController scrollController = ScrollController();
  final GlobalKey<ScaffoldState> key = GlobalKey();

  FeedProvider({Dio client}) {
    if (client == null) {
      this.client = Dio();
    } else {
      this.client = client;
    }

    this.fetchFeeds();
    // this.fetchPublishers();

    scrollController.addListener(() async {
      if (scrollController.position.pixels ==
              scrollController.position.maxScrollExtent &&
          nextLink != null) {
        await fetchMore();
        key.currentState.showSnackBar(
          SnackBar(
            content: Text("Loading More"),
            duration: Duration(milliseconds: 400),
          ),
        );
      }
    });
  }

  void backToTop() {
    scrollController.animateTo(0,
        duration: Duration(
          milliseconds: 300,
        ),
        curve: Curves.easeInOut);
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
      feeds = results.map((d) => Feed.fromJson(d)).toList();
      isLoading = false;
      notifyListeners();
    } catch (e) {
      print(e);
    }
  }

  /// Fetch more feeds base on the category
  Future<void> fetchMore() async {
    try {
      String url = nextLink ?? baseURL;
      isLoading = true;
      notifyListeners();

      Response<Map<String, dynamic>> response = await client.get(url);
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

  Future setCurrentSelectionIndex(int selection) async {
    this._currentSelection = selection;
    notifyListeners();
    await this.fetchFeeds();
  }

  int get currentSelectionIndex => this._currentSelection;
}
