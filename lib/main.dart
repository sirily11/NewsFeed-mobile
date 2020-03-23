import 'package:flutter/foundation.dart';
import 'package:flutter/material.dart';
import 'package:newsfeed_mobile/Home/HomePage.dart';
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
          create: (_) => DatabaseProvider(),
        )
      ],
      child: MaterialApp(
        initialRoute: "/",
        routes: {
          '/': (context) => HomePage(),
          '/settings': (context) => NewsSourceList(),
          '/users': (context) => UserPage()
        },
        title: 'Flutter Demo',
        darkTheme: ThemeData.dark(),
        theme:
            ThemeData(primarySwatch: Colors.blue, brightness: Brightness.dark),
      ),
    );
  }
}
