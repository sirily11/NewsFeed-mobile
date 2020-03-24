import 'package:flutter/foundation.dart';
import 'package:flutter/material.dart';
import 'package:newsfeed_mobile/Home/HomePage.dart';
import 'package:newsfeed_mobile/Settings/NewsSourceList.dart';
import 'package:newsfeed_mobile/Settings/SettingPage.dart';
import 'package:newsfeed_mobile/account/UserPage.dart';
import 'package:newsfeed_mobile/models/DatabaseProvider.dart';
// import 'package:newsfeed_mobile/models/DatabaseProviderWeb.dart';
import 'package:newsfeed_mobile/models/FeedProvider.dart';
import 'package:newsfeed_mobile/models/HomeControlProvider.dart';
import 'package:provider/provider.dart';

void main() => runApp(MyApp());

class MyApp extends StatelessWidget {
  // This widget is the root of your application.
  @override
  Widget build(BuildContext context) {
    return MultiProvider(
      providers: [
        ChangeNotifierProvider(
          create: (_) => FeedProvider(),
        ),
        ChangeNotifierProvider(
          create: (_) => HomeControlProvider(),
        ),
        ChangeNotifierProvider(
          create: (_) {
            var provider = DatabaseProvider();
            provider.init();
            return provider;
          },
        )
      ],
      child: MaterialApp(
        initialRoute: "/",
        routes: {
          '/': (context) => HomePage(),
          '/settings': (context) => SettingsPage(),
          '/users': (context) => UserPage(),
          '/news-source': (context) => NewsSourceList()
        },
        title: 'Flutter Demo',
        darkTheme: ThemeData.dark(),
        theme:
            ThemeData(primarySwatch: Colors.blue, brightness: Brightness.dark),
      ),
    );
  }
}
