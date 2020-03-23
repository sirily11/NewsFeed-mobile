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
            onPressed: () async {
              if (await canLaunch(feed.link)) {
                await launch(feed.link);
              }
            },
            icon: Icon(Icons.open_in_new),
          )
        ],
      ),
      body: WebView(
        javascriptMode: JavascriptMode.unrestricted,
        initialUrl: feed.link,
      ),
    );
  }
}
