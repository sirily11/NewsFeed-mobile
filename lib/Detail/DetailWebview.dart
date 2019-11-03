import 'package:flutter/material.dart';
import 'package:newsfeed_mobile/models/Feed.dart';
import 'package:webview_flutter/webview_flutter.dart';

class DetailWebview extends StatelessWidget {
  final Feed feed;

  DetailWebview({@required this.feed});

  @override
  Widget build(BuildContext context) {
    return Scaffold(
      appBar: AppBar(
        title: Text(feed.title),
      ),
      body: WebView(
        initialUrl: feed.link,
      ),
    );
  }
}
