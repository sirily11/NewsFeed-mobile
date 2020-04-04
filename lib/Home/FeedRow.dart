import 'package:flutter/material.dart';
import 'package:newsfeed_mobile/Detail/DetailPage.dart';
import 'package:newsfeed_mobile/models/Feed.dart';
import 'package:newsfeed_mobile/models/FeedProvider.dart';
import 'package:newsfeed_mobile/models/HomeControlProvider.dart';
import 'package:newsfeed_mobile/utils/utils.dart';
import 'package:provider/provider.dart';
import 'package:transparent_image/transparent_image.dart';

class FeedRow extends StatelessWidget {
  final Feed feed;

  FeedRow({@required this.feed});

  Widget _renderImage(context) {
    if (feed.cover != null) {
      return FadeInImage.memoryNetwork(
        placeholder: kTransparentImage,
        image: feed.cover,
        width: MediaQuery.of(context).size.width,
        height: 300,
        fit: BoxFit.cover,
      );
    } else {
      return Container();
    }
  }

  Widget _renderText(context) {
    HomeControlProvider homeControlProvider =
        Provider.of(context, listen: false);
    bool useImageStyle =
        homeControlProvider.enableImage ? feed.cover != null : false;
    return Container(
      child: Padding(
        padding: const EdgeInsets.all(8.0),
        child: Container(
            child: Column(
          crossAxisAlignment: useImageStyle
              ? CrossAxisAlignment.center
              : CrossAxisAlignment.start,
          mainAxisAlignment: MainAxisAlignment.center,
          children: <Widget>[
            Text(
              feed.title,
              textAlign: useImageStyle ? TextAlign.center : TextAlign.start,
              style: useImageStyle
                  ? Theme.of(context).textTheme.title
                  : Theme.of(context).textTheme.subtitle,
            ),
            Column(
              crossAxisAlignment: useImageStyle
                  ? CrossAxisAlignment.center
                  : CrossAxisAlignment.start,
              children: <Widget>[
                Text(feed.publisher.name),
                Text(
                  "${getTime(feed.postedTime)}",
                  style: Theme.of(context).textTheme.subtitle,
                ),
                feed.keywords.length > 0
                    ? TagsWidget(
                        tags: feed.keywords,
                      )
                    : Container()
              ],
            ),
          ],
        )),
      ),
    );
  }

  @override
  Widget build(BuildContext context) {
    HomeControlProvider homeControlProvider = Provider.of(context);
    List<Widget> body = [
      if (homeControlProvider.enableImage) _renderImage(context),
      _renderText(context)
    ];

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
      child: Container(
        width: MediaQuery.of(context).size.width,
        child: Padding(
          padding: const EdgeInsets.symmetric(horizontal: 10),
          child: Column(
            crossAxisAlignment: CrossAxisAlignment.center,
            mainAxisAlignment: MainAxisAlignment.center,
            children: body,
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
