import 'dart:io';

import 'package:flutter/material.dart';
import 'package:flutter_slidable/flutter_slidable.dart';
import 'package:newsfeed_mobile/Home/parts/drawer.dart';
import 'package:newsfeed_mobile/master-detail/master_detail_route.dart';
import 'package:newsfeed_mobile/models/DatabaseProvider.dart';
import 'package:newsfeed_mobile/models/FeedProvider.dart';
import 'package:newsfeed_mobile/models/FeedSource.dart';
import 'package:provider/provider.dart';
import 'package:shared_preferences/shared_preferences.dart';

class SettingsPage extends StatelessWidget {
  @override
  Widget build(BuildContext context) {
    FeedProvider provider = Provider.of(context);
    return Scaffold(
      drawer: DrawerWidget(),
      appBar: AppBar(
        title: Text("Settings"),
      ),
      body: ListView(
        children: <Widget>[
          SwitchListTile(
            onChanged: (v) {
              provider.enableInfiniteScroll = v;
            },
            value: provider.enableInfiniteScroll,
            title: Text("Enable Infinite Scroll"),
            subtitle: Text("Performance may be slower"),
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
