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

  Feed(
      {this.id,
      this.title,
      this.link,
      this.cover,
      this.content,
      this.sentiment,
      this.postedTime,
      this.publisher,
      this.publisher_id});

  Feed.fromJson(Map<String, dynamic> json) {
    id = json['id'];
    title = json['title'];
    link = json['link'];
    cover = json['cover'];
    content = json['content'];
    sentiment = json['sentiment'];
    postedTime = DateTime.parse(json['posted_time']);
    publisher_id = json['publisher'];
    publisher = Publisher.fromJson(json['news_publisher']);
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
