import 'package:dio/dio.dart';
import 'package:flutter/material.dart';
import 'package:flutter/widgets.dart';
import 'package:newsfeed_mobile/models/Feed.dart';
import 'package:random_color/random_color.dart';
import 'package:share/share.dart';
import 'package:shared_preferences/shared_preferences.dart';

class FeedProvider with ChangeNotifier {
  bool _enableInfiniteScroll = false;

  static String baseURL;
  static String redirectURL;
  static String publisherURL =
      "https://qbiv28lfa0.execute-api.us-east-1.amazonaws.com/dev/news-feed/publisher/";
  String loginURL;
  String signupURL;
  String commentsURL;
  String shareURL;
  String headlineURL;

  Dio client;
  bool isLoading = false;
  String prevLink;
  String nextLink;
  String nextCommentLink;
  String nextHeadlineLink;

  int _currentSelection = 0;
  List<Feed> feeds = [];
  List<FeedComment> comments = [];
  List<Headline> headlines = [];

  List<Publisher> publishers = [Publisher(name: "All", id: -1)];
  bool isError = false;
  final ScrollController scrollController = ScrollController();
  final GlobalKey<ScaffoldState> key = GlobalKey();
  final colors = List<Color>.generate(30, (_) {
    RandomColor _randomColor = RandomColor();
    return _randomColor.randomColor(colorBrightness: ColorBrightness.dark);
  });

  User user;

  FeedProvider({Dio client, String base}) {
    // For testing. Inject dependencies
    this.client = client ?? Dio();
    if (base != null) {
      setupURL(base);
    }
    initSetting();
  }

  /// init settings
  void initSetting() async {
    SharedPreferences prefs = await SharedPreferences.getInstance();
    _enableInfiniteScroll = prefs.getBool("infinite_scroll") ?? false;
  }

  set enableInfiniteScroll(bool val) {
    _enableInfiniteScroll = val;
    SharedPreferences.getInstance().then((prefs) {
      prefs.setBool("infinite_scroll", val);
    });
    notifyListeners();
  }

  bool get enableInfiniteScroll => _enableInfiniteScroll;

  Future sendComment(Feed feed, String comment) async {
    try {
      isLoading = true;
      notifyListeners();

      Response<Map<String, dynamic>> response = await client.post(
        commentsURL,
        data: {"comment": comment, "feed": feed.id},
        options: Options(headers: {"Authorization": "Bearer ${user.accessID}"}),
      );
      FeedComment newComment = FeedComment.fromJson(response.data);
      feed.feedComments.add(newComment);
    } catch (err) {
      print(err);
    } finally {
      isLoading = false;
      notifyListeners();
    }
  }

  Future deleteComment(FeedComment comment) async {
    try {
      isLoading = true;
      notifyListeners();
      var response = await client.delete(
        "$commentsURL${comment.id}/",
        options: Options(headers: {"Authorization": "Bearer ${user.accessID}"}),
      );
      this.comments.removeWhere((element) => element.id == comment.id);
    } catch (err) {
      print(err);
    } finally {
      isLoading = false;
      notifyListeners();
    }
  }

  Future login({Map<String, dynamic> data}) async {
    isLoading = true;
    notifyListeners();

    try {
      var prefs = await SharedPreferences.getInstance();
      String username = prefs.getString("username");
      String password = prefs.getString('password');

      if (data != null) {
        var res = await this.client.post(loginURL, data: data);
        user = User(accessID: res.data['access']);
        await prefs.setString("username", data['username']);
        await prefs.setString("password", data['password']);
      } else {
        if (username != null && password != null) {
          var res = await this.client.post(loginURL, data: {
            "username": username,
            "password": password,
          });
          user = User(accessID: res.data['access']);
        }
      }
    } catch (err) {
      rethrow;
    } finally {
      isLoading = false;
      notifyListeners();
    }
  }

  Future signUp(Map<String, dynamic> data, BuildContext context) async {
    isLoading = true;
    try {
      var res = await this.client.post(signupURL, data: data);
      await this.login(data: data);
    } on DioError catch (err) {
      String errMsg = "";
      if (err.response.data is Map) {
        (err.response.data as Map).forEach((key, value) {
          String msg = "";
          value.forEach((v) => msg += "- $v \n");

          errMsg += "$key:\n$msg\n";
        });
      } else {
        errMsg = err.response.toString();
      }

      showDialog(
        context: context,
        builder: (c) => AlertDialog(
          title: Text("Sign Up Error"),
          content: Text("$errMsg"),
          actions: <Widget>[
            FlatButton(
              child: Text("ok"),
              onPressed: () {
                Navigator.pop(context);
              },
            )
          ],
        ),
      );
      print(err);
    } finally {
      isLoading = false;
    }
  }

