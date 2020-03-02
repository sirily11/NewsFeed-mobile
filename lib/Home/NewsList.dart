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
