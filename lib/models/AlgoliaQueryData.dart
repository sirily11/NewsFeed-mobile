import 'package:flutter/foundation.dart';

class HighlightResult {
  Content title;
  Content content;

  HighlightResult({
    this.title,
    this.content,
  });

  factory HighlightResult.fromJson(Map<String, dynamic> json) =>
      HighlightResult(
        title: Content.fromJson(json["title"]),
        content: Content.fromJson(json["content"]),
      );

  Map<String, dynamic> toJson() => {
        "title": title.toJson(),
        "content": content.toJson(),
      };
}

class Content {
  String value;
  String matchLevel;
  bool fullyHighlighted;
  List<String> matchedWords;

  Content({
    this.value,
    this.matchLevel,
    this.fullyHighlighted,
    this.matchedWords,
  });

  factory Content.fromJson(Map<String, dynamic> json) => Content(
        value: json["value"],
        matchLevel: json["matchLevel"],
        fullyHighlighted:
            json["fullyHighlighted"] == null ? null : json["fullyHighlighted"],
        matchedWords: List<String>.from(json["matchedWords"].map((x) => x)),
      );

  Map<String, dynamic> toJson() => {
        "value": value,
        "matchLevel": matchLevel,
        "fullyHighlighted": fullyHighlighted == null ? null : fullyHighlighted,
        "matchedWords": List<dynamic>.from(matchedWords.map((x) => x)),
      };
}

class HighlightText {
  String text;
  bool isBold;

  HighlightText({@required this.text, this.isBold = false});
}
