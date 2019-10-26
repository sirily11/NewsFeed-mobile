import 'package:flutter/material.dart';
import 'package:flutter_markdown/flutter_markdown.dart';
import 'package:newsfeed_mobile/Database/FeedData.dart';
import 'package:newsfeed_mobile/Detail/DetailWebview.dart';
import 'package:newsfeed_mobile/models/Feed.dart';

class DetailPage extends StatefulWidget {
  final Feed feed;
  final MyDatabase myDatabase;

  DetailPage({@required this.feed, this.myDatabase});

  @override
  _DetailPageState createState() => _DetailPageState();
}

class _DetailPageState extends State<DetailPage> {
  bool isStar = false;
  FavoriteFeedData feedData;
  MyDatabase myDatabase;

  @override
  void initState() {
    super.initState();
    myDatabase = widget.myDatabase ?? MyDatabase();
    feedData = FavoriteFeedData(
        id: widget.feed.id,
        title: widget.feed.title,
        content: widget.feed.content,
        cover: widget.feed.cover,
        publiser: widget.feed?.publisher?.name,
        link: widget.feed.link,
        postedTime: widget.feed.postedTime,
        sentiment: widget.feed.sentiment);
    myDatabase.getFeed(feedData).then((feed) {
      setState(() {
        isStar = feed != null;
      });
    });
  }

  @override
  Widget build(BuildContext context) {
    return Scaffold(
      appBar: AppBar(
        title: Text(widget.feed.title),
        actions: <Widget>[
          IconButton(
            onPressed: () {
              Navigator.of(context).push(
                MaterialPageRoute(
                  builder: (_) => DetailWebview(
                    feed: widget.feed,
                  ),
                ),
              );
            },
            icon: Icon(Icons.open_in_browser),
          ),
          IconButton(
            key: Key("star_btn"),
            color: isStar ? Colors.yellow : null,
            onPressed: () async {
              if (isStar) {
                await myDatabase.deleteFeed(feedData);

                setState(() {
                  isStar = false;
                });
              } else {
                await myDatabase.addFeed(feedData);

                setState(() {
                  isStar = true;
                });
              }
            },
            icon: Icon(Icons.star),
          )
        ],
      ),
      body: Markdown(
        key: Key("news_body"),
        styleSheet: MarkdownStyleSheet(p: TextStyle(fontSize: 16)),
        data: widget.feed.content ?? "Parsing Error",
      ),
      floatingActionButton: widget.feed.sentiment != null
          ? Card(
              child: Padding(
                padding: const EdgeInsets.all(8.0),
                child: Text(
                  "Sentiment Result\n${widget.feed.sentiment?.toStringAsFixed(3)}",
                ),
              ),
            )
          : Container(),
    );
  }
}
