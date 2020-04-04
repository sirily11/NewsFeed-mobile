import 'package:flutter/foundation.dart';
import 'package:flutter/material.dart';
import 'package:newsfeed_mobile/Home/HomePage.dart';
import 'package:newsfeed_mobile/Settings/ColorSettingsPage.dart';
import 'package:newsfeed_mobile/Settings/FontSettingsPage.dart';
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
          create: (_) => DatabaseProvider(),
        )
      ],
      child: Builder(
        builder: (context) {
          var provider = Provider.of<HomeControlProvider>(context);
          return MaterialApp(
            initialRoute: "/",
            routes: {
              '/': (context) {
                DatabaseProvider provider = Provider.of(context);
                return HomePage();
              },
              '/settings': (context) => SettingsPage(),
              '/users': (context) => UserPage(),
              '/news-source': (context) => NewsSourceList(),
              '/color-settings': (context) => ColorSettingsPage(),
              '/font-settings': (context) => FontSettingsPage()
            },
            title: 'Flutter Demo',
            darkTheme: ThemeData.dark().copyWith(
              primaryColor:
                  provider.primaryColor ?? ThemeData.dark().primaryColor,
              buttonColor: provider.tagColor ?? ThemeData.dark().buttonColor,
              textTheme: ThemeData.dark().textTheme.apply(
                    fontFamily:
                        provider.fontSelections?.font?.bodyText1?.fontFamily,
                  ),
            ),
            theme: ThemeData(
              primaryColor: provider.primaryColor ?? ThemeData().primaryColor,
              buttonColor: provider.tagColor ?? ThemeData().primaryColor,
              textTheme: ThemeData().textTheme.apply(
                    fontFamily:
                        provider.fontSelections?.font?.bodyText1?.fontFamily,
                  ),
            ),
            themeMode:
                provider.enableDarkmode ? ThemeMode.dark : ThemeMode.light,
          );
        },
      ),
    );
  }
}
