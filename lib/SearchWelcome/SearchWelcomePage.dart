import 'package:flutter/material.dart';
import 'package:newsfeed_mobile/Detail/DetailPage.dart';
import 'package:newsfeed_mobile/models/FeedProvider.dart';
import 'package:newsfeed_mobile/models/HotKeyword.dart';
import 'package:provider/provider.dart';

class SearchWelcomePage extends StatefulWidget {
  const SearchWelcomePage({
    Key key,
  }) : super(key: key);

  @override
  _SearchWelcomePageState createState() => _SearchWelcomePageState();
}

class _SearchWelcomePageState extends State<SearchWelcomePage> {
  bool isLoading = false;

  @override
  Widget build(BuildContext context) {
    return GestureDetector(
      onTap: () {
        FocusScope.of(context).requestFocus(FocusNode());
      },
      child: Stack(
        children: <Widget>[
          FutureBuilder<List<HotKeyword>>(
            future: Provider.of<FeedProvider>(context).fetchHotKeywords(),
            builder: (context, snapshot) {
              if (!snapshot.hasData) {
                return Center(
                  child: CircularProgressIndicator(),
                );
              }
              if (snapshot.hasError) {
                return Center(
                  child: Text("${snapshot.error}"),
                );
              }
              return ListView(
                children: <Widget>[
                  Padding(
                    padding: const EdgeInsets.all(8.0),
                    child: Text(
                      "热搜",
                      style: TextStyle(fontSize: 20),
                    ),
                  ),
                  ListView.builder(
                    physics: NeverScrollableScrollPhysics(),
                    shrinkWrap: true,
                    itemCount: snapshot.data.length,
                    itemBuilder: (context, index) {
                      var hotkeyword = snapshot.data[index];
                      return Padding(
                        padding: const EdgeInsets.all(8.0),
                        child: Column(
                          mainAxisAlignment: MainAxisAlignment.start,
                          crossAxisAlignment: CrossAxisAlignment.start,
                          children: <Widget>[
                            Text(
                              "${hotkeyword.keyword}",
                              style: TextStyle(fontSize: 20),
                            ),
                            Divider(
                              indent: 20,
                              endIndent: 10,
                            ),
                            GridView.builder(
                                physics: NeverScrollableScrollPhysics(),
                                itemCount: hotkeyword.feeds.length,
                                shrinkWrap: true,
                                gridDelegate:
                                    SliverGridDelegateWithFixedCrossAxisCount(
                                  crossAxisCount: 2,
                                  crossAxisSpacing: 10,
                                  childAspectRatio: 1.3,
                                ),
                                itemBuilder: (context, index) {
                                  var feed = hotkeyword.feeds[index];
                                  return InkWell(
                                    onTap: () async {
                                      setState(() {
                                        isLoading = true;
                                      });
                                      FeedProvider provider =
                                          Provider.of(context, listen: false);
                                      var f = await provider.fetchFeed(feed.id);
                                      setState(() {
                                        isLoading = false;
                                      });
                                      Navigator.push(
                                        context,
                                        MaterialPageRoute(
                                          builder: (c) => DetailPage(
                                            feed: f,
                                          ),
                                        ),
                                      );
                                    },
                                    child: Column(
                                      children: <Widget>[
                                        if (feed.cover != null)
                                          ClipRRect(
                                            borderRadius:
                                                BorderRadius.circular(10),
                                            child: Image.network(
                                              feed.cover,
                                              width: 200,
                                              height: 100,
                                              fit: BoxFit.cover,
                                            ),
                                          ),
                                        if (feed.cover == null)
                                          ClipRRect(
                                            borderRadius:
                                                BorderRadius.circular(10),
                                            child: Container(
                                              height: 100,
                                              color:
                                                  Theme.of(context).cardColor,
                                              child: Center(
                                                child: Text(feed.publisherName),
                                              ),
                                            ),
                                          ),
                                        Text(
                                          "${feed.title}",
                                          maxLines: 2,
                                          overflow: TextOverflow.ellipsis,
                                        )
                                      ],
                                    ),
                                  );
                                })
                          ],
                        ),
                      );
                    },
                  ),
                ],
              );
            },
          ),
          if (isLoading)
            Center(
              child: Card(
                child: Padding(
                  padding: const EdgeInsets.all(20),
                  child: CircularProgressIndicator(),
                ),
              ),
            )
        ],
      ),
    );
  }
}
