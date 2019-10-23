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
                    provider.publishers[provider.currentSelectionIndex].name),
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
          BottomNavigationBarItem(title: Text("News"), icon: Icon(Icons.home)),
          BottomNavigationBarItem(
              title: Text("Settings"), icon: Icon(Icons.settings))
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
            onTap: () {
              provider.currentSelectionIndex = index;
            },
            child: Container(
              color: provider.currentSelectionIndex == index
                  ? Colors.teal
                  : Colors.grey,
              child: Center(
                  child: Text(
                publisher.name,
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
        controller: provider.scrollController,
        itemCount: provider.feeds.length,
        itemBuilder: (context, index) {
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
          if (!snapshot.hasData) {
            return JumpingDotsProgressIndicator(
              fontSize: 28,
              numberOfDots: 3,
            );
          } else {
            final suggestionList = snapshot.data;
            return _buildListResults(suggestionList);
          }
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
    return ListView.builder(
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
