import 'package:flutter/material.dart';
import 'package:newsfeed_mobile/Detail/DetailPage.dart';
import 'package:newsfeed_mobile/Home/FeedRow.dart';
import 'package:newsfeed_mobile/models/Feed.dart';
import 'package:newsfeed_mobile/models/FeedProvider.dart';
import 'package:newsfeed_mobile/models/HomeControlProvider.dart';
import 'package:progress_indicators/progress_indicators.dart';
import 'package:provider/provider.dart';

class HomePage extends StatelessWidget {
  @override
  Widget build(BuildContext context) {
    FeedProvider provider = Provider.of(context);
    HomeControlProvider homeControlProvider = Provider.of(context);

    return Scaffold(
      key: provider.key,
      appBar: AppBar(
          actions: <Widget>[
            IconButton(
              icon: Icon(Icons.search),
              onPressed: () {
                showSearch(context: context, delegate: NewsSearch());
              },
            )
          ],
          title: AnimatedSwitcher(
            duration: Duration(milliseconds: 300),
            child: provider.isLoading
                ? JumpingText("Loading")
                : Text(
                    provider.publishers[provider.currentSelectionIndex].name,
                    key: Key("title"),
                  ),
          )),
      body: AnimatedSwitcher(
        child: homeControlProvider.currentIndex == 0
            ? NewsList(provider: provider)
            : SettingPage(),
        duration: Duration(milliseconds: 300),
      ),
      bottomNavigationBar: BottomNavigationBar(
        currentIndex: homeControlProvider.currentIndex,
        onTap: (index) {
          homeControlProvider.currentIndex = index;
        },
        items: [
          BottomNavigationBarItem(
              title: Text(
                "News",
                key: Key("news"),
              ),
              icon: Icon(Icons.home)),
          BottomNavigationBarItem(
            title: Text(
              "Settings",
              key: Key("settings"),
            ),
            icon: Icon(Icons.settings),
          )
        ],
      ),
    );
  }
}

class SettingPage extends StatelessWidget {
  const SettingPage({
    Key key,
  }) : super(key: key);

  @override
  Widget build(BuildContext context) {
    FeedProvider provider = Provider.of(context);
    return GridView.builder(
      gridDelegate: SliverGridDelegateWithFixedCrossAxisCount(
          crossAxisCount: 2, crossAxisSpacing: 8),
      itemCount: provider.publishers.length,
      itemBuilder: (context, index) {
        Publisher publisher = provider.publishers[index];
        return Padding(
          padding: const EdgeInsets.symmetric(vertical: 8),
          child: GestureDetector(
            onTap: () async {
              await provider.setCurrentSelectionIndex(index);
              var control = Provider.of<HomeControlProvider>(context);
              control.currentIndex = 0;
            },
            child: Container(
              color: provider.currentSelectionIndex == index
                  ? Colors.teal
                  : Colors.grey,
              child: Center(
                  child: Text(
                publisher.name,
                key: Key(publisher.id.toString()),
                style: TextStyle(fontSize: 20),
              )),
            ),
          ),
        );
      },
    );
  }
}

class NewsList extends StatelessWidget {
  const NewsList({
    Key key,
    @required this.provider,
  }) : super(key: key);

  final FeedProvider provider;

  @override
  Widget build(BuildContext context) {
    return RefreshIndicator(
      onRefresh: () async {
        await provider.fetchFeeds();
      },
      child: ListView.builder(
        key: Key("news_list"),
        controller: provider.scrollController,
        itemCount: provider.nextLink != null
            ? provider.feeds.length + 1
            : provider.feeds.length,
        itemBuilder: (context, index) {
          if (index == provider.feeds.length) {
            return Center(
              child: Text(
                "More on bottom...",
                key: Key("more_text"),
              ),
            );
          }
          Feed feed = provider.feeds[index];
          return FeedRow(
            feed: feed,
          );
        },
      ),
    );
  }
}

class NewsSearch extends SearchDelegate<String> {
  @override
  ThemeData appBarTheme(BuildContext context) {
    final ThemeData theme = Theme.of(context);
    return theme.copyWith(
      primaryColor: theme.primaryColor,
      primaryIconTheme: theme.primaryIconTheme,
      primaryColorBrightness: theme.primaryColorBrightness,
      primaryTextTheme: theme.primaryTextTheme,
    );
  }

  @override
  List<Widget> buildActions(BuildContext context) {
    return [
      IconButton(
        icon: Icon(Icons.clear),
        onPressed: () {
          query = "";
        },
      )
    ];
  }

  @override
  Widget buildLeading(BuildContext context) {
    return IconButton(
      icon: AnimatedIcon(
        progress: transitionAnimation,
        icon: AnimatedIcons.menu_arrow,
      ),
      onPressed: () {
        close(context, null);
      },
    );
  }

  @override
  Widget buildResults(BuildContext context) {
    FeedProvider newsProvider = Provider.of(context);
    final future = newsProvider.search(query);
    if (query.isNotEmpty) {
      return FutureBuilder<List<Feed>>(
        future: future,
        builder: (context, snapshot) {
          return AnimatedSwitcher(
            duration: Duration(milliseconds: 300),
            child: !snapshot.hasData
                ? Center(
                    child: CircularProgressIndicator(
                      key: Key("search_progress"),
                    ),
                  )
                : _buildListResults(snapshot.data),
          );
        },
      );
    } else {
      return Container();
    }
  }

  @override
  Widget buildSuggestions(BuildContext context) {
    FeedProvider feedProvider = Provider.of(context);
    List<Feed> suggestionList = query.isNotEmpty
        ? feedProvider.feeds
            .where(
              (r) => r.title.toLowerCase().contains(
                    query.toLowerCase(),
                  ),
            )
            .toList()
        : [];
    return _buildListResults(suggestionList);
  }

  Widget _buildListResults(List<Feed> feeds) {
    if (feeds.length == 0) {
      return Center(
        child: Text("No result"),
      );
    }

    return ListView.builder(
      key: Key("search_list"),
      itemCount: feeds.length,
      itemBuilder: (context, index) {
        Feed feed = feeds[index];
        return ListTile(
          onTap: () {
            Navigator.of(context).push(
              MaterialPageRoute(
                  builder: (context) => DetailPage(
                        feed: feed,
                      )),
            );
          },
          title: Text(feed.title),
          subtitle: Text(feed.publisher.name),
          trailing: Image.network(feed.cover ?? ""),
        );
      },
    );
  }
}
