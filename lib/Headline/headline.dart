import 'dart:math';

import 'package:carousel_slider/carousel_slider.dart';
import 'package:flutter/material.dart';
import 'package:flutter_easyrefresh/easy_refresh.dart';
import 'package:newsfeed_mobile/Headline/HeadlineWebview.dart';
import 'package:newsfeed_mobile/Headline/headline_detail.dart';
import 'package:newsfeed_mobile/models/Feed.dart';
import 'package:newsfeed_mobile/models/FeedProvider.dart';
import 'package:newsfeed_mobile/utils/utils.dart';
import 'package:provider/provider.dart';

class HeadlineList extends StatefulWidget {
  @override
  _HeadlineListState createState() => _HeadlineListState();
}

class _HeadlineListState extends State<HeadlineList> {
  @override
  Widget build(BuildContext context) {
    FeedProvider provider = Provider.of(context);
    int endIndex = min(provider.headlines.length, 5);

    return EasyRefresh(
      firstRefresh: true,
      header: ClassicalHeader(
          textColor: Theme.of(context).textTheme.bodyText2.color),
      footer: ClassicalFooter(
          textColor: Theme.of(context).textTheme.bodyText2.color),
      onRefresh: () async {
        await provider.fetchHeadline();
      },
      onLoad: () async {
        await provider.fetchMoreHeadline();
      },
      child: ListView(
        shrinkWrap: true,
        children: <Widget>[
          if (provider.headlines.length > 0)
            buildCarousel(context, provider.headlines, endIndex),
          Row(
            children: <Widget>[
              Padding(
                padding: const EdgeInsets.symmetric(horizontal: 10),
                child: Icon(Icons.list),
              ),
            ],
          ),
          buildListHeadline(1)
        ],
      ),
    );
  }

  ListView buildListHeadline(int endIndex) {
    FeedProvider provider = Provider.of(context);
    // var length = provider.headlines.length - endIndex;
    var length = provider.headlines.length;
    return ListView.builder(
      shrinkWrap: true,
      physics: NeverScrollableScrollPhysics(),
      itemCount: max(length, 0),
      itemBuilder: (c, i) {
        // Headline headline = provider.headlines[i + endIndex - 1];
        Headline headline = provider.headlines[i];
        return InkWell(
          onTap: () {
            onTap(headline);
          },
          child: Padding(
            padding: const EdgeInsets.all(8.0),
            child: Row(
              mainAxisAlignment: MainAxisAlignment.start,
              crossAxisAlignment: CrossAxisAlignment.start,
              children: <Widget>[
                Container(
                  width: 150,
                  height: 100,
                  child: Card(
                    clipBehavior: Clip.antiAliasWithSaveLayer,
                    shape: RoundedRectangleBorder(
                      borderRadius: BorderRadius.circular(10.0),
                    ),
                    child: Image.network(
                      headline.cover,
                      fit: BoxFit.cover,
                    ),
                  ),
                ),
                Spacer(),
                Expanded(
                  flex: 10,
                  child: Padding(
                    padding: EdgeInsets.only(top: 10),
                    child: Column(
                      mainAxisAlignment: MainAxisAlignment.start,
                      crossAxisAlignment: CrossAxisAlignment.start,
                      children: <Widget>[
                        Text(
                          headline.title,
                          style: Theme.of(context).textTheme.headline6,
                          overflow: TextOverflow.ellipsis,
                        ),
                        Text(
                          getTime(headline.publishedTime),
                          style: TextStyle(fontWeight: FontWeight.bold),
                        ),
                        Text(
                          headline.shortDescription,
                          maxLines: 3,
                          overflow: TextOverflow.ellipsis,
                        )
                      ],
                    ),
                  ),
                )
              ],
            ),
          ),
        );
      },
    );
  }

  void onTap(Headline headline) {
    if (headline.contentType == "json_screen") {
      Navigator.push(
        context,
        MaterialPageRoute(
          builder: (c) => HeadlineDetail(
            headline: headline,
          ),
        ),
      );
    } else if (headline.contentType == "html") {
      Navigator.push(
        context,
        MaterialPageRoute(
          builder: (c) => HeadlineWebview(
            url: headline.content,
            title: headline.title,
          ),
        ),
      );
    }
  }

  /// Build top carousel
  Widget buildCarousel(
      BuildContext context, List<Headline> headlines, int endIndex) {
    return Padding(
      padding: const EdgeInsets.all(8.0),
      child: Container(
        height: 200,
        width: MediaQuery.of(context).size.width,
        child: CarouselSlider.builder(
          enableInfiniteScroll: true,
          itemCount: endIndex,
          itemBuilder: (c, i) {
            Headline headline = headlines[i];
            return InkWell(
              onTap: () {
                onTap(headline);
              },
              child: Column(
                children: <Widget>[
                  Container(
                    height: 150,
                    width: 400,
                    child: Card(
                      clipBehavior: Clip.antiAliasWithSaveLayer,
                      shape: RoundedRectangleBorder(
                        borderRadius: BorderRadius.circular(10.0),
                      ),
                      child: Image.network(
                        headline.cover,
                        fit: BoxFit.cover,
                      ),
                    ),
                  ),
                  Text(
                    headline.title,
                    overflow: TextOverflow.ellipsis,
                    style: TextStyle(fontSize: 20),
                  ),
                  Text(
                    getTime(headline.publishedTime),
                    style: TextStyle(fontSize: 14),
                  )
                ],
              ),
            );
          },
        ),
      ),
    );
  }
}
