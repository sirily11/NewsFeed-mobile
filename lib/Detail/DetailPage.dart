import 'package:flutter/material.dart';
import 'package:flutter_markdown/flutter_markdown.dart';
import 'package:newsfeed_mobile/Database/FeedData.dart';
import 'package:newsfeed_mobile/Detail/DetailWebview.dart';
import 'package:newsfeed_mobile/models/Feed.dart';
import 'package:sliding_up_panel/sliding_up_panel.dart';
import 'package:webview_flutter/webview_flutter.dart';

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
  double baseFrontSize = 16;
  bool isOpen = false;

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

  Widget _panel() {
    return Column(
      children: <Widget>[
        SizedBox(
          height: 12.0,
        ),
        Row(
          mainAxisAlignment: MainAxisAlignment.center,
          children: <Widget>[
            Container(
              width: 40,
              height: 5,
              decoration: BoxDecoration(
                  color: Colors.grey[300],
                  borderRadius: BorderRadius.all(Radius.circular(12.0))),
            ),
          ],
        ),
        SizedBox(
          height: 14.0,
        ),
        isOpen
            ? Column(
                children: <Widget>[
                  Text(
                    "Font size",
                    style: TextStyle(fontSize: 16),
                  ),
                  Slider(
                    min: 4,
                    max: 34,
                    value: baseFrontSize,
                    label: "$baseFrontSize",
                    divisions: 10,
                    onChanged: (newValue) {
                      setState(() {
                        baseFrontSize = newValue;
                      });
                    },
                  )
                ],
              )
            : Text("Settings")
      ],
    );
  }

  @override
  Widget build(BuildContext context) {
    ThemeData theme = Theme.of(context);

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
      body: SlidingUpPanel(
        maxHeight: 200,
        minHeight: 80,
        onPanelOpened: () {
          setState(() {
            isOpen = true;
          });
        },
        onPanelClosed: () {
          setState(() {
            isOpen = false;
          });
        },
        color: theme.primaryColor,
        borderRadius: BorderRadius.only(
            topLeft: Radius.circular(18.0), topRight: Radius.circular(18.0)),
        body: Padding(
          padding: const EdgeInsets.only(bottom: 200),
          child: widget.feed.content != null
              ? Markdown(
                  key: Key("news_body"),
                  styleSheet: MarkdownStyleSheet.fromTheme(
                    theme.copyWith(
                      textTheme: theme.textTheme.copyWith(
                        title: theme.textTheme.body1
                            .copyWith(fontSize: baseFrontSize + 10),
                        headline: theme.textTheme.headline
                            .copyWith(fontSize: baseFrontSize + 10),
                        body1: theme.textTheme.body1
                            .copyWith(fontSize: baseFrontSize),
                      ),
                    ),
                  ),
                  data: widget.feed.content,
                )
              : WebView(
                  initialUrl: widget.feed.link,
                  javascriptMode: JavascriptMode.unrestricted,
                ),
        ),
        panel: _panel(),
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
