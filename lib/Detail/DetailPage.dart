import 'package:firebase_dynamic_links/firebase_dynamic_links.dart';
import 'package:flutter/material.dart';
import 'package:flutter_markdown/flutter_markdown.dart';
import 'package:newsfeed_mobile/Detail/DetailCommentPage.dart';
import 'package:newsfeed_mobile/Detail/DetailWebview.dart';
import 'package:newsfeed_mobile/models/Feed.dart';
import 'package:newsfeed_mobile/models/FeedProvider.dart';
import 'package:provider/provider.dart';
import 'package:sliding_up_panel/sliding_up_panel.dart';
import 'package:url_launcher/url_launcher.dart';
import 'package:webview_flutter/webview_flutter.dart';

class DetailPage extends StatefulWidget {
  final Feed feed;

  DetailPage({@required this.feed});

  @override
  _DetailPageState createState() => _DetailPageState();
}

class _DetailPageState extends State<DetailPage> {
  bool isStar = false;
  double baseFrontSize = 20;
  bool isOpen = false;
  bool willOpenLink = true;

  @override
  void initState() {
    super.initState();
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
                  ),
                  SwitchListTile(
                    value: willOpenLink,
                    onChanged: (v) {
                      setState(() {
                        willOpenLink = v;
                      });
                    },
                    title: Text("Selectable"),
                  ),
                  FlatButton(
                    onPressed: () async {
                      final DynamicLinkParameters parameters =
                          DynamicLinkParameters(
                              uriPrefix:
                                  "https://mobile.sirileepage.com/news/mobile",
                              link: Uri.parse(""));
                    },
                    child: Text("Share to others"),
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
    FeedProvider provider = Provider.of<FeedProvider>(context);

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
                  setState(() {
                    isStar = false;
                  });
                } else {
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
          maxHeight: 240,
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
                    onTapLink: (link) async {
                      Feed feed = await provider.redirect(link);
                      if (feed != null) {
                        Navigator.of(context).push(
                          MaterialPageRoute(builder: (ctx) {
                            return DetailPage(
                              feed: feed,
                            );
                          }),
                        );
                      } else {
                        if (await canLaunch(link)) {
                          await launch(link);
                        }
                      }
                    },
                    selectable: false,
                    styleSheet: MarkdownStyleSheet.fromTheme(theme.copyWith(
                      textTheme: theme.textTheme.copyWith(
                        bodyText1: theme.textTheme.bodyText1
                            .copyWith(fontSize: baseFrontSize + 10),
                        // display1: theme.textTheme.headline
                        //     .copyWith(fontSize: baseFrontSize + 10),
                        bodyText2: theme.textTheme.bodyText2
                            .copyWith(fontSize: baseFrontSize),
                      ),
                    )).copyWith(
                      tableCellsDecoration:
                          BoxDecoration(color: Colors.transparent),
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
        floatingActionButton: widget.feed.feedComments != null
            ? Padding(
                padding: EdgeInsets.fromLTRB(0, 0, 0, 80),
                child: Stack(
                  children: <Widget>[
                    FloatingActionButton(
                      backgroundColor: Colors.blue,
                      onPressed: () async {
                        Navigator.push(
                          context,
                          MaterialPageRoute(
                            builder: (c) => DetailCommentPage(
                              comments: widget.feed.feedComments,
                              feed: widget.feed,
                            ),
                          ),
                        );
                      },
                      child: Icon(
                        Icons.message,
                        color: Theme.of(context).iconTheme.color,
                      ),
                    ),
                    Positioned(
                      right: 10,
                      bottom: 35,
                      child: Text(
                        "${widget.feed.feedComments.length}",
                        style: TextStyle(
                          shadows: [Shadow(blurRadius: 2, color: Colors.black)],
                          fontWeight: FontWeight.w900,
                          color: Colors.white,
                        ),
                      ),
                    )
                  ],
                ),
              )
            : Container());
  }
}
