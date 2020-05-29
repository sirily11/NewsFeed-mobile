import 'dart:io';

import 'package:flutter/foundation.dart';
import 'package:flutter/material.dart';
import 'package:newsfeed_mobile/models/Feed.dart';
import 'package:newsfeed_mobile/models/FeedSource.dart';
import 'package:path_provider/path_provider.dart';
import 'package:sembast/sembast.dart';
import 'package:sembast/sembast_io.dart';
import 'package:path/path.dart' as p;
import 'package:share/share.dart';
import 'package:shared_preferences/shared_preferences.dart';

class DatabaseProvider with ChangeNotifier {
  bool hasInit = false;
  final String newsfeedDBPath = "feedDB";
  final String feedSourceDBPath = "feedSourceDB";
  Database newsFeedDB;
  Database feedSourceDB;
  SharedPreferences preferences;

  DatabaseFactory dbFactory = databaseFactoryIo;

  DatabaseProvider({SharedPreferences preferences}) {
    this.preferences = preferences;
  }

  Future<void> init() async {
    /// init provider when it is not in web
    if (!kIsWeb) {
      if (Platform.isIOS || Platform.isAndroid) {
        var dir = await getApplicationDocumentsDirectory();
        await dir.create(recursive: true);
        var path = p.join(dir.path, newsfeedDBPath);
        var path2 = p.join(dir.path, feedSourceDBPath);
        this.feedSourceDB = await dbFactory.openDatabase(path);
        this.newsFeedDB = await dbFactory.openDatabase(path2);
      } else {
        this.feedSourceDB = await dbFactory.openDatabase(newsfeedDBPath);
        this.newsFeedDB = await dbFactory.openDatabase(feedSourceDBPath);
      }
    }
    this.hasInit = true;
    notifyListeners();
  }

  Future<int> getSelectedFeedSourceId() async {
    SharedPreferences preferences =
        this.preferences ?? await SharedPreferences.getInstance();
    int id = preferences.getInt("selectedFeedsourceKey");
    return id;
  }

  /// Get feed sources
  Future<List<FeedSourceData>> getFeedSources() async {
    var store = intMapStoreFactory.store();
    final snapshots = await store.find(
      feedSourceDB,
      finder: Finder(
        sortOrders: [SortOrder('key')],
      ),
    );
    return snapshots
        .map((e) => FeedSourceData.fromJson(e.value)..id = e.key)
        .toList();
  }

  /// Get feed by id from database
  Future<Feed> getFeed(int id) async {
    var store = intMapStoreFactory.store();
    final snapshot = await store.findFirst(
      newsFeedDB,
      finder: Finder(
        filter: Filter.equals("id", id),
      ),
    );
    if (snapshot != null) {
      return Feed.fromJson(snapshot.value);
    }
    return null;
  }

  /// Get list of star feeds
  Future<List<Feed>> getListFeeds() async {
    var store = intMapStoreFactory.store();
    final snapshots = await store.find(
      newsFeedDB,
      finder: Finder(
        sortOrders: [SortOrder('key')],
      ),
    );
    return snapshots.map((e) => Feed.fromJson(e.value)).toList();
  }

  /// Add Feed to database
  Future<void> addFeedToDB(Feed feed) async {
    var store = intMapStoreFactory.store();
    int key = await store.add(newsFeedDB, feed.toJson());
    print(key);
  }

  /// Delete Feed from database
  Future<void> deleteFeedFromDB(Feed feed) async {
    var store = intMapStoreFactory.store();
    await store.delete(
      newsFeedDB,
      finder: Finder(
        filter: Filter.equals("id", feed.id),
      ),
    );
    notifyListeners();
  }

  /// Add feed source to db
  Future<void> addFeedSource(FeedSourceData sourceData) async {
    var store = intMapStoreFactory.store();
    await store.add(feedSourceDB, sourceData.toJson());
  }

  /// Delete feedsource from database
  Future<void> deleteFeedSource(FeedSourceData sourceData) async {
    var store = intMapStoreFactory.store();
    int number = await store.delete(
      feedSourceDB,
      finder: Finder(
        filter: Filter.byKey(sourceData.id),
      ),
    );
    notifyListeners();
  }
}
