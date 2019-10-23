import 'package:flutter/material.dart';
import 'package:flutter_markdown/flutter_markdown.dart';
import 'package:newsfeed_mobile/Detail/DetailWebview.dart';
import 'package:newsfeed_mobile/models/Feed.dart';

class DetailPage extends StatelessWidget {
  final Feed feed;

  DetailPage({@required this.feed});

  @override
  Widget build(BuildContext context) {
    return Scaffold(
      appBar: AppBar(
        title: Text(feed.title),
        actions: <Widget>[
          IconButton(
            onPressed: () {
              Navigator.of(context).push(
                MaterialPageRoute(
                  builder: (_) => DetailWebview(
                    feed: feed,
                  ),
                ),
              );
            },
            icon: Icon(Icons.open_in_browser),
          )
        ],
      ),
      body: Markdown(
        data: feed.content ?? "Parsing Error",
      ),
      floatingActionButton: Card(
        child: Padding(
          padding: const EdgeInsets.all(8.0),
          child: Text(
            "Sentiment Result\n${feed.sentiment?.toStringAsFixed(3)}",
          ),
        ),
      ),
    );
  }
}
