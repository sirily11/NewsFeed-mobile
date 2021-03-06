import 'package:flutter/material.dart';
import 'package:flutter_easyrefresh/easy_refresh.dart';
import 'package:newsfeed_mobile/Detail/DetailPage.dart';
import 'package:newsfeed_mobile/Detail/DetailPageLarge.dart';
import 'package:newsfeed_mobile/Home/FeedRow.dart';
import 'package:newsfeed_mobile/master-detail/master_detail_route.dart';
import 'package:newsfeed_mobile/models/Feed.dart';
import 'package:newsfeed_mobile/models/FeedProvider.dart';
import 'package:newsfeed_mobile/utils/utils.dart';
import 'package:provider/provider.dart';
import 'package:transparent_image/transparent_image.dart';

typedef SelectFeed(int index);

class TwoColumnNewsList extends StatelessWidget {
  final Function refetch;
  final List<Feed> feeds;

  const TwoColumnNewsList({
    @required this.refetch,
    @required this.feeds,
  });

  Widget _renderSmallScreen(BuildContext context) {
    FeedProvider provider = Provider.of(context);
    return Scrollbar(
      child: ListView.separated(
        shrinkWrap: true,
        separatorBuilder: (c, i) => Padding(
          padding: const EdgeInsets.only(left: 40, right: 40),
          child: Divider(
            thickness: 2,
          ),
        ),
        // key: Key("news_list"),
        controller: provider.scrollController,
        itemCount: feeds.length,
        itemBuilder: (context, index) {
          Feed feed = feeds[index];
          return BigScreenFeedRow(
            feed: feed,
          );
        },
      ),
    );
  }

  @override
  Widget build(BuildContext context) {
    final double width = MediaQuery.of(context).size.width;
    FeedProvider provider = Provider.of(context);

    if (provider.isError) {
      return Container(
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
      header: ClassicalHeader(textColor: Colors.white),
      footer: ClassicalFooter(textColor: Colors.white),
      onLoad: () async {
        await provider.fetchMore();
      },
      onRefresh: () async {
        await provider.fetchFeeds();
      },
      scrollController: provider.scrollController,
      child: _renderSmallScreen(context),
    );
  }
}

class BigScreenFeedRow extends StatelessWidget {
  final Feed feed;

  BigScreenFeedRow({@required this.feed});

  Widget _renderImage(context) {
    if (feed.cover != null) {
      return FadeInImage.memoryNetwork(
        placeholder: kTransparentImage,
        image: feed.cover,
        width: 120,
        height: 200,
        fit: BoxFit.cover,
      );
    } else {
      return null;
    }
  }

  @override
  Widget build(BuildContext context) {
    return ListTile(
      onTap: () {
        Navigator.push(
          context,
          DetailRoute(
              builder: (c) => DetailPageLargeScreen(
                    feed: feed,
                  ),
              forceRenderTabletView: true),
        );
      },
      title: Text("${feed.title}"),
      subtitle: Text("${feed.publisher.name}\n${getTime(feed.postedTime)}"),
      trailing: _renderImage(context),
    );
  }
}
