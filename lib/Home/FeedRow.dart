import 'package:cached_network_image/cached_network_image.dart';
import 'package:flutter/material.dart';
import 'package:flutter_markdown/flutter_markdown.dart';
import 'package:newsfeed_mobile/Detail/DetailPage.dart';
import 'package:newsfeed_mobile/Home/FeedClipper.dart';
import 'package:newsfeed_mobile/models/Feed.dart';
import 'package:newsfeed_mobile/models/FeedProvider.dart';
import 'package:newsfeed_mobile/models/HomeControlProvider.dart';
import 'package:newsfeed_mobile/utils/utils.dart';
import 'package:provider/provider.dart';
import 'package:transparent_image/transparent_image.dart';

class FeedRow extends StatelessWidget {
  final Feed feed;

  FeedRow({@required this.feed});

  /// Build large publisher name
  Widget _buildLargePublisher(BuildContext context) {
    return ClipPath(
      key: Key("feed-publisher"),
      clipper: ImageClipper(),
      child: Container(
        height: 300,
        color: Theme.of(context).primaryColor,
        child: Stack(
          children: <Widget>[
            Center(
              child: Text(
                feed.publisher.name,
                style: Theme.of(context).textTheme.headline5,
              ),
            ),
          ],
        ),
      ),
    );
  }

  Widget _buildImage(bool useImage, BuildContext context) {
    HomeControlProvider homeControlProvider = Provider.of(context);
    if (useImage) {
      return ClipPath(
        clipper: ImageClipper(),
        child: CachedNetworkImage(
          key: Key("feed-image"),
          placeholder: (context, url) => Center(
            child: CircularProgressIndicator(),
          ),
          errorWidget: (context, url, error) => _buildLargePublisher(context),
          imageUrl: feed.cover,
          height: 300,
          width: MediaQuery.of(context).size.width,
          fit: BoxFit.cover,
        ),
      );
    }

    return _buildLargePublisher(context);
  }

  @override
  Widget build(BuildContext context) {
    HomeControlProvider homeControlProvider = Provider.of(context);

    bool useImage =
        homeControlProvider.enableImage ? feed.cover != null : false;

    return Padding(
      padding: const EdgeInsets.symmetric(horizontal: 10),
      child: Card(
        clipBehavior: Clip.antiAliasWithSaveLayer,
        shape: RoundedRectangleBorder(
          borderRadius: BorderRadius.circular(13),
        ),
        child: InkWell(
          onLongPress: () {},
          onTap: () {
            Navigator.push(
              context,
              MaterialPageRoute(
                builder: (c) => DetailPage(
                  feed: feed,
                ),
              ),
            );
          },
          child: Column(
            mainAxisAlignment: MainAxisAlignment.start,
            crossAxisAlignment: CrossAxisAlignment.start,
            children: <Widget>[
              _buildImage(useImage, context),
              SizedBox(
                height: 30,
              ),
              Padding(
                padding: const EdgeInsets.symmetric(horizontal: 20),
                child: Text(
                  "${feed.title ?? ""}",
                  style: Theme.of(context).textTheme.headline6.copyWith(
                        fontSize: 18,
                      ),
                ),
              ),
              SizedBox(
                height: 10,
              ),
              Padding(
                padding: const EdgeInsets.symmetric(horizontal: 25),
                child: Text(
                  "${feed.description ?? ""}",
                  maxLines: 3,
                  overflow: TextOverflow.ellipsis,
                ),
              ),
              if (useImage)
                Padding(
                  padding: const EdgeInsets.only(top: 10, left: 45),
                  child: Text(
                    feed.publisher.name,
                    key: Key("small-feed-publisher"),
                    style: Theme.of(context)
                        .textTheme
                        .subtitle2
                        .copyWith(fontSize: 15),
                  ),
                ),
              Padding(
                padding: const EdgeInsets.only(left: 45, bottom: 10),
                child: Text(
                  getTime(feed.postedTime),
                  style: Theme.of(context)
                      .textTheme
                      .subtitle2
                      .copyWith(fontSize: 15),
                ),
              ),
              Padding(
                padding: const EdgeInsets.only(left: 10, bottom: 10),
                child: TagsWidget(
                  tags: feed.keywords,
                ),
              ),
            ],
          ),
        ),
      ),
    );
  }
}

class TagsWidget extends StatelessWidget {
  TagsWidget({this.tags});

  final List<String> tags;

  @override
  Widget build(BuildContext context) {
    return Container(
      height: 25,
      child: ListView(
        shrinkWrap: true,
        scrollDirection: Axis.horizontal,
        children: tags
            .map(
              (t) => Padding(
                padding: EdgeInsets.symmetric(horizontal: 4),
                child: TagWidget(
                  text: t,
                  color: Theme.of(context).buttonColor,
                ),
              ),
            )
            .toList(),
      ),
    );
  }
}

class TagWidget extends StatelessWidget {
  const TagWidget({Key key, @required this.text, this.color}) : super(key: key);

  final Color color;
  final String text;

  @override
  Widget build(BuildContext context) {
    return ClipRRect(
      borderRadius: BorderRadius.circular(15),
      child: Container(
        color: color ?? Colors.blue,
        padding: EdgeInsets.symmetric(horizontal: 6, vertical: 3),
        child: Text(
          "$text",
          style: Theme.of(context).primaryTextTheme.bodyText2,
        ),
      ),
    );
  }
}
