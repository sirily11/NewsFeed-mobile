import 'package:flutter/material.dart';
import 'package:newsfeed_mobile/Detail/DetailPage.dart';
import 'package:newsfeed_mobile/models/Feed.dart';
import 'package:newsfeed_mobile/models/FeedProvider.dart';
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
    FeedProvider provider = Provider.of(context);

    return Container(
      child: Padding(
        padding: const EdgeInsets.all(8.0),
        child: Container(
            child: Column(
          crossAxisAlignment: feed.cover != null
              ? CrossAxisAlignment.center
              : CrossAxisAlignment.start,
          mainAxisAlignment: MainAxisAlignment.center,
          children: <Widget>[
            Text(
              feed.title,
              style: feed.cover != null
                  ? Theme.of(context).textTheme.title
                  : Theme.of(context).textTheme.subtitle,
            ),
            Column(
              crossAxisAlignment: feed.cover != null
                  ? CrossAxisAlignment.center
                  : CrossAxisAlignment.start,
              children: <Widget>[
                ClipRRect(
                  borderRadius: BorderRadius.circular(15),
                  child: Container(
                    color: provider.colors[feed.publisher_id],
                    padding: EdgeInsets.symmetric(horizontal: 6, vertical: 3),
                    child: Text(
                      "${feed.publisher.name}",
                      style: Theme.of(context).textTheme.subtitle,
                    ),
                  ),
                ),
                Text(
                  "${getTime(feed.postedTime)}",
                  style: Theme.of(context).textTheme.subtitle,
                )
              ],
            ),
          ],
        )),
      ),
    );
  }

  @override
  Widget build(BuildContext context) {
    List<Widget> body = [_renderImage(context), _renderText(context)];

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
