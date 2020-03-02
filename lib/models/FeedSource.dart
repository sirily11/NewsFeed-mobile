class FeedSourceData {
  int id;
  String name;
  String link;

  FeedSourceData({
    this.id,
    this.name,
    this.link,
  });

  factory FeedSourceData.fromJson(Map<String, dynamic> json) => FeedSourceData(
        id: json["id"],
        name: json["name"],
        link: json["link"],
      );

  Map<String, dynamic> toJson() => {
        "id": id,
        "name": name,
        "link": link,
      };
}
