import 'package:flutter/material.dart';
import 'package:newsfeed_mobile/Detail/DetailPage.dart';
import 'package:newsfeed_mobile/models/Feed.dart';
import 'package:shimmer/shimmer.dart';
import 'package:transparent_image/transparent_image.dart';

class FeedRow extends StatelessWidget {
  final Feed feed;

  FeedRow({@required this.feed});

  @override
  Widget build(BuildContext context) {
    return ListTile(
      key: Key(feed.title),
      onTap: () {
        Navigator.of(context).push(MaterialPageRoute(builder: (context) {
          return DetailPage(
            feed: feed,
          );
        }));
      },
      title: Text(feed.title),
      subtitle: Text(
          "${feed.publisher.name}\n${feed.postedTime.year}-${feed.postedTime.month}-${feed.postedTime.day}"),
      trailing: feed.cover != null
          ? FadeInImage.memoryNetwork(
              placeholder: kTransparentImage,
              image: feed.cover,
              width: MediaQuery.of(context).size.width * 0.2,
              fit: BoxFit.cover,
            )
          : Image.memory(
              kTransparentImage,
            ),
    );
  }
}
