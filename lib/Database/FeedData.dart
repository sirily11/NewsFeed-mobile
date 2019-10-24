import 'package:moor_flutter/moor_flutter.dart';

part "feed.g.dart";

class FavoriteFeed extends Table {
  IntColumn get id => integer().autoIncrement()();
  TextColumn get title => text()();
  TextColumn get link => text()();

  TextColumn get cover => text()();
  TextColumn get content => text()();
  RealColumn get sentiment => real()();
  DateTimeColumn get postedTime => dateTime()();
  IntColumn get publisher => integer().nullable()();
}

@DataClassName("Publisher")
class FeedPublisher extends Table {
  IntColumn get id => integer().autoIncrement()();
  TextColumn get name => text()();
}

// this annotation tells moor to prepare a database class that uses both of the
// tables we just defined. We'll see how to use that database class in a moment.
@UseMoor(tables: [FavoriteFeed, FeedPublisher])
class MyDatabase {}
