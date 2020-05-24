import 'package:flutter/foundation.dart';
import 'package:flutter/gestures.dart';
import 'package:flutter/material.dart';
import 'package:newsfeed_mobile/Detail/DetailPage.dart';
import 'package:newsfeed_mobile/models/FeedProvider.dart';
import 'package:provider/provider.dart';
import 'package:webview_flutter/webview_flutter.dart';

class HeadlineWebview extends StatefulWidget {
  final String url;
  final String title;
  HeadlineWebview({@required this.url, this.title});

  @override
  _HeadlineWebviewState createState() => _HeadlineWebviewState();
}

class _HeadlineWebviewState extends State<HeadlineWebview> {
  bool hasLoaded = false;
  @override
  Widget build(BuildContext context) {
    FeedProvider provider = Provider.of(context);

    return Scaffold(
      appBar: AppBar(
        title: Text("${widget.title}"),
      ),
      body: Stack(
        children: <Widget>[
          WebView(
            initialUrl: widget.url,
            javascriptMode: JavascriptMode.unrestricted,
            onPageFinished: (url) {
              setState(() {
                hasLoaded = true;
              });
            },
            onPageStarted: (url) {
              setState(() {
                hasLoaded = false;
              });
            },
            navigationDelegate: (navigation) {
              if (navigation.url.contains(provider.shareURL)) {
                var feedID = int.tryParse(
                  navigation.url
                      .replaceAll(provider.shareURL, "")
                      .replaceAll("/", ""),
                );
                setState(() {
                  hasLoaded = false;
                });
                provider.fetchFeed(feedID).then((feed) {
                  setState(() {
                    hasLoaded = true;
                  });
                  Navigator.of(context).push(
                    MaterialPageRoute(
                      builder: (c) => DetailPage(
                        feed: feed,
                      ),
                    ),
                  );
                });
                return NavigationDecision.prevent;
              }
              return NavigationDecision.navigate;
            },
          ),
          if (!hasLoaded)
            Center(
              child: Card(
                child: Padding(
                  padding: const EdgeInsets.all(20),
                  child: CircularProgressIndicator(),
                ),
              ),
            )
        ],
      ),
    );
  }
}
