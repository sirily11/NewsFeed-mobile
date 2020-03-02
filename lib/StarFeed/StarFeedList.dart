import 'package:flutter/material.dart';
import 'package:newsfeed_mobile/Detail/DetailPage.dart';
import 'package:newsfeed_mobile/models/DatabaseProvider.dart';
import 'package:newsfeed_mobile/models/Feed.dart';
import 'package:newsfeed_mobile/utils/utils.dart';
import 'package:provider/provider.dart';

class StarFeedList extends StatelessWidget {
  @override
  Widget build(BuildContext context) {
    DatabaseProvider databaseProvider = Provider.of(context);
    return FutureBuilder<List<Feed>>(
      key: Key("star-list"),
      future: databaseProvider.getListFeeds(),
      builder: (context, snapshot) {
        if (snapshot.hasError) {
          return Center(
            child: Text(snapshot.error.toString()),
          );
        }
        if (!snapshot.hasData) {
          return Center(child: CircularProgressIndicator());
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
                          feed: feed,
                        ),
                      ),
                    );
                  },
                  child: Padding(
                    padding: const EdgeInsets.all(8.0),
                    child: Card(
                      child: ListTile(
                        title: Text(feed.title),
                        subtitle: Text(
                          "${feed.publisher.name}\n${getTime(feed.postedTime)}",
                        ),
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
                );
              });
        }
      },
    );
  }
}
