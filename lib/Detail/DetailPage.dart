import 'package:firebase_dynamic_links/firebase_dynamic_links.dart';
import 'package:flutter/material.dart';
import 'package:flutter_markdown/flutter_markdown.dart';
import 'package:newsfeed_mobile/Detail/DetailCommentPage.dart';
import 'package:newsfeed_mobile/Detail/DetailWebview.dart';
import 'package:newsfeed_mobile/Home/FeedClipper.dart';
import 'package:newsfeed_mobile/models/DatabaseProvider.dart';
import 'package:newsfeed_mobile/models/Feed.dart';
import 'package:newsfeed_mobile/models/FeedProvider.dart';
import 'package:newsfeed_mobile/utils/utils.dart';
import 'package:provider/provider.dart';
import 'package:sliding_up_panel/sliding_up_panel.dart';
import 'package:transparent_image/transparent_image.dart';
import 'package:url_launcher/url_launcher.dart';
import 'package:webview_flutter/webview_flutter.dart';

class DetailPage extends StatefulWidget {
  final Feed feed;
  final bool isTest;

  DetailPage({@required this.feed, this.isTest = false});

  @override
  _DetailPageState createState() => _DetailPageState();
}

class _DetailPageState extends State<DetailPage> {
  final Color appbarColor = Color.fromRGBO(43, 29, 97, 1);

  bool isStar = false;
  double baseFrontSize = 20;
  bool isOpen = false;
  bool willOpenLink = true;

  @override
  void initState() {
    super.initState();
    if (!widget.isTest) {
      DatabaseProvider databaseProvider = Provider.of(context, listen: false);
      databaseProvider.getFeed(widget.feed.id).then((feed) {
        if (feed != null) {
          setState(() {
            isStar = true;
          });
        }
      });
    }
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
                  FlatButton(
                    onPressed: () async {
                      FeedProvider feedProvider =
                          Provider.of(context, listen: false);
                      feedProvider.share(widget.feed);
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
    String content = widget.feed.content.replaceAll("[](javascript:;)", "");
    var markdownStyleSheet = MarkdownStyleSheet.fromTheme(theme.copyWith(
      textTheme: theme.textTheme.copyWith(
        bodyText1:
            theme.textTheme.bodyText1.copyWith(fontSize: baseFrontSize + 10),
        // display1: theme.textTheme.headline
        //     .copyWith(fontSize: baseFrontSize + 10),
        bodyText2: theme.textTheme.bodyText2.copyWith(fontSize: baseFrontSize),
      ),
    ));
    var openWebButton = IconButton(
      onPressed: openWeb,
      icon: Icon(Icons.open_in_new),
    );
    var starButton = IconButton(
      key: Key("star_btn"),
      color: isStar ? Colors.yellow : null,
      onPressed: () async {
        await starFeed(context);
      },
      icon: Icon(Icons.star),
    );

    return Scaffold(
      appBar: AppBar(
        leading: BackButton(
          color: Colors.white,
        ),
        actions: <Widget>[starButton, openWebButton],
        backgroundColor: appbarColor,
        elevation: 0,
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
        body: SingleChildScrollView(
          physics: ClampingScrollPhysics(),
          child: Column(
            children: <Widget>[
              buildHeader(context),
              Padding(
                padding: EdgeInsets.symmetric(horizontal: 10),
                child: MarkdownBody(
                  key: Key("news_body"),
                  onTapLink: (link) async {
                    await redirect(link, context);
                  },
                  selectable: false,
                  styleSheet: markdownStyleSheet.copyWith(
                    tableCellsDecoration:
                        BoxDecoration(color: Colors.transparent),
                  ),
                  imageBuilder: (url) => Padding(
                    padding: const EdgeInsets.symmetric(horizontal: 10),
                    child: FadeInImage(
                      width: MediaQuery.of(context).size.width,
                      fit: BoxFit.cover,
                      image: NetworkImage(url.toString()),
                      placeholder: MemoryImage(kTransparentImage),
                    ),
                  ),
                  data: content,
                ),
              ),
              SizedBox(
                height: 250,
              )
            ],
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
                    backgroundColor: theme.primaryColor,
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
          : Container(),
    );
  }

  ClipPath buildHeader(BuildContext context) {
    return ClipPath(
      clipper: HeaderClipper(),
      child: Container(
        color: appbarColor,
        width: MediaQuery.of(context).size.width,
        child: Padding(
          padding: const EdgeInsets.only(top: 0),
          child: SingleChildScrollView(
            child: Column(
              crossAxisAlignment: CrossAxisAlignment.center,
              children: <Widget>[
                Text(
                  widget.feed.publisher.name,
                  style: TextStyle(
                    fontWeight: FontWeight.bold,
                    color: Colors.orangeAccent,
                  ),
                ),
                SizedBox(
                  height: 10,
                ),
                Text(
                  widget.feed.title,
                  textAlign: TextAlign.center,
                  style: TextStyle(
                    color: Colors.white,
                    fontSize: 30,
                    fontWeight: FontWeight.bold,
                  ),
                ),
                SizedBox(
                  height: 10,
                ),
                Text(
                  widget.feed.description,
                  maxLines: 3,
                  overflow: TextOverflow.ellipsis,
                  textAlign: TextAlign.center,
                  style: TextStyle(
                    color: Colors.white,
                    fontSize: 15,
                    fontWeight: FontWeight.bold,
                  ),
                ),
                SizedBox(
                  height: 40,
                ),
              ],
            ),
          ),
        ),
      ),
    );
  }

  Future starFeed(BuildContext context) async {
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
  }

  void openWeb() async {
    if (await canLaunch(widget.feed.link)) {
      await launch(widget.feed.link);
    }
  }
}
