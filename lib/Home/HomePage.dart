import 'dart:async';
import 'dart:io';
import 'package:bubble_tab_indicator/bubble_tab_indicator.dart';
import 'package:debounce_throttle/debounce_throttle.dart';
import 'package:flutter/foundation.dart';
import 'package:flutter/material.dart';
import 'package:newsfeed_mobile/Detail/DetailPage.dart';
import 'package:newsfeed_mobile/Headline/headline.dart';
import 'package:newsfeed_mobile/Home/headline/NewsList.dart';
import 'package:newsfeed_mobile/Home/parts/CustomAppbar.dart';
import 'package:newsfeed_mobile/Home/HelpCardList.dart';
import 'package:newsfeed_mobile/Home/TwoColumnNewsList.dart';
import 'package:newsfeed_mobile/Home/parts/drawer.dart';
import 'package:newsfeed_mobile/StarFeed/StarFeedList.dart';
import 'package:newsfeed_mobile/master-detail/master_detail_container.dart';
import 'package:newsfeed_mobile/models/DatabaseProvider.dart';
import 'package:newsfeed_mobile/models/Feed.dart';
import 'package:newsfeed_mobile/models/FeedProvider.dart';
import 'package:newsfeed_mobile/models/HomeControlProvider.dart';
import 'package:newsfeed_mobile/utils/utils.dart';
import 'package:progress_indicators/progress_indicators.dart';
import 'package:provider/provider.dart';
import 'package:responsive_scaffold/responsive_scaffold.dart';
import 'package:shared_preferences/shared_preferences.dart';

const kTabletWidth = 720.0;

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

  /// Fetch tabs and feeds
  Future<void> fetchTabs() async {
    FeedProvider provider = Provider.of(context, listen: false);
    List<Publisher> publishers = await provider.fetchPublishers();
    await provider.fetchFeeds();
    if (publishers != null) {
      setState(() {
        tabController = TabController(vsync: this, length: publishers.length);
      });
    }

    tabController?.addListener(() async {
      if (tabController.indexIsChanging) {
        await provider.setCurrentSelectionIndex(tabController.index);
      }
    });
  }

  /// Render app's main screen base on the current buttom nav
  Widget _renderPage({context, provider}) {
    HomeControlProvider homeControlProvider =
        Provider.of(context, listen: false);
    FeedProvider provider = Provider.of(context);

    switch (homeControlProvider.currentIndex) {
      case 0:
        return HeadlineList();

      case 2:
        return StarFeedList();

      case 1:
        if (provider.baseURL == null) {
          return HelpCardList();
        }

        return LayoutBuilder(
          builder: (c, constrains) {
            if (Platform.isIOS ||
                Platform.isAndroid ||
                kIsWeb && constrains.maxWidth < kTabletWidth) {
              return NewsList(
                feeds: provider.feeds,
                refetch: this.fetchTabs,
              );
            } else {
              return TwoColumnNewsList(
                feeds: provider.feeds,
                refetch: this.fetchTabs,
              );
            }
          },
        );
    }
  }

  @override
  Widget build(BuildContext context) {
    FeedProvider provider = Provider.of(context);

    return LayoutBuilder(
      builder: (context, constrains) {
        if (Platform.isIOS ||
            Platform.isAndroid ||
            kIsWeb && constrains.maxWidth < kTabletWidth) {
          return Scaffold(
            drawer: DrawerWidget(),
            floatingActionButton: FloatingActionButton(child: Icon(Icons.file_upload), onPressed: (){
              provider.backToTop();
            },),
            key: provider.key,
            appBar: buildCustomAppBar(context),
            body: AnimatedSwitcher(
              child: _renderPage(context: context, provider: provider),
              duration: Duration(milliseconds: 300),
            ),
            bottomNavigationBar: buildBottomNavigationBar(),
          );
        } else {
          return MasterDetailContainer(
            forceRenderTabletView: true,
            child: Material(
              child: Card(
                shape: RoundedRectangleBorder(
                  borderRadius: BorderRadius.circular(15.0),
                ),
                child: Scaffold(
                  key: provider.key,
                  appBar: buildCustomAppBar(context),
                  drawer: DrawerWidget(),
                  body: AnimatedSwitcher(
                    child: _renderPage(context: context, provider: provider),
                    duration: Duration(milliseconds: 300),
                  ),
                  bottomNavigationBar: buildBottomNavigationBar(),
                ),
              ),
            ),
          );
        }
      },
    );
  }

  CustomAppBar buildCustomAppBar(BuildContext context) {
    FeedProvider provider = Provider.of(context);
    HomeControlProvider homeControlProvider = Provider.of(context);
    return CustomAppBar(
      onTap: () {
        if (homeControlProvider.currentIndex == 0) {
          provider.backToTop();
        }
      },
      appBar: AppBar(
        actions: <Widget>[
          IconButton(
            tooltip: "Refresh",
            onPressed: () async {
              await this.fetchTabs();
            },
            icon: Icon(Icons.refresh),
          ),
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
                  homeControlProvider.currentIndex == 0
                      ? "Headlines"
                      : provider
                          .publishers[provider.currentSelectionIndex].name,
                  key: Key("title"),
                ),
        ),
        bottom: tabController != null && homeControlProvider.currentIndex == 1
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
    );
  }

  BottomNavigationBar buildBottomNavigationBar() {
    FeedProvider provider = Provider.of(context);
    HomeControlProvider homeControlProvider = Provider.of(context);
    return BottomNavigationBar(
      currentIndex: homeControlProvider.currentIndex,
      onTap: (index) {
        homeControlProvider.currentIndex = index;
      },
      items: [
        BottomNavigationBarItem(
          title: Text(
            "Headline",
            key: Key("headline"),
          ),
          icon: Icon(Icons.view_headline),
        ),
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
    );
  }
}

/// Build news list
class NewsSearch extends SearchDelegate<String> {
  final debouncer = Debouncer<String>(Duration(milliseconds: 250));

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
            duration: Duration(milliseconds: 400),
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
    return Center(
      child: Text("Press Search"),
    );
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
