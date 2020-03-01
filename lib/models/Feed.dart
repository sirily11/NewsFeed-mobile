class User {
  String accessID;
  String username;

  User({this.accessID, this.username});
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
  List<FeedComment> feedComments;

  /// if the feed has been save to local
  bool isStar = false;
  List<String> keywords;

  Feed(
      {this.id,
      this.title,
      this.link,
      this.cover,
      this.content,
      this.sentiment,
      this.postedTime,
      this.publisher,
      this.publisher_id,
      this.keywords,
      this.feedComments});

  Feed.fromJson(Map<String, dynamic> json) {
    id = json['id'];
    title = json['title'];
    link = json['link'] ?? "";
    cover = json['cover'];
    content = json['content'];
    sentiment = json['sentiment'];
    postedTime = DateTime.parse(json['posted_time']);
    publisher_id = json['publisher'];
    publisher = Publisher.fromJson(json['news_publisher']);
    feedComments = List<FeedComment>.from(
      json["feed_comments"].map(
        (x) => FeedComment.fromJson(x),
      ),
    );

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
    data['posted_time'] = this.postedTime;
    data['publisher'] = this.publisher;
    data['keywords'] = this.keywords;
    return data;
  }
}

class Publisher {
  int id;
  String name;

  Publisher({this.id, this.name});

  Publisher.fromJson(Map<String, dynamic> json) {
    id = json['id'];
    name = json['name'];
  }

  Map<String, dynamic> toJson() {
    final Map<String, dynamic> data = new Map<String, dynamic>();
    data['id'] = this.id;
    data['name'] = this.name;
    return data;
  }
}
