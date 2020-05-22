class User {
  String accessID;
  String username;

  User({this.accessID, this.username});
}

class Headline {
  String title;
  String cover;
  String content;
  String shortDescription;
  DateTime publishedTime;

  Headline(
      {this.title,
      this.cover,
      this.content,
      this.publishedTime,
      this.shortDescription});

  factory Headline.fromJson(Map<String, dynamic> json) => Headline(
        title: json["title"],
        cover: json["cover"],
        content: json["content"],
        shortDescription: json['short_description'],
        publishedTime: DateTime.parse(json["published_time"]),
      );

  Map<String, dynamic> toJson() => {
        "title": title,
        "cover": cover,
        "content": content,
        "published_time": publishedTime.toIso8601String(),
        "short_description": shortDescription
      };
}

class FeedComment {
  int id;
  String comment;
  DateTime publishedTime;
  Author author;
  Feed newsFeed;
  int feed;

  FeedComment(
      {this.comment,
      this.id,
      this.publishedTime,
      this.author,
      this.feed,
      this.newsFeed});

  factory FeedComment.fromJson(Map<String, dynamic> json) => FeedComment(
        id: json['id'],
        comment: json["comment"],
        publishedTime: DateTime.parse(json["published_time"]),
        author: Author.fromJson(json["author"]),
        feed: json["feed"],
        newsFeed:
            json['news_feed'] != null ? Feed.fromJson(json['news_feed']) : null,
      );

  Map<String, dynamic> toJson() => {
        "id": id,
        "comment": comment,
        "published_time": publishedTime.toIso8601String(),
        "author": author.toJson(),
        "feed": feed,
      };
}

class Author extends User {
  String username;

  Author({
    this.username,
  });

  factory Author.fromJson(Map<String, dynamic> json) => Author(
        username: json["username"],
      );

  Map<String, dynamic> toJson() => {
        "username": username,
      };
}

class Feed {
  int id;
  String title;
  String link;
  String cover;
  String content;
  double sentiment;
  DateTime postedTime;
  Publisher publisher;
  int publisher_id;
  String description;
  List<FeedComment> feedComments;

  /// if the feed has been save to local
  bool isStar = false;
  List<String> keywords;

  Feed({
    this.id,
    this.title,
    this.link,
    this.cover,
    this.content,
    this.sentiment,
    this.postedTime,
    this.publisher,
    this.publisher_id,
    this.keywords,
    this.feedComments,
    this.description,
  });

  Feed.fromJson(Map<String, dynamic> json, {bool removeContent = false}) {
    id = json['id'];
    title = json['title'];
    link = json['link'] ?? "";
    cover = json['cover'];
    if (!removeContent) content = json['content'];
    sentiment = json['sentiment'];
    postedTime = DateTime.parse(json['posted_time']);
    publisher_id = json['publisher'];
    publisher = Publisher.fromJson(json['news_publisher']);
    description = json['description'];
    if (!removeContent)
      feedComments = json['feed_comments'] != null
          ? List<FeedComment>.from(
              json["feed_comments"].map(
                (x) => FeedComment.fromJson(x),
              ),
            )
          : null;

    if (json["keywords"] != null) {
      keywords = List<String>.from(json["keywords"].map((x) => x));
    } else {
      keywords = [];
    }
  }

  Map<String, dynamic> toJson() {
    final Map<String, dynamic> data = new Map<String, dynamic>();
    data['id'] = this.id;
    data['title'] = this.title;
    data['link'] = this.link;
    data['cover'] = this.cover;
    data['content'] = this.content;
    data['sentiment'] = this.sentiment;
    data['posted_time'] = this.postedTime.toIso8601String();
    data['news_publisher'] = this.publisher.toJson();
    data['description'] = this.description;
    data['keywords'] = this.keywords;
    data['feed_comments'] = this.feedComments.map((e) => e.toJson()).toList();
    return data;
  }
}

class Publisher {
  int id;
  String name;
  Feed headline;

  Publisher({this.id, this.name, this.headline});

  Publisher.fromJson(Map<String, dynamic> json) {
    id = json['id'];
    name = json['name'];
    headline =
        json['headline'] != null ? Feed.fromJson(json['headline']) : null;
  }

  Map<String, dynamic> toJson() {
    final Map<String, dynamic> data = new Map<String, dynamic>();
    data['id'] = this.id;
    data['name'] = this.name;
    data['headline'] = this.headline;
    return data;
  }
}
