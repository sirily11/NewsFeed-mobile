import 'dart:io';

import 'package:flutter/material.dart';
import 'package:flutter_slidable/flutter_slidable.dart';
import 'package:newsfeed_mobile/Home/parts/drawer.dart';
import 'package:newsfeed_mobile/master-detail/master_detail_route.dart';
import 'package:newsfeed_mobile/models/DatabaseProvider.dart';
import 'package:newsfeed_mobile/models/FeedProvider.dart';
import 'package:newsfeed_mobile/models/FeedSource.dart';
import 'package:newsfeed_mobile/models/HomeControlProvider.dart';
import 'package:provider/provider.dart';
import 'package:shared_preferences/shared_preferences.dart';

class SettingsPage extends StatelessWidget {
  @override
  Widget build(BuildContext context) {
    FeedProvider provider = Provider.of(context);
    HomeControlProvider homeControlProvider = Provider.of(context);

    return Scaffold(
      drawer: DrawerWidget(),
      appBar: AppBar(
        title: Text("Settings"),
      ),
      body: ListView(
        children: <Widget>[
          SwitchListTile(
            key: Key("enable_infiniteScroll"),
            onChanged: (v) {
              provider.enableInfiniteScroll = v;
            },
            value: provider.enableInfiniteScroll,
            title: Text("Enable Infinite Scroll"),
            subtitle: Text("Performance may be slower"),
          ),
          SwitchListTile(
            key: Key("enable_image"),
            onChanged: (v) {
              homeControlProvider.enableImage = v;
            },
            value: homeControlProvider.enableImage,
            title: Text("Enable Image"),
            subtitle: Text("Data usage will increase"),
          ),
          SwitchListTile(
            key: Key("enable_darkmode"),
            onChanged: (v) {
              homeControlProvider.enableDarkmode = v;
            },
            value: homeControlProvider.enableDarkmode,
            title: Text("Enable Darkmode"),
          ),
          ListTile(
            onTap: () {
              Navigator.pushNamed(context, "/color-settings");
            },
            title: Text("Set color"),
            trailing: Icon(Icons.more_horiz),
          ),
          ListTile(
            onTap: () {
              Navigator.pushNamed(context, "/font-settings");
            },
            title: Text("Set Font"),
            trailing: Icon(Icons.more_horiz),
          ),
          ListTile(
            onTap: () {
              Navigator.pushNamed(context, "/news-source");
            },
            title: Text("Add news source"),
            trailing: Icon(Icons.more_horiz),
          )
        ],
      ),
    );
  }
}
