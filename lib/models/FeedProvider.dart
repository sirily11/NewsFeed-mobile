import 'dart:convert';

import 'package:algolia/algolia.dart';
import 'package:dio/dio.dart';
import 'package:flutter/material.dart';
import 'package:flutter/widgets.dart';
import 'package:newsfeed_mobile/Database/FeedData.dart';
import 'package:newsfeed_mobile/models/Feed.dart';
import 'package:random_color/random_color.dart';
import 'package:flutter/services.dart' show rootBundle;
import 'package:shared_preferences/shared_preferences.dart';

class FeedProvider with ChangeNotifier {
  static String baseURL;
  static String redirectURL =
      "https://812h5181yb.execute-api.us-east-1.amazonaws.com/dev/news-feed/redirect";
  static String publisherURL =
      "https://qbiv28lfa0.execute-api.us-east-1.amazonaws.com/dev/news-feed/publisher/";
  Algolia algolia;
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
  final colors = List<Color>.generate(30, (_) {
    RandomColor _randomColor = RandomColor();
    return _randomColor.randomColor(colorBrightness: ColorBrightness.dark);
  });

  FeedProvider(
      {Dio client, MyDatabase database, Algolia algolia, String base}) {
    // For testing. Inject dependencies
    this.client = client ?? Dio();
    // alglolia
    if (algolia == null) {
      rootBundle.loadString("assets/key.json").then((data) {
        var jsondata = json.decode(data);
        this.algolia = Algolia.init(
            applicationId: jsondata['appId'], apiKey: jsondata['apiKey']);
      });
    } else {
      this.algolia = algolia;
    }

    if (base != null) {
      setupURL(base);
    }

    // fetch more listener
    // scrollController.addListener(() async {
    //   if (scrollController.position.pixels ==
    //           scrollController.position.maxScrollExtent &&
    //       nextLink != null) {
    //     key.currentState.showSnackBar(
    //       SnackBar(
    //         content: Text("Loading More"),
    //         duration: Duration(milliseconds: 400),
    //       ),
    //     );
    //     await fetchMore();
    //   }
    // });
  }

  /// Set up the url and store the data into shared preferences
  void setupURL(String base) async {
    baseURL = "$base/news/";
    redirectURL = "$base/redirect";
    publisherURL = "$base/publisher/";
    var prefs = await SharedPreferences.getInstance();
    prefs.setString("baseURL", base);
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
      publishers = List.from([publishers[0]])
        ..addAll(response.data.map((p) => Publisher.fromJson(p)).toList());
      notifyListeners();
      return publishers;
    } catch (err) {
      print(err);
      isError = true;
      notifyListeners();
      rethrow;
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
      if (scrollController != null && scrollController.hasClients) {
        await scrollController.animateTo(0,
            duration: Duration(milliseconds: 200), curve: Curves.bounceIn);
      }
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

  /// Quick search. Using Algolia
  Future<AlgoliaQuerySnapshot> quickSearch(String keyword) async {
    AlgoliaQuery query = algolia.instance.index("news_feed").search(keyword);
    AlgoliaQuerySnapshot snap = await query.getObjects();
    return snap;
  }

  Future<Feed> redirect(String link) async {
    try {
      var url = "$redirectURL?link=$link";
      Response response = await client.get(url);
      if (response.statusCode == 200) {
        return Feed.fromJson(response.data);
      } else {
        return null;
      }
    } catch (err) {
      print(err);
      return null;
    }
  }

  int get currentSelectionIndex => this._currentSelection;

  Future<Feed> fetchFeed(int id) async {
    try {
      Response<Map<String, dynamic>> response =
          await client.get("$baseURL$id/");
      Feed feed = Feed.fromJson(response.data);
      return feed;
    } catch (err) {
      print(err);
      return null;
    }
  }
}
