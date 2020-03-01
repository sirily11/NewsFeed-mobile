import 'package:flutter/material.dart';
import 'package:flutter_easyrefresh/easy_refresh.dart';
import 'package:flutter_easyrefresh/material_header.dart';
import 'package:flutter_staggered_grid_view/flutter_staggered_grid_view.dart';
import 'package:liquid_pull_to_refresh/liquid_pull_to_refresh.dart';
import 'package:newsfeed_mobile/Detail/DetailPage.dart';
import 'package:newsfeed_mobile/Home/FeedRow.dart';
import 'package:newsfeed_mobile/models/Feed.dart';
import 'package:newsfeed_mobile/models/FeedProvider.dart';
import 'package:provider/provider.dart';

class NewsList extends StatelessWidget {
  final Function refetch;
  final List<Feed> feeds;

  const NewsList({@required this.refetch, @required this.feeds});

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
          return FeedRow(
            feed: feed,
          );
        },
      ),
    );
  }

  Widget _renderBigScreen(int count, BuildContext context) {
    FeedProvider provider = Provider.of(context);

    return new StaggeredGridView.countBuilder(
      // key: Key("news_list"),
      shrinkWrap: true,
      controller: provider.scrollController,
      crossAxisCount: count,
      itemCount: provider.nextLink != null
          ? provider.feeds.length + 1
          : provider.feeds.length,
      itemBuilder: (BuildContext context, int index) {
        if (index == provider.feeds.length) {
          return Center(
            child: Text(
              "More on bottom...",
              key: Key("more_text"),
            ),
          );
        }

        Feed feed = provider.feeds[index];
        return GestureDetector(
          onTap: () {
            Navigator.of(context).push(
              MaterialPageRoute(
                builder: (context) {
                  return DetailPage(
                    feed: feed,
                  );
                },
              ),
            );
          },
          child: Card(
            child: FeedRow(
              feed: feed,
            ),
          ),
        );
      },
      staggeredTileBuilder: (int index) {
        if (index == provider.feeds.length) {
          return StaggeredTile.count(2, 1);
        }
        Feed feed = provider.feeds[index];
        double randomValue = index.isEven ? 0.3 : 0.9;
        double baseValue = count > 4 ? 3 : 2.5;

        return StaggeredTile.count(
            feed.cover != null ? 2 : 2,
            feed.cover != null
                ? baseValue + randomValue
                : baseValue - 2.2 + randomValue);
      },
      mainAxisSpacing: 4.0,
      crossAxisSpacing: 4.0,
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
      child: LayoutBuilder(
        builder: (context, constrains) {
          return _renderSmallScreen(context);
          // if (constrains.maxWidth < 600) {
          //   return _renderSmallScreen(context);
          // } else if (constrains.maxWidth < 900) {
          //   return _renderBigScreen(4, context);
          // } else {
          //   return _renderBigScreen(8, context);
          // }
        },
      ),
    );
  }
}
