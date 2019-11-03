import 'package:flutter/material.dart';
import 'package:newsfeed_mobile/models/Feed.dart';
import 'package:url_launcher/url_launcher.dart';
import 'package:webview_flutter/webview_flutter.dart';

class DetailWebview extends StatelessWidget {
  final Feed feed;

  DetailWebview({@required this.feed});

  @override
  Widget build(BuildContext context) {
    return Scaffold(
      appBar: AppBar(
        title: Text(feed.title),
        actions: <Widget>[
          IconButton(
            icon: Icon(Icons.open_in_browser),
            onPressed: () async {
              String url = feed.link;
              if (await canLaunch(url)) {
                await launch(url);
              } else {
                throw 'Could not launch $url';
              }
            },
          )
        ],
      ),
      body: WebView(
        initialUrl: feed.link,
      ),
    );
  }
}
