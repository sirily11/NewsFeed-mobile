import 'package:firebase_dynamic_links/firebase_dynamic_links.dart';
import 'package:flutter/material.dart';
import 'package:flutter_markdown/flutter_markdown.dart';
import 'package:newsfeed_mobile/Detail/DetailCommentDialog.dart';
import 'package:newsfeed_mobile/Detail/DetailCommentPage.dart';
import 'package:newsfeed_mobile/Detail/DetailWebview.dart';
import 'package:newsfeed_mobile/models/DatabaseProvider.dart';
import 'package:newsfeed_mobile/models/Feed.dart';
import 'package:newsfeed_mobile/models/FeedProvider.dart';
import 'package:newsfeed_mobile/utils/utils.dart';
import 'package:provider/provider.dart';
import 'package:sliding_up_panel/sliding_up_panel.dart';
import 'package:url_launcher/url_launcher.dart';
import 'package:webview_flutter/webview_flutter.dart';

class DetailPageLargeScreen extends StatefulWidget {
  final Feed feed;

  DetailPageLargeScreen({@required this.feed});

  @override
  _DetailPageLargeScreenState createState() => _DetailPageLargeScreenState();
}

class _DetailPageLargeScreenState extends State<DetailPageLargeScreen> {
  bool isStar = false;
  double baseFrontSize = 20;

  @override
  void initState() {
    super.initState();
    DatabaseProvider databaseProvider = Provider.of(context, listen: false);
    databaseProvider.getFeed(widget.feed.id).then((feed) {
      if (feed != null) {
        setState(() {
          isStar = true;
        });
      }
    });
  }

  @override
  Widget build(BuildContext context) {
    ThemeData theme = Theme.of(context);
    FeedProvider provider = Provider.of<FeedProvider>(context);

    return Scaffold(
      appBar: AppBar(
        title: Text(widget.feed.title),
        leading: BackButton(),
        actions: <Widget>[
          IconButton(
            onPressed: () async {
              if (await canLaunch(widget.feed.link)) {
                await launch(widget.feed.link);
              }
            },
            icon: Icon(Icons.open_in_browser),
          ),
          IconButton(
            key: Key("star_btn"),
            color: isStar ? Colors.yellow : null,
            onPressed: () async {
              DatabaseProvider provider = Provider.of(context, listen: false);
              if (isStar) {
                // delete feed from db
                await provider.deleteFeedFromDB(widget.feed);
                setState(() {
                  isStar = false;
                });
              } else {
                // add feed to db
                await provider.addFeedToDB(widget.feed);
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
        onTapLink: (link) async {
          await redirect(link, context);
        },
        selectable: false,
        styleSheet: MarkdownStyleSheet.fromTheme(theme.copyWith(
          textTheme: theme.textTheme.copyWith(
            bodyText1: theme.textTheme.bodyText1
                .copyWith(fontSize: baseFrontSize + 10),
            // display1: theme.textTheme.headline
            //     .copyWith(fontSize: baseFrontSize + 10),
            bodyText2:
                theme.textTheme.bodyText2.copyWith(fontSize: baseFrontSize),
          ),
        )).copyWith(
          tableCellsDecoration: BoxDecoration(color: Colors.transparent),
        ),
        data: widget.feed.content,
      ),
      floatingActionButton: widget.feed.feedComments != null
          ? Stack(
              children: <Widget>[
                FloatingActionButton(
                  backgroundColor: Colors.blue,
                  onPressed: () async {
                    showDialog(
                      context: context,
                      builder: (c) => AlertDialog(
                        title:
                            Text("${widget.feed.feedComments.length} Comments"),
                        content: Container(
                          height: MediaQuery.of(context).size.height,
                          width: MediaQuery.of(context).size.width / 2,
                          child: DetailCommentDialog(
                            comments: widget.feed.feedComments,
                            feed: widget.feed,
                          ),
                        ),
                        actions: <Widget>[
                          FlatButton(
                            child: Text("OK"),
                            onPressed: () => Navigator.pop(context),
                          )
                        ],
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
                      fontWeight: FontWeight.bold,
                      color: Colors.white,
                    ),
                  ),
                )
              ],
            )
          : Container(),
    );
  }
}