  Future logout() async {
    var prefs = await SharedPreferences.getInstance();
    await prefs.remove("username");
    await prefs.remove("password");
    user = null;
    comments = [];
    notifyListeners();
  }

  /// Test url if connectable
  Future<void> test(String base) async {
    var url = "$base/news/";
    try {
      await this.client.get(url);
    } catch (err) {
      rethrow;
    }
  }

  /// Set up the url and store the data into shared preferences
  void setupURL(String base, {int key, bool shouldSet = true}) async {
    baseURL = "$base/news/";
    // Note: No back slash at the end
    redirectURL = "$base/redirect";
    publisherURL = "$base/publisher/";
    loginURL = "$base/api/token/";
    signupURL = "$base/accounts/";
    commentsURL = "$base/comment/";
    shareURL = "$base/share/";
    headlineURL = "$base/headline/";
    var prefs = await SharedPreferences.getInstance();
    if (shouldSet) {
      await prefs.setString("baseURL", base);
    }
    if (key != null) {
      await prefs.setInt("selectedFeedsourceKey", key);
    }
  }

  Future<void> share(Feed feed) async {
    String url = "$shareURL${feed.id}/";
    await Share.share('$url', subject: "News: ${feed.title}");
  }

  /// Back to the top of the list
  Future<void> backToTop() async {
    if (scrollController.hasClients) {
      await scrollController.animateTo(0,
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

  Future<void> fetchComments() async {
    try {
      isLoading = true;
      notifyListeners();

      Response<Map<String, dynamic>> response = await client.get(
        commentsURL,
        options: Options(headers: {"Authorization": "Bearer ${user.accessID}"}),
      );
      List results = response.data['results']
          .map((r) => r as Map<String, dynamic>)
          .toList();

      nextCommentLink = response.data['next'];

      comments = results.map((d) {
        FeedComment feed = FeedComment.fromJson(d);
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
  Future<void> fetchMoreComments() async {
    try {
      if (nextCommentLink == null) {
        return;
      }
      isLoading = true;
      notifyListeners();

      Response<Map<String, dynamic>> response =
          await client.get(nextCommentLink);
      List results = response.data['results']
          .map((r) => r as Map<String, dynamic>)
          .toList();
      nextCommentLink = response.data['next'];
      comments = List.from(feeds)
        ..addAll(results.map((d) => FeedComment.fromJson(d)).toList());
      isLoading = false;
      notifyListeners();
    } catch (e) {
      print(e);
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
      prevLink = null;

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

  /// Fetch previous feeds base on the category
  /// Try to fix scrolling issue
  Future<void> fetchPrevious() async {
    try {
      if (nextLink == null) {
        return;
      }
      isLoading = true;
      notifyListeners();

      Response<Map<String, dynamic>> response = await client.get(prevLink);
      List results = response.data['results']
          .map((r) => r as Map<String, dynamic>)
          .toList();
      nextLink = response.data['next'];
      prevLink = response.data['previous'];

      feeds = results.map((d) => Feed.fromJson(d)).toList();
      scrollController.jumpTo(0);

      isLoading = false;
      notifyListeners();
    } catch (e) {
      print(e);
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
      prevLink = response.data['previous'];
      if (_enableInfiniteScroll) {
        // ==== original code
        feeds = List.from(feeds)
          ..addAll(results.map((d) => Feed.fromJson(d)).toList());
        // ==== end
      } else {
        // ==== Fix scrolling issue
        feeds = results.map((d) => Feed.fromJson(d)).toList();
        scrollController.jumpTo(0);
        // ==== end fix
      }

      isLoading = false;
      notifyListeners();
    } catch (e) {
      print(e);
    }
  }

  /// Fetch headline from server
  Future<void> fetchHeadline() async {
    try {
      isLoading = true;
      notifyListeners();
      String url = headlineURL;

      Response<Map<String, dynamic>> response = await client.get(url);
      List results = response.data['results']
          .map((r) => r as Map<String, dynamic>)
          .toList();

      nextHeadlineLink = response.data['next'];

      /// get saved feeds
      headlines = results.map((d) => Headline.fromJson(d)).toList();
      isError = false;
    } catch (e) {
      print(e);
      isError = true;
    } finally {
      isLoading = false;
      notifyListeners();
    }
  }

  /// Fetch more headline
  Future<void> fetchMoreHeadline() async {
    try {
      if (nextHeadlineLink == null) {
        return;
      }
      isLoading = true;
      notifyListeners();

      Response<Map<String, dynamic>> response =
          await client.get(nextHeadlineLink);
      List results = response.data['results']
          .map((r) => r as Map<String, dynamic>)
          .toList();
      nextHeadlineLink = response.data['next'];
      headlines = List.from(headlines)
        ..addAll(results.map((d) => Headline.fromJson(d)).toList());
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
