import 'package:flutter/material.dart';
import 'package:newsfeed_mobile/Home/HomePage.dart';
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
          builder: (_) => FeedProvider(),
        ),
        ChangeNotifierProvider(
          builder: (_) => HomeControlProvider(),
        )
      ],
      child: MaterialApp(
          title: 'Flutter Demo',
          darkTheme: ThemeData.dark(),
          theme: ThemeData(
              primarySwatch: Colors.blue, brightness: Brightness.dark),
          home: HomePage()),
    );
  }
}