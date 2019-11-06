import 'package:bubble_tab_indicator/bubble_tab_indicator.dart';
import 'package:flutter/material.dart';
import 'package:newsfeed_mobile/Detail/DetailPage.dart';
import 'package:newsfeed_mobile/Home/CustomAppbar.dart';
import 'package:newsfeed_mobile/Home/FeedRow.dart';
import 'package:newsfeed_mobile/StarFeed/StarFeedList.dart';
import 'package:newsfeed_mobile/models/Feed.dart';
import 'package:newsfeed_mobile/models/FeedProvider.dart';
import 'package:newsfeed_mobile/models/HomeControlProvider.dart';
import 'package:newsfeed_mobile/utils/utils.dart';
import 'package:progress_indicators/progress_indicators.dart';
import 'package:provider/provider.dart';
import 'package:flutter_staggered_grid_view/flutter_staggered_grid_view.dart';

class HomePage extends StatefulWidget {
  /// This is the variable for testing. Set this to true if
  /// you want to test if widget with error message
  final isError;
  HomePage({this.isError = false});
  @override
  _HomePageState createState() => _HomePageState();
}

class _HomePageState extends State<HomePage> with TickerProviderStateMixin {
  TabController tabController;
  @override
  void initState() {
    super.initState();
    if (!widget.isError) {
      this.fetchTabs();
    }
  }

  fetchTabs() {
    Future.delayed(Duration(milliseconds: 30)).then((_) async {
      FeedProvider provider = Provider.of(context);
      await provider.fetchFeeds();
      List<Publisher> publishers = await provider.fetchPublishers();
      setState(() {
        tabController = TabController(vsync: this, length: publishers.length);
      });

      tabController.addListener(() async {
        if (tabController.indexIsChanging) {
          await provider.setCurrentSelectionIndex(tabController.index);
        }
      });
    });
  }

  /// Render app's main screen base on the current buttom nav
  Widget _renderPage({context, provider}) {
    HomeControlProvider homeControlProvider = Provider.of(context);
    switch (homeControlProvider.currentIndex) {
      case 1:
        return StarFeedList();

      default:
        return NewsList(
          key: Key("news_list"),
          provider: provider,
          refetch: this.fetchTabs,
        );
    }
  }

  @override
  Widget build(BuildContext context) {
    FeedProvider provider = Provider.of(context);
    HomeControlProvider homeControlProvider = Provider.of(context);

    return Scaffold(
      key: provider.key,
      appBar: CustomAppBar(
        onTap: () {
          if (homeControlProvider.currentIndex == 0) {
            provider.backToTop();
          }
        },
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
          ),
          bottom: tabController != null && homeControlProvider.currentIndex == 0
              ? TabBar(
                  indicator: BubbleTabIndicator(
                    indicatorHeight: 25,
                    indicatorColor: Colors.blueAccent,
                  ),
                  controller: tabController,
                  isScrollable: true,
                  tabs: provider.publishers
                      .map(
                        (p) => Tab(
                          child: Text(p.name),
                        ),
                      )
                      .toList(),
                )
              : null,
        ),
      ),
      body: AnimatedSwitcher(
        child: _renderPage(context: context, provider: provider),
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
            icon: Icon(Icons.home),
          ),
          BottomNavigationBarItem(
            title: Text(
              "Favorite",
              key: Key("favorite"),
            ),
            icon: Icon(Icons.star),
          ),
        ],
      ),
    );
  }
}

/// Build news list
class NewsList extends StatelessWidget {
  final Function refetch;

  const NewsList({Key key, @required this.provider, @required this.refetch})
      : super(key: key);

  final FeedProvider provider;

  Widget _renderSmallScreen() {
    return ListView.separated(
      separatorBuilder: (c, i) => Padding(
        padding: const EdgeInsets.only(left: 40, right: 40),
        child: Divider(
          thickness: 2,
        ),
      ),
      // key: Key("news_list"),
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
    );
  }

  Widget _renderBigScreen(int count) {
    return new StaggeredGridView.countBuilder(
      // key: Key("news_list"),
      controller: provider.scrollController,
      crossAxisCount: count,
      itemCount: provider.nextLink != null
          ? provider.feeds.length + 1
          : provider.feeds.length,
      itemBuilder: (BuildContext context, int index) {
        if (index == provider.feeds.length) {
          return Center(
            child: Text(
              "More on bottom...",
              key: Key("more_text"),
            ),
          );
        }

        Feed feed = provider.feeds[index];
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
          child: Card(
            child: FeedRow(
              feed: feed,
            ),
          ),
        );
      },
      staggeredTileBuilder: (int index) {
        if (index == provider.feeds.length) {
          return StaggeredTile.count(2, 1);
        }
        Feed feed = provider.feeds[index];
        double randomValue = index.isEven ? 0.3 : 0.9;
        double baseValue = count > 4 ? 3 : 2.5;

        return StaggeredTile.count(
            feed.cover != null ? 2 : 2,
            feed.cover != null
                ? baseValue + randomValue
                : baseValue - 2.2 + randomValue);
      },
      mainAxisSpacing: 4.0,
      crossAxisSpacing: 4.0,
    );
  }

  @override
  Widget build(BuildContext context) {
    final double width = MediaQuery.of(context).size.width;

    if (provider.isError) {
      return Container(
        width: width,
        child: Center(
          child: Row(
            children: <Widget>[
              IconButton(
                onPressed: () async {
                  await this.refetch();
                },
                icon: Icon(Icons.refresh),
              ),
              Text("Fetch content")
            ],
          ),
        ),
      );
    }

    return RefreshIndicator(
      onRefresh: () async {
        await provider.fetchFeeds();
      },
      child: LayoutBuilder(
        builder: (context, constrains) {
          if (constrains.maxWidth < 600) {
            return _renderSmallScreen();
          } else if (constrains.maxWidth < 900) {
            return _renderBigScreen(4);
          } else {
            return _renderBigScreen(8);
          }
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
      itemCount: feeds.length,
      itemBuilder: (context, index) {
        Feed feed = feeds[index];
        return ListTile(
          onTap: () {
            Navigator.of(context).push(
              MaterialPageRoute(
                builder: (context) => DetailPage(
                  feed: feed,
                ),
              ),
            );
          },
          title: Text(feed.title),
          subtitle: Text("${feed.publisher.name}\n${getTime(feed.postedTime)}"),
          trailing: feed.cover != null ? Image.network(feed.cover) : null,
        );
      },
    );
  }
}
