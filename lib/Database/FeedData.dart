import 'package:moor_flutter/moor_flutter.dart';

part "FeedData.g.dart";

class FavoriteFeed extends Table {
  IntColumn get id => integer()();
  TextColumn get title => text().nullable()();
  TextColumn get link => text()();

  TextColumn get cover => text().nullable()();
  TextColumn get content => text()();
  RealColumn get sentiment => real().nullable()();
  DateTimeColumn get postedTime => dateTime()();
  TextColumn get publiser => text()();
  // IntColumn get publisher =>
  //     integer().nullable().customConstraint("NULL REFERENCES publiser(id)")();

  @override
  Set<Column> get primaryKey => {id};
}

class Publiser extends Table {
  IntColumn get id => integer().autoIncrement()();
  TextColumn get name => text()();

  @override
  Set<Column> get primaryKey => {id};
}

@UseMoor(tables: [FavoriteFeed])
class MyDatabase extends _$MyDatabase {
  MyDatabase()
      : super(FlutterQueryExecutor.inDatabaseFolder(path: "db.sqlite"));

  @override
  int get schemaVersion => 1;

  Future<List<FavoriteFeedData>> get allFavoriteFeed =>
      select(favoriteFeed).get();

  Future addFeed(FavoriteFeedData feed) {
    return into(favoriteFeed).insert(feed);
  }

  Future deleteFeed(FavoriteFeedData feed) {
    return delete(favoriteFeed).delete(feed);
  }

  Stream getFeedStream(FavoriteFeedData feed) {
    return (select(favoriteFeed)..where((f) => f.id.equals(feed.id)))
        .watchSingle();
  }

  Future<FavoriteFeedData> getFeed(FavoriteFeedData feed) {
    return (select(favoriteFeed)..where((f) => f.id.equals(feed.id)))
        .getSingle();
  }
}
