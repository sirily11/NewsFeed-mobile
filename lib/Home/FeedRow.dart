import 'package:flutter/material.dart';
import 'package:newsfeed_mobile/Detail/DetailPage.dart';
import 'package:newsfeed_mobile/models/Feed.dart';
import 'package:shimmer/shimmer.dart';
import 'package:transparent_image/transparent_image.dart';

class FeedRow extends StatelessWidget {
  final Feed feed;

  FeedRow({@required this.feed});

  Widget _renderImage(context) {
    if (feed.cover != null) {
      return Expanded(
        flex: 10,
        child: FadeInImage.memoryNetwork(
          placeholder: kTransparentImage,
          image: feed.cover,
          height: MediaQuery.of(context).size.height,
          fit: BoxFit.cover,
        ),
      );
    } else {
      return Container();
    }
  }

  Widget _renderText(context) {
    return Expanded(
      flex: 7,
      child: Padding(
        padding: const EdgeInsets.all(8.0),
        child: Container(
            child: Column(
          crossAxisAlignment: CrossAxisAlignment.start,
          mainAxisAlignment: MainAxisAlignment.center,
          children: <Widget>[
            Text(
              feed.title,
              style: Theme.of(context).textTheme.subhead,
            ),
            Text(
              "${feed.publisher.name}\n${feed.postedTime.toLocal()}",
              style: Theme.of(context).textTheme.subtitle,
            )
          ],
        )),
      ),
    );
  }

  @override
  Widget build(BuildContext context) {
    List<Widget> body = [];
    if (feed.id.isOdd) {
      body = [_renderText(context), _renderImage(context)];
    } else {
      body = [_renderImage(context), _renderText(context)];
    }

    return Container(
      height: feed.cover != null ? 280 : 120,
      width: MediaQuery.of(context).size.width,
      child: Padding(
        padding: const EdgeInsets.symmetric(horizontal: 10),
        child: GestureDetector(
          onTap: () {
            Navigator.of(context).push(MaterialPageRoute(builder: (context) {
              return DetailPage(
                feed: feed,
              );
            }));
          },
          child: Card(
            clipBehavior: Clip.antiAliasWithSaveLayer,
            shape: RoundedRectangleBorder(
              borderRadius: BorderRadius.circular(10.0),
            ),
            child: Row(
              crossAxisAlignment: CrossAxisAlignment.center,
              mainAxisAlignment: MainAxisAlignment.center,
              children: body,
            ),
          ),
        ),
      ),
    );
  }
}
