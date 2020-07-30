import 'package:flutter/material.dart';
import 'package:flutter_easyrefresh/easy_refresh.dart';
import 'package:newsfeed_mobile/Home/FeedRow.dart';
import 'package:newsfeed_mobile/Home/headline/headlineList.dart';
import 'package:newsfeed_mobile/models/Feed.dart';
import 'package:newsfeed_mobile/models/FeedProvider.dart';
import 'package:provider/provider.dart';

class NewsList extends StatelessWidget {
  final Function refetch;
  final List<Feed> feeds;

  const NewsList({@required this.refetch, @required this.feeds});

  /// Render list of news feed
  Widget _renderNewsList(BuildContext context) {
    FeedProvider provider = Provider.of(context);
    bool showHeadline = provider.currentSelectionIndex == 0;

    return ListView.builder(
      shrinkWrap: true,
      key: Key("news_list"),
      controller: provider.scrollController,
      itemCount: showHeadline ? feeds.length + 2 : feeds.length,
      itemBuilder: (context, index) {
        if (index == 0) {
          return HomeHeadlineList();
        }
        if (index == 1) {
          return SizedBox(
            height: 20,
          );
        }
        Feed feed = feeds[index - 2];
        return FeedRow(
          feed: feed,
        );
      },
    );
  }

  @override
  Widget build(BuildContext context) {
    final double width = MediaQuery.of(context).size.width;
    FeedProvider provider = Provider.of(context);

    if (provider.isError) {
      return Container(
        key: Key("error-refresh"),
        width: width,
        child: Center(
          child: Row(
            children: <Widget>[
              IconButton(
                onPressed: () async {
                  await this.refetch();
                },
                icon: Icon(Icons.refresh),
              ),
              Text("Fetch content")
            ],
          ),
        ),
      );
    }

    return EasyRefresh(
      header: ClassicalHeader(
          textColor: Theme.of(context).textTheme.bodyText1.color,
          refreshReadyText: "Release to fetch",
          refreshText: provider.prevLink != null
              ? "Go Back To Previous"
              : "Pull to refresh",
          refreshingText: "Fetching feeds",
          refreshedText: "Finished"),
      footer: ClassicalFooter(
        textColor: Theme.of(context).textTheme.bodyText1.color,
      ),
      firstRefresh: true,
      onLoad: () async {
        await provider.fetchMore();
      },
      onRefresh: () async {
        await refetch();
      },
      child: _renderNewsList(context),
    );
  }
}
