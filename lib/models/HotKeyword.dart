// To parse this JSON data, do
//
//     final hotKeyword = hotKeywordFromJson(jsonString);

import 'dart:convert';

HotKeyword hotKeywordFromJson(String str) =>
    HotKeyword.fromJson(json.decode(str));

String hotKeywordToJson(HotKeyword data) => json.encode(data.toJson());

class HotKeyword {
  String keyword;
  List<HotKeywordFeed> feeds;

  HotKeyword({
    this.keyword,
    this.feeds,
  });

  factory HotKeyword.fromJson(Map<String, dynamic> json) => HotKeyword(
        keyword: json["keyword"],
        feeds: List<HotKeywordFeed>.from(
            json["feeds"].map((x) => HotKeywordFeed.fromJson(x))),
      );

  Map<String, dynamic> toJson() => {
        "keyword": keyword,
        "feeds": List<dynamic>.from(feeds.map((x) => x.toJson())),
      };
}

class HotKeywordFeed {
  int id;
  String title;
  String publisherName;
  DateTime postedTime;
  String cover;

  HotKeywordFeed({
    this.id,
    this.title,
    this.publisherName,
    this.postedTime,
    this.cover,
  });

  factory HotKeywordFeed.fromJson(Map<String, dynamic> json) => HotKeywordFeed(
        id: json['id'],
        title: json["title"],
        publisherName: json["publisher__name"],
        postedTime: DateTime.parse(json["posted_time"]),
        cover: json["cover"] == null ? null : json["cover"],
      );

  Map<String, dynamic> toJson() => {
        "title": title,
        "publisher__name": publisherName,
        "posted_time": postedTime.toIso8601String(),
        "cover": cover == null ? null : cover,
      };
}
