import 'package:flutter/material.dart';
import 'package:newsfeed_mobile/Database/FeedData.dart';
import 'package:newsfeed_mobile/Detail/DetailPage.dart';
import 'package:newsfeed_mobile/models/Feed.dart';

class StarFeedList extends StatelessWidget {
  @override
  Widget build(BuildContext context) {
    return FutureBuilder<List<FavoriteFeedData>>(
      future: MyDatabase().allFavoriteFeed,
      builder: (context, snapshot) {
        if (!snapshot.hasData) {
          return CircularProgressIndicator();
        } else {
          if (snapshot.data.length == 0) {
            return Center(
              child: Text("No data"),
            );
          }

          return ListView.builder(
              itemCount: snapshot.data.length,
              itemBuilder: (context, index) {
                var feed = snapshot.data[index];
                return GestureDetector(
                  onTap: () {
                    Navigator.of(context).push(
                      MaterialPageRoute(
                        builder: (context) => DetailPage(
                          feed: Feed(
                              title: feed.title,
                              content: feed.content,
                              cover: feed.cover,
                              link: feed.link,
                              id: feed.id,
                              publisher: Publisher(name: feed.publiser),
                              sentiment: feed.sentiment,
                              postedTime: feed.postedTime),
                        ),
                      ),
                    );
                  },
                  child: Padding(
                    padding: const EdgeInsets.all(8.0),
                    child: Container(
                      height: 100,
                      child: Card(
                        child: ListTile(
                          title: Text(feed.title),
                          subtitle: Text(feed.publiser),
                          trailing: feed.cover != null
                              ? Image.network(
                                  feed.cover,
                                  width: 130,
                                  fit: BoxFit.cover,
                                )
                              : null,
                        ),
                      ),
                    ),
                  ),
                );
              });
        }
      },
    );
  }
}
