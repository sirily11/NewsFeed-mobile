import 'package:carousel_slider/carousel_slider.dart';
import 'package:flutter/material.dart';
import 'package:newsfeed_mobile/Detail/DetailPage.dart';
import 'package:newsfeed_mobile/models/Feed.dart';
import 'package:newsfeed_mobile/models/FeedProvider.dart';
import 'package:newsfeed_mobile/utils/utils.dart';
import 'package:provider/provider.dart';

class HomeHeadlineList extends StatelessWidget {
  final double width = 400;
  final double height = 150;
  @override
  Widget build(BuildContext context) {
    FeedProvider provider = Provider.of(context);
    List<Feed> headlines = provider.publishers
        .where((element) => element.headline != null)
        .map((e) => e.headline)
        .toList();

    if (headlines.length == 0) {
      return Container();
    }

    return CarouselSlider.builder(
        height: height,
        itemCount: headlines.length,
        itemBuilder: (c, i) {
          Feed headline = headlines[i];
          return Stack(
            children: <Widget>[
              Container(
                width: width,
                height: height,
                child: Card(
                  clipBehavior: Clip.antiAliasWithSaveLayer,
                  shape: RoundedRectangleBorder(
                    borderRadius: BorderRadius.circular(10.0),
                  ),
                  child: Image.network(
                    headline.cover ?? "",
                    fit: BoxFit.cover,
                  ),
                ),
              ),
              Positioned(
                bottom: 10,
                left: 10,
                width: 300,
                child: Container(
                  color: Colors.black.withOpacity(0.5),
                  child: Column(
                    crossAxisAlignment: CrossAxisAlignment.start,
                    children: <Widget>[
                      Text(
                        headline.title,
                        style: TextStyle(fontSize: 14),
                      ),
                      Text("${headline.publisher.name}"),
                    ],
                  ),
                ),
              ),
            ],
          );
        });
  }
}
